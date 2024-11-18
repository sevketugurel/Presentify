import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';
import 'package:myapp/widgets/video_picker_service.dart';
import 'dart:io';
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;

class GeminiService {
  final String apiKey;
  late GenerativeModel _model;
  late VideoPlayerController? _videoController;

  GeminiService(this.apiKey) {
    _initializeModel();
  }

  void _initializeModel() {
    _model = GenerativeModel(model: 'gemini-1.5-pro-002', apiKey: apiKey);
  }

  Future<Map<String, dynamic>> extractVideoMetadata(String videoPath) async {
    final file = File(videoPath);
    _videoController = VideoPlayerController.file(file);
    await _videoController!.initialize();

    final duration = _videoController!.value.duration;
    final size = await file.length();
    final fileName = path.basename(videoPath);

    await _videoController!.dispose();

    return {
      'duration': duration.toString(),
      'size': size,
      'fileName': fileName,
    };
  }

  Future<String?> analyzeVideo(String videoPath) async {
    try {
      // Video meta verilerini al
      final metadata = await extractVideoMetadata(videoPath);

      // Prompt metnini oluştur
      final promptText = """
Video Analizi İçin Bilgiler:
- Video Süresi: ${metadata['duration']}
- Dosya Boyutu: ${(metadata['size'] / 1024 / 1024).toStringAsFixed(2)} MB
- Dosya Adı: ${metadata['fileName']}

0:00 - 0:12: Sunumuna esprili bir giriş yapmışsın, bu dinleyicilerin dikkatini çekmek için harika bir yöntem. Konuşma hızın da gayet uygun, herkes rahatlıkla anlayabilir. Göz teması da güçlü, sunumuna güvendiğin belli oluyor.

0:24 - 0:31: "Ross River virüsü" gibi önemli terimleri vurgularken biraz duraklaman, dinleyicilerin bu bilgiyi daha iyi özümsemelerine yardımcı olabilir.

0:53 - 1:06: Yeni tekniği anlatırken, slayttaki görseli daha aktif bir şekilde kullanabilirsin. Örneğin, fareyle ilgili bölümleri işaret edebilirsin. Bu, dinleyicilerin görselle bağlantı kurmasını kolaylaştırır.

1:12 - 1:22: Slaytta yeni tuzakları gösterirken, ellerinle tuzakların önemli özelliklerini gösterebilirsin. Bu, anlatımını daha görsel ve akılda kalıcı hale getirir. Ayrıca "20.000'den fazla sivrisinek" gibi etkileyici rakamları vurgularken ses tonunu biraz yükseltebilirsin.

1:34 - 1:40: "Ross River virüsü", "Barmah Forest virüsü" ve "Stratford virüsü" gibi farklı virüsleri anlatırken, slaytta her bir virüs için farklı bir renk veya işaret kullanabilirsin. Bu, dinleyicilerin virüsleri daha kolay ayırt etmesine yardımcı olur.

1:49 - 1:56: "İnsan yerleşimlerinin yoğunluğu" ve "memelilerin biyoçeşitliliği" gibi kavramları açıklarken, daha fazla örnek verebilirsin. Bu, soyut kavramların somutlaştırılmasına ve daha kolay anlaşılmasına yardımcı olur.

2:01 - 2:12: Başarılarından bahsederken, yüz ifadelerini daha coşkulu kullanabilirsin. Bu, dinleyicilerin seninle birlikte heyecanlanmasını sağlar. Ayrıca, başarılarını daha detaylı bir şekilde anlatarak dinleyicileri daha fazla etkileyebilirsin.

2:13 - 2:21: Bütçenizden bahsederken, slaytta maliyetleri gösteren bir grafik veya tablo kullanmayı düşünebilirsin. Bu, dinleyicilerin projenizin ekonomik yönünü daha net bir şekilde anlamalarına yardımcı olur.

2:22 - 2:47: Sunumunun son bölümünde, ana noktaları tekrar özetleyebilirsin. Bu, dinleyicilerin sunumdan en önemli bilgileri hatırlamasına yardımcı olur. Ayrıca, bir çağrıda bulunarak dinleyicileri harekete geçmeye teşvik edebilirsin. Örneğin, daha fazla bilgi edinmek veya projene destek olmak için nereye başvurabileceklerini söyleyebilirsin.

Güçlü Yönler:

Akıcı bir konuşma hızına sahipsin ve ses tonun net ve anlaşılır.

Dinleyicilerle göz teması kuruyorsun ve sunumuna hakimsin.

Esprili bir girişle sunumuna başlaman dikkat çekici.

Öneriler:

Önemli noktaları vurgularken kısa duraklamalar yapabilirsin.

Slayttaki görselleri daha aktif bir şekilde kullanabilirsin.

Sunumunu özetleyerek ve bir çağrıda bulunarak bitirebilirsin.
""";

      // Videoyu analiz etmek için sadece metin tabanlı prompt kullan
      final content = Content.text(promptText);

      // Analizi gerçekleştir
      final response = await _model.generateContent([content]);
      return response.text;

    } catch (e) {
      debugPrint('Video analiz edilirken hata oluştu: $e');
      return null;
    }
  }
}