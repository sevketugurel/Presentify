import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'skill_detail_screen.dart';

class ImproveSkillsScreen extends StatefulWidget {
  @override
  _ImproveSkillsScreenState createState() => _ImproveSkillsScreenState();
}

class _ImproveSkillsScreenState extends State<ImproveSkillsScreen> {
  final List<String> skillTitles = [
    'Doğru Beden Dili Kullanımı',
    'Konuşma Heyecanını Aşma',
    'Sesin Doğru Kullanımı',
    'Stresle Başa Çıkma',
    'Sahnedeki Doğru Duruş',
    'Sunum Öncesi Yapılması Gerekenler'
  ];

  late Future<List<List<Map<String, String>>>> _videoAndThumbnailData;

  @override
  void initState() {
    super.initState();
    _videoAndThumbnailData = FirebaseService.getVideoAndThumbnailURLs(skillTitles);
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
            backgroundColor: Color(0xFF1F2937), // Koyu gri-mavi tonu
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 16.0, bottom: 16.0),
              expandedTitleScale: 1.0, // Başlık boyutunun değişmemesi için
              title: Text(
                'Yeteneklerini Geliştir',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.left,
              ),
              centerTitle: false, // Başlığı sola yaslamak için
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
                    'Önerilen Yetenekler',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
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
                    childCount: skillTitles.length,
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
              _videoAndThumbnailData = FirebaseService.getVideoAndThumbnailURLs(skillTitles);
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

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _navigateToSkillDetail(
          context,
          skillTitles[index],
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
                child: thumbnailUrl.isNotEmpty
                    ? Image.network(
                  thumbnailUrl,
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
                )
                    : Container(
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
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
                      skillTitles[index],
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