import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  static Future<String?> uploadImage({
    required Uint8List imageByte,
    required String fileName,
    required bool isExist,
    required bool isProfile,
  }) async {
    try {
      final supabase = Supabase.instance.client;
      final bucketName = isProfile ? 'profile-picture' : 'team-logo';

      // Upload to Supabase Storage
      if (isExist) {
        await supabase.storage
            .from(bucketName)
            .updateBinary(fileName, imageByte);
      } else {
        await supabase.storage
            .from(bucketName)
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
