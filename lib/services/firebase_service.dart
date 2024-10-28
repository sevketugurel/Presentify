import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseService {
  static Future<String?> uploadVideoToFirebase(XFile video) async {
    try {
      final fileName = video.name;
      final ref = FirebaseStorage.instance.ref().child('videos/$fileName');
      await ref.putFile(File(video.path));
      return await ref.getDownloadURL();
    } catch (e) {
      print('Firebase upload error: $e');
      return null;
    }
  }
}
