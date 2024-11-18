
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseService {
  // Her yetenek için video ve thumbnail URL'lerini listeleme
  static Future<List<List<Map<String, String>>>> getVideoAndThumbnailURLs(List<String> skillTitles) async {
    try {
      List<List<Map<String, String>>> allData = [];
      for (int i = 0; i < skillTitles.length; i++) {
        String skillFolder = 'videos/skill$i/';
        final ListResult result = await FirebaseStorage.instance.ref(skillFolder).listAll();
        List<Map<String, String>> skillData = [];
        for (var ref in result.items) {
          final fileName = ref.name;
          if (fileName.endsWith('.mp4')) {
            final videoUrl = await ref.getDownloadURL();
            // Thumbnail dosyasının ismini tahmin edelim (örn: video1.mp4 -> video1_thumbnail.jpg)
            final thumbnailName = fileName.replaceAll('.mp4', '_thumbnail.jpg');
            final thumbnailRef = FirebaseStorage.instance.ref('$skillFolder$thumbnailName');
            String thumbnailUrl;
            try {
              thumbnailUrl = await thumbnailRef.getDownloadURL();
            } catch (e) {
              // Thumbnail bulunamazsa, placeholder kullanabilirsiniz
              thumbnailUrl = 'https://via.placeholder.com/150';
            }
            skillData.add({
              'videoUrl': videoUrl,
              'thumbnailUrl': thumbnailUrl,
            });
          }
        }
        allData.add(skillData);
      }
      return allData;
    } catch (e) {
      print('Firebase retrieval error: $e');
      return [];
    }
  }
}
