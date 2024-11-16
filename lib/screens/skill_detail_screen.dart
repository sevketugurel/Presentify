import 'package:flutter/material.dart';
import 'video_player_screen.dart';

class SkillDetailScreen extends StatelessWidget {
  final String title;
  final List<Map<String, String>> skillData;

  SkillDetailScreen({required this.title, required this.skillData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: skillData.length,
        itemBuilder: (context, index) {
          final videoUrl = skillData[index]['videoUrl'] ?? '';
          final thumbnailUrl = skillData[index]['thumbnailUrl'] ?? '';

          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: thumbnailUrl.isNotEmpty
                                ? Image.network(
                              thumbnailUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.video_library,
                                    size: 50,
                                    color: Colors.grey[600],
                                  ),
                                );
                              },
                            )
                                : Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.video_library,
                                size: 50,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${Duration(minutes: 5).inMinutes}:00',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Video ${index + 1}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Bu videoda ${title.toLowerCase()} hakkında detaylı bilgiler öğreneceksiniz.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                '5 dakika',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(width: 16),
                              Icon(
                                Icons.visibility,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${(index + 1) * 127} görüntülenme',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
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
    );
  }
}