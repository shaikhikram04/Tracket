import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UploadthingStorageMethod {
  Future<String?> uploadImage(String filePath) async {

    //! Need to update
    final String apiKey = dotenv.env['UPLOADTHING_API_KEY']!;
    const String uploadUrl = "https://uploadthing.com/api/upload";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.headers['Authorization'] = 'Bearer $apiKey';
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        String imageUrl =
            jsonResponse['url']; // Assuming the response includes a 'url' field
        return imageUrl;
      } else {
        print("Failed to upload image: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
    return null;
  }
}
