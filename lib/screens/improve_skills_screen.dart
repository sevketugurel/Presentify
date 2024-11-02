import 'package:flutter/material.dart';
import '../widgets/skill_card.dart';
import '../screens/skill_detail_screen.dart';
import '../services/firebase_service.dart';
import '../models/video_content.dart';

class ImproveSkillsScreen extends StatefulWidget {
  @override
  _ImproveSkillsScreenState createState() => _ImproveSkillsScreenState();
}

class _ImproveSkillsScreenState extends State<ImproveSkillsScreen> {
  List<String> skillTitles = [
    'Doğru Beden Dili Kullanımı',
    'Konuşma Heyecanını Aşma',
    'Sesin Doğru Kullanımı',
    'Stresle Başa Çıkma',
    'Sahnedeki Doğru Duruş',
    'Sunum Öncesi Yapılması Gerekenler'
  ];

  List<List<String>> skillVideoURLs = [];

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      // FirebaseService'den her yetenek için video URL'lerini alıyoruz
      final urls = await FirebaseService.getVideoURLs(skillTitles);

      // Beklenen yapı: List<List<String>>
      if (urls.length != skillTitles.length) {
        throw Exception('Video URL sayısı yetenek sayısıyla uyuşmuyor.');
      }

      setState(() {
        skillVideoURLs = urls;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Videolar yüklenirken bir hata oluştu: $e';
        isLoading = false;
      });
    }
  }

  // Videoları VideoContent modeline dönüştüren metot
  List<VideoContent> mapVideosToContent(int skillIndex) {
    if (skillIndex >= skillVideoURLs.length) return [];

    List<VideoContent> videoContents = [];
    for (int i = 0; i < skillVideoURLs[skillIndex].length; i++) {
      String subtitle = "${skillIndex + 1}.${i + 1}";
      String description = getDescription(skillIndex, i);
      videoContents.add(VideoContent(
        videoUrl: skillVideoURLs[skillIndex][i],
        subtitle: subtitle,
        description: description,
      ));
    }
    return videoContents;
  }

  // Açıklamaları döndüren metot
  String getDescription(int skillIndex, int videoIndex) {
    // Açıklamaları ekleyin
    if (skillIndex == 0) {
      if (videoIndex == 0) {
        return "Beden Dilinin İletişimdeki Önemi: Bu video, beden dilinin iletişimdeki önemini gösteriyor. Konuşmacı aynı cümleyi beden dili kullanmadan ve kullanarak anlatıyor. Beden dili olmadan izleyiciyle bağ kurmak zor, mesaj zayıf kalıyor. Beden dili kullanıldığında ise daha samimi ve ikna edici oluyor.";
      } else if (videoIndex == 1) {
        return "Göz Teması ve Beden Dili: İki sunum örneğiyle göz teması ve beden dilinin önemini anlatıyor. İlk sunumda konuşmacı not okuyarak, monoton ve hareketsiz. Dinleyiciler sıkılıyor. İkinci sunumda göz teması kuruyor, doğal hareket ediyor ve enerjik. Dinleyiciler daha ilgili oluyor.";
      } else if (videoIndex == 2) {
        return "Göz Temasıyla Dinleyici Bağı: Bu TEDx konuşmacısı, sürekli göz teması kurarak dinleyicilerle bağ kuruyor.";
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Yeteneklerini Geliştir',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.red, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: skillTitles.length,
          itemBuilder: (context, index) {
            return SkillCard(
              title: skillTitles[index],
              onTap: () {
                List<VideoContent> videoContents = mapVideosToContent(index);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SkillDetailScreen(
                      title: skillTitles[index],
                      videoContents: videoContents,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}