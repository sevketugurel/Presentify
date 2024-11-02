// lib/screens/past_analyses_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../widgets/analysis_card.dart'; // Mevcut AnalysisCard widget'ınızı kullanmaya devam ediyoruz

class PastAnalysesScreen extends StatelessWidget {
  // Örnek veri listesi
  final List<Map<String, String>> pastAnalyses = [
    {
      'title': 'Sunum Öncesi Stres Yönetimi',
      'date': '2024-04-15',
      'result': 'Sunum öncesi stres yönetimi konusunda başarılı sonuçlar elde ettiniz. Beden dilinizi ve ses tonunuzu etkili bir şekilde kullanarak, izleyicilerinizle güçlü bir bağ kurmayı başardınız.',
      'videoUrl': 'https://www.example.com/video1.mp4', // Video URL'sini buraya ekleyin
    },
    {
      'title': 'Ses Kullanımı Analizi',
      'date': '2024-03-10',
      'result': 'Ses kullanımı analizinde orta seviyede performans sergilediniz. Ses tonunuzun daha dinamik ve çeşitli olmasına özen gösterebilirsiniz.',
      'videoUrl': 'https://www.example.com/video2.mp4',
    },
    // Daha fazla analiz ekleyebilirsiniz
  ];

  PastAnalysesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold'un arka plan rengini temaya uygun hale getirin
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Geçmiş Analizler',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        centerTitle: true,
      ),
      body: pastAnalyses.isEmpty
          ? Center(
        child: Text(
          'Henüz geçmiş analiziniz bulunmamaktadır.',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: pastAnalyses.length,
          itemBuilder: (context, index) {
            final analysis = pastAnalyses[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Analiz Başlığı ve Tarihi
                AnalysisCard(
                  title: analysis['title'] ?? '',
                  date: analysis['date'] ?? '',
                ),
                const SizedBox(height: 10),
                // Video Oynatıcı
                VideoPlayerWidget(videoUrl: analysis['videoUrl'] ?? ''),
                const SizedBox(height: 10),
                // Analiz Sonucu Metni
                FadeOutText(text: analysis['result'] ?? ''),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
      // Alt navigasyon çubuğunu ekleyin (MainScreen'den kullanılıyor)
    );
  }
}

// VideoPlayerWidget: Video URL'sini alır ve oynatır
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(false);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_controller),
          if (!_controller.value.isPlaying)
            IconButton(
              iconSize: 50,
              icon: Icon(
                Icons.play_circle_fill,
                color: Colors.white.withOpacity(0.7),
              ),
              onPressed: () {
                setState(() {
                  _controller.play();
                });
              },
            ),
        ],
      ),
    )
        : Container(
      height: 200,
      color: Colors.grey[300],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// FadeOutText: Metni kısmen görünür ve soluklaşacak şekilde gösterir
class FadeOutText extends StatelessWidget {
  final String text;

  const FadeOutText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Metin kutusunun yüksekliği
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          // Soluklaşma efekti için gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 30,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white, // Gradient rengi arka planla uyumlu olmalı
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
