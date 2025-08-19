# [1.0.0] - Major Breaking Changes
* **Breaking:** All type parameters for TensorBuffer, TensorImage, etc. must now be specified as strings (e.g., 'uint8', 'float32'), not enums like TfLiteType.uint8.
* **Breaking:** Updated all image/tensor buffer APIs for latest image package and Flutter 3.x+ compatibility.
* **Breaking:** Test code and documentation updated for new API and type usage.
* **Migration:** See README for updated usage and migration guide.
# [0.3.0] - Audio Support and Task Library
* Added support for audio-cases.
* Task Library for Text based applications.

# [0.2.2] - Image Package Update
* Update Image APIs.

# [0.2.1] - TFLite Flutter dependency update

* Updated to tflite_flutter: ^0.9.0

# [0.2.0] - Migrate to null-safety
* Stable null-safety
* Depends on tflite_flutter: ^0.8.0
* Custom Crop position in ResizeWithCropOrPad

# [0.1.2] - BoundingBox bfix

* Fixed bounding box orderedValues

# [0.1.1] - TFLite Flutter dependency update

* Updated to tflite_flutter: ^0.5.0

# [0.1.0] - TFLite Flutter Helper

* Initial release.
