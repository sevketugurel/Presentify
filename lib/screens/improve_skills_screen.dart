import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'skill_detail_screen.dart';

class ImproveSkillsScreen extends StatefulWidget {
  @override
  _ImproveSkillsScreenState createState() => _ImproveSkillsScreenState();
}

class _ImproveSkillsScreenState extends State<ImproveSkillsScreen> {
  final List<Map<String, String>> skillTitlesAndImages = [
    {
      'title': 'Doğru Beden Dili Kullanımı',
      'image': 'lib/assets/images/body_language.png'
    },
    {
      'title': 'Konuşma Heyecanını Aşma',
      'image': 'lib/assets/images/speech_anxiety.png'
    },
    {
      'title': 'Sesin Doğru Kullanımı',
      'image': 'lib/assets/images/voice_usage.png'
    },
    {
      'title': 'Stresle Başa Çıkma',
      'image': 'lib/assets/images/speech_anxiety2.png'
    },
    {
      'title': 'Sahnedeki Doğru Duruş',
      'image': 'lib/assets/images/stage_posture.png'
    },
    {
      'title': 'Sunum Öncesi Yapılması Gerekenler',
      'image': 'lib/assets/images/presentation_prep.png'
    }
  ];

  late Future<List<List<Map<String, String>>>> _videoAndThumbnailData;

  @override
  void initState() {
    super.initState();
    _videoAndThumbnailData = FirebaseService.getVideoAndThumbnailURLs(
      skillTitlesAndImages.map((item) => item['title']!).toList(),
    );
  }

  void _navigateToSkillDetail(BuildContext context, String title, List<Map<String, String>> skillData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillDetailScreen(
          title: title,
          skillData: skillData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xFF1F2937),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 16.0, bottom: 16.0),
              expandedTitleScale: 1.0,
              title: Text(
                'Yeteneklerini Geliştir',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
                textAlign: TextAlign.left,
              ),
              centerTitle: false,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'lib/assets/images/skills_background.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
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
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yeteneklerini geliştirerek daha iyi sunumlar yapabilirsin!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aşağıdaki yeteneklerden birini seçerek gelişimine devam edebilirsin.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Skills Grid
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: FutureBuilder<List<List<Map<String, String>>>>(
              future: _videoAndThumbnailData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: _buildErrorWidget(),
                  );
                }

                final skillData = snapshot.data!;
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildSkillCard(
                      context,
                      index,
                      skillData,
                    ),
                    childCount: skillTitlesAndImages.length,
                  ),
                );
              },
            ),
          ),

          // Bottom Padding
          SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 64,
          color: Colors.red.shade300,
        ),
        SizedBox(height: 16),
        Text(
          'Bir hata oluştu\nLütfen tekrar deneyin',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red.shade300,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _videoAndThumbnailData = FirebaseService.getVideoAndThumbnailURLs(
                skillTitlesAndImages.map((item) => item['title']!).toList(),
              );
            });
          },
          icon: Icon(Icons.refresh),
          label: Text('Yenile'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillCard(
      BuildContext context,
      int index,
      List<List<Map<String, String>>> skillData,
      ) {
    final thumbnailUrl = skillData[index].isNotEmpty ? skillData[index][0]['thumbnailUrl'] ?? '' : '';
    final categoryImage = skillTitlesAndImages[index]['image']!;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _navigateToSkillDetail(
          context,
          skillTitlesAndImages[index]['title']!,
          skillData[index],
        ),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  categoryImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skillTitlesAndImages[index]['title']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${skillData[index].length} video',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}