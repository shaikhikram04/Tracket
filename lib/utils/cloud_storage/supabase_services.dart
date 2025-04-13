import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  static Future<String?> uploadImage({
    required Uint8List imageByte,
    required String fileName,
    required bool isExist,
  }) async {
    try {
      final supabase = Supabase.instance.client;

      // Upload to Supabase Storage
      if (isExist) {
        await supabase.storage
            .from('profile-picture')
            .updateBinary(fileName, imageByte);
      } else {
        await supabase.storage
            .from('profile-picture')
            .uploadBinary(fileName, imageByte);
      }

      final String publicUrl =
          supabase.storage.from('profile-picture').getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      print('Error uploading to Supabase: $e');
      return null;
    }
  }
}
