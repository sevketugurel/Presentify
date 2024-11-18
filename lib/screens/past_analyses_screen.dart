import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const ExpandableText({
    Key? key,
    required this.text,
    this.style,
  }) : super(key: key);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;
  bool _needsExpansion = false;
  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTextHeight();
    });
  }

  void _calculateTextHeight() {
    if (!mounted) return;

    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: widget.style,
      ),
      maxLines: 3,
    );

    final size = MediaQuery.of(context).size;
    textPainter.layout(maxWidth: size.width - 32);  // Padding için 32 piksel çıkardık

    setState(() {
      _needsExpansion = textPainter.didExceedMaxLines || widget.text.length > 200;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          key: _textKey,
          style: widget.style,
          maxLines: _isExpanded ? null : 3,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.fade,
        ),
        if (_needsExpansion)
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Daha az göster' : 'Devamını oku',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

class PastAnalysesScreen extends StatelessWidget {
  final List<Map<String, String>> pastAnalyses = [
    {
      'title': 'Sunum Öncesi Stres Yönetimi',
      'date': '2024-04-15',
      'result': 'Sunum öncesi stres yönetimi konusunda başarılı sonuçlar elde ettiniz. Beden dilinizi ve ses tonunuzu etkili bir şekilde kullanarak, izleyicilerinizle güçlü bir bağ kurmayı başardınız.',
      'videoUrl': 'https://firebasestorage.googleapis.com/v0/b/body-language-analyzer.appspot.com/o/past_videos%2FSedef%20Kaba%C5%9F.mp4?alt=media&token=c56b8fa0-a64e-4c27-9e05-6e370965ca01',
      'score': '85',
    },
    {
      'title': 'Ses Kullanımı Analizi',
      'date': '2024-03-10',
      'result': 'Ses kullanımı analizinde orta seviyede performans sergilediniz. Ses tonunuzun daha dinamik ve çeşitli olmasına özen gösterebilirsiniz.',
      'videoUrl': 'https://firebasestorage.googleapis.com/v0/b/body-language-analyzer.appspot.com/o/past_videos%2F2014%20Three%20Minute%20Thesis%20winning%20presentation%20by%20Emily%20Johnston.mp4?alt=media&token=16e4bbd5-cf7b-4f52-a1ec-ea664fe4f7cd',
      'score': '72',
    },
  ];

  PastAnalysesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr_TR', null);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Geçmiş Analizler',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filtreleme modalı açılacak
            },
          ),
        ],
      ),
      body: pastAnalyses.isEmpty
          ? _buildEmptyState()
          : _buildAnalysesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz analiz bulunmuyor',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yeni bir analiz başlatmak için tıklayın',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pastAnalyses.length,
      itemBuilder: (context, index) {
        final analysis = pastAnalyses[index];
        return AnalysisItemCard(analysis: analysis);
      },
    );
  }
}

class AnalysisItemCard extends StatelessWidget {
  final Map<String, String> analysis;

  const AnalysisItemCard({
    Key? key,
    required this.analysis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final score = int.tryParse(analysis['score'] ?? '0') ?? 0;
    final date = DateTime.tryParse(analysis['date'] ?? '');
    final formattedDate = date != null
        ? DateFormat('d MMMM yyyy', 'tr_TR').format(date)
        : 'Tarih belirtilmemiş';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVideoPlayer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        analysis['title'] ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _buildScoreIndicator(score),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  formattedDate,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                ExpandableText(
                  text: analysis['result'] ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                _buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: EnhancedVideoPlayer(
          videoUrl: analysis['videoUrl'] ?? '',
        ),
      ),
    );
  }

  Widget _buildScoreIndicator(int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getScoreColor(score),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$score%',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: () {
            // Paylaşma işlemi
          },
          icon: const Icon(Icons.share_outlined),
          label: const Text('Paylaş'),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () {
            // Detay sayfasına yönlendirme
          },
          icon: const Icon(Icons.visibility_outlined),
          label: const Text('Detaylar'),
        ),
      ],
    );
  }
}
class EnhancedVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;

  const EnhancedVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.thumbnailUrl,
  }) : super(key: key);

  @override
  State<EnhancedVideoPlayer> createState() => _EnhancedVideoPlayerState();
}

class _EnhancedVideoPlayerState extends State<EnhancedVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.network(widget.videoUrl);
    try {
      await _controller.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
        });
      }
      print('Video yüklenirken hata oluştu: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return _buildErrorState();
    }

    if (!_isInitialized) {
      return _buildLoadingState();
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_controller),
          if (_showControls) _buildControls(),
          if (_showControls) _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.thumbnailUrl != null)
            Image.network(
              widget.thumbnailUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.black54,
                  child: const Icon(
                    Icons.movie,
                    color: Colors.white54,
                    size: 48,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          Container(
            color: Colors.black38,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.thumbnailUrl != null)
            Opacity(
              opacity: 0.5,
              child: Image.network(
                widget.thumbnailUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.error_outline,
                    color: Colors.white54,
                    size: 48,
                  );
                },
              ),
            ),
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Video yüklenemedi',
            style: TextStyle(color: Colors.white),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isError = false;
                _isInitialized = false;
              });
              _initializeVideo();
            },
            child: const Text('Tekrar dene'),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
        ),
        child: IconButton(
          icon: Icon(
            _controller.value.isPlaying
                ? Icons.pause_circle_filled
                : Icons.play_circle_filled,
            size: 64,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: VideoProgressIndicator(
          _controller,
          allowScrubbing: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          colors: const VideoProgressColors(
            playedColor: Colors.white,
            bufferedColor: Colors.white24,
            backgroundColor: Colors.white12,
          ),
        ),
      ),
    );
  }
}
