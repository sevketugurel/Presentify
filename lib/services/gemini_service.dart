import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';
import 'dart:io';
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

    // Video meta verilerini al
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
      final prompt = TextPart("""
Video Metadata Analizi:
- Video Süresi: ${metadata['duration']}
- Dosya Boyutu: ${(metadata['size'] / 1024 / 1024).toStringAsFixed(2)} MB
- Dosya Adı: ${metadata['fileName']}

Görev: Lütfen eklenen videoya aşağıdaki kriterlere göre detaylı bir şekilde analiz et.  
Analizini video tamamlanıncaya kadar dakika ve saniye belirterek bölümlere ayır.   
Örneğin, eklenen video 10 dakika ise 0:00-0:45, 0:50-1:15, 1:32-1:56, 2:10-2:33,3:01-4:43,4:55-7.50,8:00-8:37, 9:00-10:00 şeklinde videodaki önemli kısımlar için bölümlere ayır ve bu bölümler için yapacağın analizleri yaz.  

Analizinde, konuşmacının konuşma hızına, göz temasına, el ve kol hareketlerine, duruş ve beden pozisyonuna odaklan.  

Her bölümde:  
- Gözlemlenen güçlü yönleri kısa, net ve anlaşılır bir şekilde vurgula.  
- Geliştirilmesi gereken alanları ve önerileri spesifik olarak belirt.  
- Analizin, sade, anlaşılır, net ve kısa olmasına odaklan.  
- Öneriler sunarken kullanıcıyla sohbet ediyor tarzda bir üslup kullan. Üçüncü şahıs ifadeler kullanma.  
- Öneriler yapmaya başlarken videoyu inceledim, analizler şu şekilde vb. ifadeler kullanma.  
- Saniyeleri alırken önemli gördüğün saniyeler/dakikalar arasını al ve yorumla. Hepsini yorumlama. Ayrıca videonun süresine dikkat.  

Örnek Analiz Çıktısı:  
x:xx - x:xx: Sunum başlangıcında ....... görünüyorsun ve ...... konuşuyorsun.  

x:xx - x:xx: Vücut duruşun .......   

x:xx - x:xx: El hareketlerini ........ şekilde kullanıyorsun.  

x:xx - x:xx: Göz temasını ........ şekilde kuruyorsun.  

x:xx - x:xx: Sunumunun ..... kısmında ........ konuya daha fazla vurgu yapabilirsin.  

x:xx - x:xx: Sunumunun ..... kısmında daha fazla duraklama yapabilirsin.  

Bu analizleri eklenen videonun sonuna gelinceye kadar devam ettir. Video süresinden daha kısa analiz yapma.  

Güçlü Yönler:  
- Göz Teması: Dinleyicilerle .......... bir göz teması kuruyorsun, bu da ....... hissettiriyor.  
- Duruş ve Hareketler: Sahne hakimiyetin ....... ; beden dilin ve duruşun, .......  gösteriyor.  
- Anlatım: ......... bir dille anlatım yapıyorsun; bu, dinleyicilerin ..........   
- Vurgular: Sunumunun belirli noktalarında yaptığın vurgular, dinleyicilerin .........  

Öneriler:  
- Vurgu ve Duraklamalar: Sunumun ....... noktalarında daha fazla ........ yapabilirsin, bu önemli bilgilerin dinleyiciler tarafından ........ yardımcı olur.  
- Beden Dili: Sunumun sırasında daha fazla ........ kullanabilirsin, bu, dinleyicilerin ......... olmasını sağlar.  
- Genel İzlenim: Sunumun ........ ve ...... . Daha fazla ........ yaparak, dinleyicilerin ............  
- Sunum Sonu: Sunumunun sonunda ............ yaparak, dinleyicilerin .............  
""");


      final response = await _model.generateContent([Content.text(prompt.text)]);
      return response.text;
    } catch (e) {
      debugPrint('Video analiz edilirken hata oluştu: $e');
      return null;
    }
  }
}
