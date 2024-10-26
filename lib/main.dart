import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: Colors.blueAccent, // Buton üzerindeki yazının rengi.
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, // Daha belirgin buton yazı tipi.
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Butonun kenarlarını daha yuvarlak yap.
            ),
          ),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.copyWith(
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
      home: const HomeScreen(),
    );
  }
}
