// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'improve_skills_screen.dart';
import 'profile_screen.dart';
import 'past_analyses_screen.dart'; // Yeni ekranı içe aktarın

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Seçili sekmenin indeksini tutar
  int _selectedIndex = 0;

  // Her bir sekme için gösterilecek ekranların listesi
  static List<Widget> _screens = <Widget>[
    const HomeScreen(),
    ImproveSkillsScreen(),
    PastAnalysesScreen(), // Yeni ekranı listeye ekleyin
    const ProfileScreen(),
  ];

  // Sekmeye tıklandığında çağrılır
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Seçilen sekmeye göre ilgili ekranı gösterir
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Mevcut seçili sekme
        onTap: _onItemTapped, // Sekmeye tıklandığında çağrılır
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Öğren',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Geçmiş',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.blue, // Temaya uygun ana renk
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
