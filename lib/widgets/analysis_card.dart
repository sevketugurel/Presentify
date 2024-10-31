// lib/widgets/analysis_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalysisCard extends StatelessWidget {
  final String title;
  final String date;

  const AnalysisCard({Key? key, required this.title, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // Temanın cardTheme'ını kullanın
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: Theme.of(context).cardTheme.elevation,
      shadowColor: Theme.of(context).cardTheme.shadowColor,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo[900],
                )),
            const SizedBox(height: 8),
            Text('Tarih: $date',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                )),
          ],
        ),
      ),
    );
  }
}
