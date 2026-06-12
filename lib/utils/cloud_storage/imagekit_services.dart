import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ImageKitServices {
  static const String _baseUrl = 'https://upload.imagekit.io/api/v1/files/upload';

  /// Upload image to ImageKit.io
  /// 
  /// Parameters:
  /// - imageByte: The image data as bytes
  /// - fileName: The name of the file (e.g., 'team-logo.jpg')
  /// - isProfile: Whether this is a profile picture (determines folder)
  /// - isExist: Whether to replace existing file (not used in ImageKit, just for interface compatibility)
  /// 
  /// Returns: The public URL of the uploaded image, or null if upload fails
  static Future<String?> uploadImage({
    required Uint8List imageByte,
    required String fileName,
    required bool isExist,
    required bool isProfile,
  }) async {
    try {
      final privateKey = dotenv.get('IMAGEKIT_PRIVATE_KEY');
      final publicKey = dotenv.get('IMAGEKIT_PUBLIC_KEY');

      if (privateKey.isEmpty || publicKey.isEmpty) {
        throw Exception(
          'ImageKit credentials not found. Please add IMAGEKIT_PRIVATE_KEY and IMAGEKIT_PUBLIC_KEY to your .env file',
        );
      }

      // Create Basic Auth header with private key
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$privateKey:'))}';

      // Determine folder based on image type
      final folder = isProfile ? '/profile-pictures' : '/team-logos';

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

      request.headers['Authorization'] = basicAuth;

      // Add fields
      request.fields['fileName'] = fileName;
      request.fields['folder'] = folder;
      request.fields['isPrivateFile'] = 'false';

      // Add file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageByte,
          filename: fileName,
        ),
      );

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String url = responseData['url'] as String;
        return url;
      } else {
        debugPrint('Error uploading to ImageKit: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error uploading to ImageKit: $e');
      return null;
    }
  }

  /// Delete image from ImageKit.io
  /// 
  /// Parameters:
  /// - fileId: The ImageKit file ID to delete
  /// 
  /// Returns: true if deletion was successful, false otherwise
  static Future<bool> deleteImage({required String fileId}) async {
    try {
      final privateKey = dotenv.get('IMAGEKIT_PRIVATE_KEY');

      if (privateKey.isEmpty) {
        throw Exception('ImageKit private key not found in .env file');
      }

      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$privateKey:'))}';

      final response = await http.delete(
        Uri.parse('https://api.imagekit.io/v1/files/$fileId'),
        headers: {'Authorization': basicAuth},
      );

      return response.statusCode == 204;
    } catch (e) {
      debugPrint('Error deleting image from ImageKit: $e');
      return false;
    }
  }
}
