// lib/screens/improve_skills_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/skill_card.dart';
import '../widgets/bottom_nav_bar.dart';

class ImproveSkillsScreen extends StatelessWidget {
  final List<String> skillTitles = [
    'Doğru Beden Dili Kullanımı',
    'Konuşma Heyecanını Aşma',
    'Sesin Doğru Kullanımı',
    'Stresle Başa Çıkma',
    'Sahnedeki Doğru Duruş',
    'Sunum Öncesi Yapılması Gerekenler',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold'un arka plan rengini temaya uygun hale getirin
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1, // Kare şeklinde kartlar
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: skillTitles.length,
          itemBuilder: (context, index) {
            return SkillCard(title: skillTitles[index]);
          },
        ),
      ),
    );
  }
}
