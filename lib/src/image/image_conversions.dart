import 'package:image/image.dart';
import 'package:tflite_flutter_helper/src/image/color_space_type.dart';
import 'package:tflite_flutter_helper/src/tensorbuffer/tensorbuffer.dart';

/// Implements some stateless image conversion methods.
///
/// This class is an internal helper.
class ImageConversions {
  static Image convertRgbTensorBufferToImage(TensorBuffer buffer) {
    List<int> shape = buffer.getShape();
    ColorSpaceType rgb = ColorSpaceType.RGB;
    rgb.assertShape(shape);

    int h = rgb.getHeight(shape);
    int w = rgb.getWidth(shape);
    Image image = Image(width: w, height: h);

    List<int> rgbValues = buffer.getIntList();
    assert(rgbValues.length == w * h * 3);

    for (int i = 0, j = 0, wi = 0, hi = 0; j < rgbValues.length; i++) {
      int r = rgbValues[j++];
      int g = rgbValues[j++];
      int b = rgbValues[j++];
      image.setPixelRgba(wi, hi, r, g, b, 255);
      wi++;
      if (wi % w == 0) {
        wi = 0;
        hi++;
      }
    }

    return image;
  }

  static Image convertGrayscaleTensorBufferToImage(TensorBuffer buffer) {
    // Convert buffer into Uint8 as needed.
    final typeStr = buffer.getDataType().toString().toLowerCase();
    TensorBuffer uint8Buffer = typeStr.contains('uint8')
        ? buffer
        : TensorBuffer.createFrom(buffer, 'uint8');

    final shape = uint8Buffer.getShape();
    final grayscale = ColorSpaceType.GRAYSCALE;
    grayscale.assertShape(shape);

    final image = Image.fromBytes(
      width: grayscale.getWidth(shape),
      height: grayscale.getHeight(shape),
      bytes: uint8Buffer.getBuffer(),
    );

    return image;
  }

  static void convertImageToTensorBuffer(Image image, TensorBuffer buffer) {
    int w = image.width;
    int h = image.height;
    // image.getBytes()는 Uint8List 반환
    final intValues = image.getBytes();
    int flatSize = w * h * 3;
    List<int> shape = [h, w, 3];
    final typeStr = buffer.getDataType().toString().toLowerCase();
    if (typeStr.contains('uint8')) {
      List<int> byteArr = List.filled(flatSize, 0);
      for (int i = 0, j = 0; i < w * h; i++) {
        byteArr[j++] = ((intValues[i]) & 0xFF);
        byteArr[j++] = ((intValues[i] >> 8) & 0xFF);
        byteArr[j++] = ((intValues[i] >> 16) & 0xFF);
      }
      buffer.loadList(byteArr, shape: shape);
    } else if (typeStr.contains('float32')) {
      List<double> floatArr = List.filled(flatSize, 0.0);
      for (int i = 0, j = 0; i < w * h; i++) {
        floatArr[j++] = ((intValues[i]) & 0xFF).toDouble();
        floatArr[j++] = ((intValues[i] >> 8) & 0xFF).toDouble();
        floatArr[j++] = ((intValues[i] >> 16) & 0xFF).toDouble();
      }
      buffer.loadList(floatArr, shape: shape);
    } else {
      throw StateError(
          "${buffer.getDataType()} is unsupported with TensorBuffer.");
    }
  }
}
