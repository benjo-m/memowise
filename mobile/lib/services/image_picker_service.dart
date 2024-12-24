import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null || image!.path.isNotEmpty) {
      final imageBytes = await image.readAsBytes();
      return imageBytes;
    }
    return null;
  }
}
