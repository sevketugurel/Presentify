// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Eğer AppBar kullanıyorsanız, buraya ekleyebilirsiniz.
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text(
          'Profile Ekranı',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
