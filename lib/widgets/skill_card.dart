// lib/widgets/skill_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillCard extends StatelessWidget {
  final String title;

  const SkillCard({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Container yerine Card kullanarak temanın cardTheme'ını kullanın
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 8, // cardTheme'dan miras alabilir
        shadowColor: Theme.of(context).cardTheme.shadowColor,
        color: Theme.of(context).cardColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.indigo[900], // Renkleri temaya uygun olarak ayarlayın
              ),
            ),
          ),
        ),
      ),
    );
  }
}
