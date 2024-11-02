// lib/main.dart

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart'; // VisibilityDetector importu
import 'screens/main_screen.dart'; // MainScreen'i import edin

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Activate Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
    // Uncomment below if developing for web
    // webProvider: WebProvider.reCaptchaV3,
  );

  // İsteğe bağlı olarak, VisibilityDetectorController'ın updateInterval değerini ayarlayabilirsiniz
  VisibilityDetectorController.instance.updateInterval = Duration(milliseconds: 500);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // GoogleFonts ile oluşturulan temel TextTheme
    final TextTheme baseTextTheme = GoogleFonts.poppinsTextTheme();

    return MaterialApp(
      title: 'Body Language Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Buton gibi öğelerde öne çıkacak ana renk.
        hintColor: Colors.purple, // Vurgu rengi olarak menü ve simgelerde kullanılabilir.
        scaffoldBackgroundColor: Colors.grey[200], // Arka plan rengi için daha açık gri ton.
        cardColor: Colors.white, // Kartların (card) arka plan rengi olarak beyaz.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent, // Butonun arka plan rengi.
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, // Daha belirgin buton yazı tipi.
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Butonun kenarlarını daha yuvarlak yap.
            ),
          ),
        ),
        textTheme: baseTextTheme.copyWith(
          titleLarge: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // Başlık yazı tipi rengi.
          ),
          bodyMedium: const TextStyle(
            fontSize: 16,
            color: Colors.black54, // Gövde metinleri için daha yumuşak siyah ton.
          ),
          bodySmall: const TextStyle(
            fontSize: 14,
            color: Colors.blueGrey, // Daha küçük açıklamalar için gri ton.
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // AppBar arka plan rengi.
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(
            color: Colors.black87, // AppBar'daki ikonların rengi.
          ),
          elevation: 0, // AppBar'ı sade tutmak için gölgeyi kaldır.
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blueAccent, // Seçili öğe rengi.
          unselectedItemColor: Colors.grey, // Seçili olmayan öğe rengi.
          showUnselectedLabels: true, // Seçili olmayan öğelerin etiketlerini göster.
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: const MainScreen(), // Ana ekran olarak MainScreen'i ayarlayın
      debugShowCheckedModeBanner: false, // Debug banner'ı kaldırın
    );
  }
}
