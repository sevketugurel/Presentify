// lib/widgets/other_insights_popup.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class OtherInsightsPopup extends StatelessWidget {
  final List<MapEntry<String, String>> otherSections;

  OtherInsightsPopup({required this.otherSections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diğer Insights\'lar',
          style: GoogleFonts.roboto(
            color: Colors.white, // Başlık metnini beyaz yapma
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.teal[700],
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('AI Destekli Kişiselleştirilmiş Eğitim oluşturuldu!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        icon: Icon(Icons.memory, color: Colors.white), // AI ile alakalı ikon
        label: Text(
          'Kişiselleştirilmiş Eğitim Oluştur',
          style: GoogleFonts.roboto(
            color: Colors.white, // Metin rengini beyaz yapma
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.teal[700], // Buton rengini mor yapma
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Sağ alta konumlandırma
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: otherSections.isEmpty
            ? Center(
          child: Text(
            'Diğer insights bulunmamaktadır.',
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        )
            : AnimationLimiter(
          child: ListView.builder(
            itemCount: otherSections.length,
            itemBuilder: (context, index) {
              final section = otherSections[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  curve: Curves.easeOutBack,
                  child: FadeInAnimation(
                    curve: Curves.easeIn,
                    child: ScaleAnimation(
                      scale: 0.85,
                      curve: Curves.easeOut,
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.teal[50],
                        elevation: 4,
                        shadowColor: Colors.black26,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal[700],
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: MarkdownBody(
                            data: section.key,
                            styleSheet: MarkdownStyleSheet(
                              h6: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.teal[900],
                              ),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: MarkdownBody(
                              data: section.value,
                              styleSheet: MarkdownStyleSheet(
                                p: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
