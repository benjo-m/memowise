import 'dart:developer';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:mobile/config/constants.dart';
import 'package:mobile/services/auth/current_user.dart';

class ImageUploadService {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> pickAndUploadImage() async {
    // Pick an image from gallery
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null || image!.path.isNotEmpty) {
      // Convert the image to bytes
      final imageBytes = await image.readAsBytes();

      // Call the backend to upload the image
      await uploadImage(imageBytes);

      return imageBytes;
    }
    return null;
  }

  Future<void> uploadImage(Uint8List imageBytes) async {
    final Uri uri = Uri.parse('$baseUrl/image/uploadimage');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes('image', imageBytes,
          filename: 'image.jpg'))
      ..headers['Authorization'] =
          CurrentUser.authHeader ?? ""; // Add the Authorization header

    final response = await request.send();

    if (response.statusCode == 200) {
      log('Image uploaded successfully');
    } else {
      log('Failed to upload image');
    }
  }

  Future<Uint8List> fetchImage(int id) async {
    final Uri uri = Uri.parse('$baseUrl/image/getimage/1');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Return the image bytes
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }
}
