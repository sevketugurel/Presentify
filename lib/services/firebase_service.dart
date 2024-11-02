// lib/services/firebase_service.dart

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseService {
  // Belirli bir yetenek klasörüne video yükleme
  static Future<String?> uploadVideoToFirebase(XFile video, int skillIndex) async {
    try {
      final fileName = video.name;
      final ref = FirebaseStorage.instance.ref().child('videos/skill$skillIndex/$fileName');
      await ref.putFile(File(video.path));
      return await ref.getDownloadURL();
    } catch (e) {
      print('Firebase upload error: $e');
      return null;
    }
  }

  // Her yetenek için video URL'lerini listeleme
  static Future<List<List<String>>> getVideoURLs(List<String> skillTitles) async {
    try {
      List<List<String>> allUrls = [];
      for (int i = 0; i < skillTitles.length; i++) {
        String skillFolder = 'videos/skill$i/';
        final ListResult result = await FirebaseStorage.instance.ref(skillFolder).listAll();
        List<String> urls = [];
        for (var ref in result.items) {
          final url = await ref.getDownloadURL();
          urls.add(url);
        }
        allUrls.add(urls);
      }
      return allUrls;
    } catch (e) {
      print('Firebase retrieval error: $e');
      return [];
    }
  }
}
