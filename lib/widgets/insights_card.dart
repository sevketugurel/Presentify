// lib/widgets/key_insight_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myapp/widgets/timeline_popup.dart';
import 'other_insights_popup.dart';

class InsightCard extends StatelessWidget {
  final String text;

  InsightCard({required this.text});

  /// Feedback metnini zaman damgalı ve diğer bölümlere ayırır.
  Map<String, List<MapEntry<String, String>>> parseFeedback(String text) {
    final Map<String, List<MapEntry<String, String>>> sections = {
      "timestamped": [],
      "other": [],
    };

    // Markdown formatlı başlıkları yakalamak için güncellenmiş regex deseni
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

      // Bölümün zaman damgalı mı yoksa diğer mi olduğunu belirleme
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
      elevation: 8,
      shadowColor: Colors.black26,
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
            _buildSection(
              context: context,
              title: "Zaman Çizelgesini Görüntüle",
              buttonColor: Colors.indigo[600],
              icon: Icons.timeline,
              onPressed: () {
                if (sections["timestamped"]!.isNotEmpty) {
                  showBarModalBottomSheet(
                    context: context,
                    expand: true,
                    builder: (context) => TimelinePopup(
                      timestampedSections: sections["timestamped"]!,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Zaman çizelgesinde henüz bölüm yok.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 15),

            // Diğer Insights Bölümü
            _buildSection(
              context: context,
              title: "Diğer Insights'ları Görüntüle",
              buttonColor: Colors.teal[600],
              icon: Icons.insights,
              onPressed: () {
                if (sections["other"]!.isNotEmpty) {
                  showBarModalBottomSheet(
                    context: context,
                    expand: true,
                    builder: (context) => OtherInsightsPopup(
                      otherSections: sections["other"]!,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Diğer insights bulunmamaktadır.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Bölüm yapısını oluşturmak için yardımcı metod
  Widget _buildSection({
    required BuildContext context,
    required String title,
    required Color? buttonColor,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 15,
              color: Colors.indigo[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
          ),
          icon: Icon(icon, color: Colors.white, size: 20),
          label: Text(
            "Detaylara Git",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
