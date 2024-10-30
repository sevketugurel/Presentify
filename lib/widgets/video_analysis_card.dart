import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/widgets/video_picker_service.dart'; // Doğru import yolunu kontrol edin
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Özel yükleme animasyonları için
import 'package:path/path.dart' as path; // Dosya adı almak için
import 'package:flutter_dotenv/flutter_dotenv.dart'; // .env dosyası için
import '../services/gemini_service.dart'; // GeminiService'ınızı import edin
import 'package:video_player/video_player.dart'; // Video önizlemesi için

class VideoAnalysisCard extends StatefulWidget {
  final Function(String) onAnalysisComplete;

  const VideoAnalysisCard({Key? key, required this.onAnalysisComplete}) : super(key: key);

  @override
  _VideoAnalysisCardState createState() => _VideoAnalysisCardState();
}

class _VideoAnalysisCardState extends State<VideoAnalysisCard> {
  XFile? _selectedVideo;
  String? _downloadUrl;
  bool _isUploading = false; // Yükleme durumunu takip eder
  bool _isAnalyzed = false;  // Videonun analiz edilip edilmediğini takip eder
  late final GeminiService _geminiService;
  VideoPlayerController? _videoController; // Video önizlemesi için

  @override
  void initState() {
    super.initState();
    // API anahtarını .env dosyasından alın
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _geminiService = GeminiService(apiKey);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _uploadAndAnalyzeVideo() async {
    if (_selectedVideo == null) return;

    setState(() {
      _isUploading = true;
      _isAnalyzed = false;
    });

    try {
      // Firebase'e video yükle
      _downloadUrl = await VideoPickerService.uploadVideoToFirebase(_selectedVideo!);

      if (_downloadUrl != null) {
        // Gemini API ile videoyu analiz et
        final analysisResult = await _geminiService.analyzeVideoByUrl(_downloadUrl!);

        setState(() {
          _isUploading = false;
          _isAnalyzed = true;
        });

        // Sonucu üst widget'a gönder (örneğin, HomeScreen)
        if (analysisResult != null) {
          widget.onAnalysisComplete(analysisResult);
        } else {
          _showError('Analiz sonucu alınamadı.');
        }
      } else {
        _showError('Video yükleme başarısız oldu.');
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      _showError('Bir hata oluştu: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Future<void> _pickVideo() async {
    final video = await VideoPickerService.pickVideoFromGallery();
    if (video != null) {
      setState(() {
        _selectedVideo = video;
        _isAnalyzed = false;
      });
      _initializeVideoPlayer();
    }
  }

  Future<void> _initializeVideoPlayer() async {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(File(_selectedVideo!.path))
      ..initialize().then((_) {
        setState(() {});
        _videoController!.setLooping(true);
        _videoController!.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    // Altın oranı: 1.618
    // Örneğin, buton yüksekliğini 18'dan yaklaşık 11 olarak ayarlayabiliriz (18 / 1.618 ≈ 11.14)
    // Benzer şekilde, font boyutunu da küçülteceğiz.

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 12,
      shadowColor: Colors.black38, // Daha belirgin gölge
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Video Analizi',
              style: GoogleFonts.roboto(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _isUploading ? null : _pickVideo,
              child: Container(
                height: 180,
                decoration: _selectedVideo == null
                    ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.blueGrey[100]!,
                    width: 2,
                  ),
                )
                    : null, // Video seçilmişse dekorasyonu kaldır
                child: Center(
                  child: _selectedVideo == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_library,
                        color: Colors.white70,
                        size: 60,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Videoyu Yüklemek İçin Dokunun',
                        style: GoogleFonts.roboto(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                      : Stack(
                    children: [
                      _videoController != null && _videoController!.value.isInitialized
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        ),
                      )
                          : Center(
                        child: SpinKitCircle(
                          color: Colors.white,
                          size: 50.0,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedVideo = null;
                              _videoController?.dispose();
                              _videoController = null;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (_selectedVideo == null || _isUploading) ? null : _uploadAndAnalyzeVideo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 22.0), // Altın oranına göre küçültülmüş padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 6,
              ),
              child: _isUploading
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SpinKitFadingCircle(
                    color: Colors.white,
                    size: 24.0,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Analiz Yapılıyor...',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 11.0, // Altın oranına göre küçültülmüş font boyutu
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
                  : Text(
                'Analizi Başlat',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 15.0, // Altın oranına göre küçültülmüş font boyutu
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (_isAnalyzed) ...[
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Colors.teal,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.teal[700],
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Analiz başarıyla tamamlandı! Sonuçları görmek için aşağı kaydırın.',
                        style: GoogleFonts.roboto(
                          color: Colors.teal[800],
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
