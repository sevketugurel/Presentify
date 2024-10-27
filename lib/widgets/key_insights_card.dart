import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class KeyInsightCard extends StatelessWidget {
  final String text;

  KeyInsightCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Key Insight",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 10),
            MarkdownBody(
              data: text,
              styleSheet: MarkdownStyleSheet(
                h2: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
                p: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                strong: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
