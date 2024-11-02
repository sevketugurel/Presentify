// lib/screens/skill_detail_screen.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../models/video_content.dart';

class SkillDetailScreen extends StatefulWidget {
  final String title;
  final List<VideoContent> videoContents;

  SkillDetailScreen({
    required this.title,
    required this.videoContents,
  });

  @override
  _SkillDetailScreenState createState() => _SkillDetailScreenState();
}

class _SkillDetailScreenState extends State<SkillDetailScreen> {
  // VideoPlayerController'ları yöneten bir harita
  final Map<int, VideoPlayerController> _controllers = {};

  @override
  void dispose() {
    // Tüm controller'ları dispose ediyoruz
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Belirli bir index için VideoPlayerController oluşturma veya alma
  Future<VideoPlayerController> _initializeController(int index) async {
    if (_controllers.containsKey(index)) {
      return _controllers[index]!;
    } else {
      var controller = VideoPlayerController.network(widget.videoContents[index].videoUrl);
      await controller.initialize();
      setState(() {
        _controllers[index] = controller;
      });
      return controller;
    }
  }

  Widget _buildVideoItem(BuildContext context, int index) {
    return VisibilityDetector(
      key: Key('video-item-$index'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction == 0) {
          // Video görünür değilse, controller'ı dispose ediyoruz
          if (_controllers.containsKey(index)) {
            _controllers[index]!.dispose();
            _controllers.remove(index);
          }
        } else {
          // Video görünürse, controller'ı başlatıyoruz
          _initializeController(index);
        }
      },
      child: FutureBuilder<VideoPlayerController>(
        future: _initializeController(index),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            final controller = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.videoContents[index].subtitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.videoContents[index].description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Video yüklenirken veya controller henüz hazır değilken gösterilecek widget
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Container(
                height: 200,
                color: Colors.grey[300],
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ekran video listesiyle başlıyor
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.videoContents.length,
        itemBuilder: _buildVideoItem,
      ),
    );
  }
}
