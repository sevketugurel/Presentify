import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

class VideoPickerService {
  static final ImagePicker _picker = ImagePicker();

  // Function to pick a video from the gallery
  static Future<XFile?> pickVideoFromGallery() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      return video;
    } catch (e) {
      print('Error picking video: $e');
      return null;
    }
  }

  // Function to upload video to Firebase
  static Future<String?> uploadVideoToFirebase(XFile video) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');
      print('Starting video upload...');
      await storageRef.putFile(File(video.path));
      final downloadUrl = await storageRef.getDownloadURL();
      print('Upload successful! Download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading video: $e');
      return null;
    }
  }
}
