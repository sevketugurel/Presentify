import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'improve_skills_screen.dart';
import 'profile_screen.dart';
import 'past_analyses_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const Color _amberColor = Color(0xFFD4A017); // Sıcak amber tonu

  static List<Widget> _screens = <Widget>[
    const HomeScreen(),
    ImproveSkillsScreen(),
    PastAnalysesScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Öğren sekmesi seçili olduğunda amber rengi, diğer durumlarda mavi renk kullan
    final bool isLearnTabSelected = _selectedIndex == 1;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
        selectedItemColor: isLearnTabSelected ? _amberColor : Colors.white,
        unselectedItemColor: isLearnTabSelected ? Colors.black54 : Colors.white70,
        backgroundColor: isLearnTabSelected ? Colors.white : Colors.blue,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}