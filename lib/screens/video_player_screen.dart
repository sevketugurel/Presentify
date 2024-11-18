import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _isPlaying = false;

  final List<FeedbackItem> feedbackItems = [
    FeedbackItem(
      startTime: const Duration(seconds: 0),
      endTime: const Duration(seconds: 5),
      message: "Bu bölümde konuşmacı 'Değerli katılımcılar' diyerek çok etkili bir giriş yaptı. Ses tonu ve duruşu oldukça profesyoneldi. Giriş kısmında ek olarak konuşmanın ana hatlarından kısaca bahsedebilirdi, böylece dinleyiciler kendilerini bekleyen içeriğe daha iyi hazırlanabilirdi.",
    ),
    FeedbackItem(
      startTime: const Duration(seconds: 15),
      endTime: const Duration(seconds: 20),
      message: "Konuşmacının rakamları vurgularken elleriyle görsel destek oluşturması harika bir detay. Özellikle market büyüklüğünü anlatırken kullandığı el hareketleri konunun akılda kalıcılığını artırıyor. Bu kısımda ek olarak grafiklerle karşılaştırma yaparken ekrana daha yakın durabilirdi.",
    ),
    FeedbackItem(
      startTime: const Duration(seconds: 30),
      endTime: const Duration(seconds: 35),
      message: "Ürün demosuna geçiş çok akıcı olmuş. Özellikle 'Şimdi size bunun nasıl çalıştığını göstereceğim' cümlesi ile dinleyicilerin dikkatini çekmeyi başardı. Demo öncesi 2-3 saniyelik bir duraklama yapsaydı, geçişin etkisi daha da güçlü olabilirdi.",
    ),
    FeedbackItem(
      startTime: const Duration(seconds: 45),
      endTime: const Duration(seconds: 50),
      message: "Müşteri örneğini anlatırken kullandığı hikayeleştirme tekniği çok başarılı. Özellikle 'Geçen ay yaşanan bir örneği paylaşayım' diye başlaması dinleyicileri hemen içine çekti. Bu hikayeyi anlatırken sahnenin farklı noktalarını kullanarak hikayedeki karakterleri canlandırabilirdi, bu görsellik sunumu daha etkileyici yapardı.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
      });

    _controller.addListener(() {
      setState(() {}); // Rebuild for time updates
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes);
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Video Örnekleri'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: _initialized ? _controller.value.aspectRatio : 16 / 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_initialized)
                    VideoPlayer(_controller)
                  else
                    const CircularProgressIndicator(color: Colors.white),
                  if (_initialized)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                      _isPlaying ? _controller.play() : _controller.pause();
                    });
                  },
                ),
                Text(
                  _initialized
                      ? '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}'
                      : '00:00 / 00:00',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: feedbackItems.length,
              itemBuilder: (context, index) {
                final feedback = feedbackItems[index];
                return GestureDetector(
                  onTap: () {
                    _controller.seekTo(feedback.startTime);
                    setState(() {
                      _isPlaying = true;
                    });
                    _controller.play();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.blue[700],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_formatDuration(feedback.startTime)} - ${_formatDuration(feedback.endTime)}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  feedback.message,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackItem {
  final Duration startTime;
  final Duration endTime;
  final String message;

  FeedbackItem({
    required this.startTime,
    required this.endTime,
    required this.message,
  });
}