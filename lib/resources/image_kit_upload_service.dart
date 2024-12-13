import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class ImageKitUploadService {
  final String publicKey;
  final String privateKey;
  final String urlEndpoint;

  ImageKitUploadService({
    required this.publicKey,
    required this.privateKey,
    required this.urlEndpoint,
  });

  /// Generate authentication parameters
  Map<String, String> _generateAuthParams() {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final expire = (timestamp + 3600).toString(); // 1 hour into the future

    // Generate token
    final token = '$timestamp$publicKey';

    // Generate signature
    final key = utf8.encode(privateKey);
    final bytes = utf8.encode('$token:$expire');
    final hmacSha1 = Hmac(sha1, key);
    final signature = hmacSha1.convert(bytes).toString();

    return {
      'publicKey': publicKey,
      'signature': signature,
      'timestamp': timestamp.toString(),
      'token': token,
      'expire': expire,
    };
  }

  /// Upload image
  Future<String?> uploadImage({
    required File imageFile,
    String? fileName,
    String? folder,
    Map<String, String>? customMetadata,
  }) async {
    try {
      // Prepare authentication parameters
      final authParams = _generateAuthParams();

      // Prepare file details
      final fileBytes = await imageFile.readAsBytes();
      // ignore: unused_local_variable
      final mimeType =
          lookupMimeType(imageFile.path) ?? 'application/octet-stream';
      final uploadFileName = fileName ?? imageFile.path.split('/').last;

      // Prepare multipart request
      final request = http.MultipartRequest(
          'POST', Uri.parse('https://ik.imagekit.io/nxbc7obw9qopw/'));

      // Add authentication and file details
      request.fields['publicKey'] = authParams['publicKey']!;
      request.fields['signature'] = authParams['signature']!;
      request.fields['timestamp'] = authParams['timestamp']!;
      request.fields['token'] = authParams['token']!;
      request.fields['expire'] = authParams['expire']!;
      request.fields['fileName'] = uploadFileName;

      // Optional parameters
      if (folder != null) request.fields['folder'] = folder;
      if (customMetadata != null) {
        request.fields['customMetadata'] = json.encode(customMetadata);
      }

      // Add file
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: uploadFileName,
      ));

      // Send request and get response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Parse response
      final responseBody = response.body;
      final responseJson = json.decode(responseBody);

      // Check for successful upload
      if (response.statusCode == 200) {
        return responseJson['url'];
      } else {
        debugPrint('Upload failed: $responseBody');
        return null;
      }
    } catch (e) {
      debugPrint('ImageKit Upload Error: $e');
      return null;
    }
  }

  /// Upload image for web (using memory bytes)
  Future<String?> uploadWebImage({
    required Uint8List imageBytes,
    required String fileName,
    String? folder,
    Map<String, String>? customMetadata,
  }) async {
    try {
      // Prepare authentication parameters
      final authParams = _generateAuthParams();

      // Prepare multipart request
      final request = http.MultipartRequest(
          'POST', Uri.parse('https://upload.imagekit.io/api/v1/files/upload'));

      // Add authentication and file details
      request.fields['publicKey'] = authParams['publicKey']!;
      request.fields['signature'] = authParams['signature']!;
      request.fields['timestamp'] = authParams['timestamp']!;
      request.fields['token'] = authParams['token']!;
      request.fields['expire'] = authParams['expire']!;
      request.fields['fileName'] = fileName;

      // Optional parameters
      if (folder != null) request.fields['folder'] = folder;
      if (customMetadata != null) {
        request.fields['customMetadata'] = json.encode(customMetadata);
      }

      // Add file
      request.files.add(
          http.MultipartFile.fromBytes('file', imageBytes, filename: fileName));

      // Send request and get response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Parse response
      final responseBody = response.body;
      final responseJson = json.decode(responseBody);

      // Check for successful upload
      if (response.statusCode == 200) {
        return responseJson['url'];
      } else {
        debugPrint('Upload failed: $responseBody');
        return null;
      }
    } catch (e) {
      debugPrint('ImageKit Upload Web Error: $e');
      return null;
    }
  }
}
