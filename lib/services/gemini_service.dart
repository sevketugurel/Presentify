import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';

class GeminiService {
  final String apiKey;
  late GenerativeModel _model;

  GeminiService(this.apiKey) {
    _initializeModel();
  }

  void _initializeModel() {
    // Set up the Gemini generative model
    _model = GenerativeModel(model: 'gemini-1.5-pro-002', apiKey: apiKey);
  }

  Future<String?> analyzeVideoByUrl(String videoUrl) async {
    try {
      // Define the prompt with detailed instructions for analysis
      final prompt = TextPart("""
        Görev: Lütfen eklenen FireBase URL'deki videoya aşağıdaki kriterlere göre detaylı bir şekilde analiz et ve analizini dakika ve saniye belirterek bölümlere ayır (örn. '2:20 - 2:40'):
        
        Analizinde, konuşmacının konuşma hızına, göz temasına, el ve kol hareketlerine, duruş ve beden pozisyonuna odaklan.
        
        Her bölümde:
        
        - Gözlemlenen güçlü yönleri kısa, net ve anlaşılır bir şekilde vurgula.
        - Geliştirilmesi gereken alanları ve önerileri spesifik olarak belirt.
        - Analizin, sade, anlaşılır, net ve kısa olmasına odaklan.
        - Öneriler sunarken kullanıcıyla sohbet ediyor tarzda bir üslup kullan. Üçüncü şahıs ifadeler kullanma.
        - Öneriler yapmaya başlarken videoyu inceledim, analizler şu şekilde vb. ifadeler kullanma.
        - Saniyeleri alırken önemli gördüğün saniyeler/dakikalar arasını al ve yorumla. Hepsini yorumlama. Ayrıca videonun süresine dikkat et.
        Örnek Analiz Çıktısı:
        
        x:xx - x:xx: Sunum başlangıcında heyecanlı görünüyorsun ve çok hızlı konuşuyorsun. Biraz daha sakin bir başlangıç, dinleyicilerin konuya daha iyi odaklanmasına yardımcı olabilir.
        
        x:xx - x:xx: Slayt görselini gösterirken, vücut duruşuna dikkat etmen gerekiyor. Slaytı kapatmamak için biraz yan tarafta durman daha iyi olabilir.
        
        x:xx - x:xx: "Biodiversity of mammals" gibi karmaşık terimleri açıklarken el hareketlerini daha etkin bir şekilde kullanabilirsin. Bu, soyut kavramları anlaşılmasını kolaylaştırabilir.
        
        Güçlü Yönler:
        - Göz Teması: Dinleyicilerle sürekli ve doğal bir göz teması kuruyorsun, bu da samimiyetini artırıyor.
        - Duruş ve Hareketler: Sahne hakimiyetin iyi; beden dilin ve duruşun, kendine güvenini gösteriyor.
        - Anlatım: Akıcı ve açık bir dille anlatım yapıyorsun; bu, dinleyicilerin dikkatinin dağılmamasını sağlar.
        
        Öneriler:
        - Vurgu ve Duraklamalar: Sunumun belirli noktalarında daha fazla duraklama yapabilirsin, bu önemli bilgilerin dinleyiciler tarafından sindirilmesine yardımcı olur.
        - Slayt Geçişleri: Slayt geçişleri daha akıcı hale getirilebilir. Görsellerin doğal bir akışla ilerlemesini sağlayabilirsin.
        - Genel İzlenim: Sunumun bilgilendirici ve ilgi çekici. Küçük iyileştirmeler ile daha güçlü ve dinleyicileri etkisi altına alan bir sunum haline getirebilirsin.
        """);

      final videoUrlTextPart = TextPart(videoUrl);

      // Make the API call with the video URL and prompt
      final response = await _model.generateContent([
        Content.multi([prompt, videoUrlTextPart])
      ]);

      // Extract and return the text response
      return response.text;
    } catch (e) {
      debugPrint('Error while analyzing video URL: $e');
      return null;
    }
  }
}
