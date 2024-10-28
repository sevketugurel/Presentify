// lib/widgets/key_insight_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'timeline_popup.dart'; // Newly created
import 'other_insights_popup.dart'; // Newly created

class InsightCard extends StatelessWidget {
  final String text;

  InsightCard({required this.text});

  /// Parses the feedback text into timestamped and other sections.
  /// It accurately captures sections formatted with markdown headers.
  Map<String, List<MapEntry<String, String>>> parseFeedback(String text) {
    final Map<String, List<MapEntry<String, String>>> sections = {
      "timestamped": [],
      "other": [],
    };

    // Updated regex pattern to handle markdown-formatted headers
    final RegExp regExp = RegExp(
      r'(?:^|\n)\*{0,2}(Güçlü Yönler|Öneriler|\d+:\d+ - \d+:\d+):\*{0,2}\s*(.*?)(?=(?:\n\*{0,2}(Güçlü Yönler|Öneriler|\d+:\d+ - \d+:\d+):)|$)',
      dotAll: true,
      multiLine: true,
    );

    final matches = regExp.allMatches(text);

    for (var match in matches) {
      String title = match.group(1)?.trim() ?? "";
      String content = match.group(2)?.trim() ?? "";
      final entry = MapEntry(title, content);

      // Determine if the section is timestamped or other
      if (RegExp(r'^\d+:\d+ - \d+:\d+$').hasMatch(title)) {
        sections["timestamped"]!.add(entry);
      } else {
        sections["other"]!.add(entry);
      }
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final sections = parseFeedback(text);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 12, // Daha belirgin gölge
      shadowColor: Colors.black38,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Başlık
            Text(
              'Insights',
              style: GoogleFonts.roboto(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Timeline Bölümü
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Metin Bölümü
                Expanded(
                  child: Text(
                    "Zaman Çizelgesini Görüntüle",
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      color: Colors.indigo[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Buton Bölümü
                ElevatedButton.icon(
                  onPressed: () {
                    showBarModalBottomSheet(
                      context: context,
                      expand: true,
                      builder: (context) => TimelinePopup(
                        timestampedSections: sections["timestamped"]!,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 11.0,
                      horizontal: 22.0,
                    ),
                  ),
                  icon: const Icon(Icons.timeline, color: Colors.white, size: 20),
                  label: Text(
                    "Detaylara Git",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Diğer Insights Bölümü
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Metin Bölümü
                Expanded(
                  child: Text(
                    "Diğer Insights'ları Görüntüle",
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      color: Colors.indigo[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Buton Bölümü
                ElevatedButton.icon(
                  onPressed: () {
                    showBarModalBottomSheet(
                      context: context,
                      expand: true,
                      builder: (context) => OtherInsightsPopup(
                        otherSections: sections["other"]!,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 11.0,
                      horizontal: 22.0,
                    ),
                  ),
                  icon: const Icon(Icons.insights, color: Colors.white, size: 20),
                  label: Text(
                    "Detaylara Git",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
