import 'package:camera/camera.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter_helper/src/image/base_image_container.dart';
import 'package:tflite_flutter_helper/src/image/image_conversions.dart';
import 'package:tflite_flutter_helper/src/tensorbuffer/tensorbuffer.dart';
import 'package:tflite_flutter_helper/src/image/color_space_type.dart';

class ImageContainer extends BaseImageContainer {
  late final Image _image;

  ImageContainer._(Image image) {
    this._image = image;
  }

  static ImageContainer create(Image image) {
    return ImageContainer._(image);
  }

  @override
  BaseImageContainer clone() {
    return create(_image.clone());
  }

  @override
  ColorSpaceType get colorSpaceType {
    final bytes = _image.getBytes();
    int len = bytes.length;
    bool isGrayscale = true;
    for (int i = (len / 4).floor(); i < len; i++) {
      if (bytes[i] != 0) {
        isGrayscale = false;
        break;
      }
    }
    if (isGrayscale) {
      return ColorSpaceType.GRAYSCALE;
    } else {
      return ColorSpaceType.RGB;
    }
  }

  @override
  TensorBuffer getTensorBuffer(dynamic dataType) {
    TensorBuffer buffer = TensorBuffer.createDynamic(dataType);
    ImageConversions.convertImageToTensorBuffer(image, buffer);
    return buffer;
  }

  @override
  int get height => _image.height;

  @override
  Image get image => _image;

  @override
  CameraImage get mediaImage => throw UnsupportedError(
      'Converting from Image to CameraImage is unsupported');

  @override
  int get width => _image.width;
}
