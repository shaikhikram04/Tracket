import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tracket/authentication/services/firebase_auth_methods.dart';

class SupabaseServices {
  static Future<String?> uploadImage(Uint8List imageByte) async {
    try {
      final supabase = Supabase.instance.client;

      // Generate unique filename
      final fileName = '${FirebaseAuthMethods().currentUserId}.jpg';

      // Upload to Supabase Storage
      await supabase.storage
          .from('profile-picture')
          .uploadBinary(fileName, imageByte);

      final String publicUrl =
          supabase.storage.from('profile-picture').getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      print('Error uploading to Supabase: $e');
      return null;
    }
  }
}
