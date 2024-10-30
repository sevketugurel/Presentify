import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TimelinePopup extends StatelessWidget {
  final List<MapEntry<String, String>> timestampedSections;

  TimelinePopup({required this.timestampedSections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Zaman Çizelgesi',
          style: GoogleFonts.roboto(
            color: Colors.white, // Başlık metnini beyaz yapma
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.indigo[600],
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
        backgroundColor: Colors.indigo[600], // Buton rengini mor yapma
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Sağ alta konumlandırma
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: timestampedSections.isEmpty
            ? Center(
          child: Text(
            'Zaman çizelgesinde henüz bölüm yok.',
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        )
            : AnimationLimiter(
          child: ListView.builder(
            itemCount: timestampedSections.length,
            itemBuilder: (context, index) {
              final section = timestampedSections[index];
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
                        elevation: 4,
                        shadowColor: Colors.black26,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo[600],
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            section.key,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo[900],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              section.value,
                              style: GoogleFonts.roboto(
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
              );
            },
          ),
        ),
      ),
    );
  }
}
