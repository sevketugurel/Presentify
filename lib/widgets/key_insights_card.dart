import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KeyInsightsCard extends StatelessWidget {
  const KeyInsightsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Insights',
          style: GoogleFonts.roboto(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            const ListTile(
              leading: Icon(Icons.psychology_outlined, color: Colors.blue),
              title: Text('Confidence level: High'),
            ),
            const ListTile(
              leading: Icon(Icons.accessibility_new, color: Colors.blue),
              title: Text('Stress level: Medium'),
            ),
            const ListTile(
              leading: Icon(Icons.pan_tool_outlined, color: Colors.blue),
              title: Text('Gestures: Frequent'),
            ),
          ],
        ),
      ),
    );
  }
}
