// lib/widgets/other_insights_popup.dart

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class OtherInsightsPopup extends StatelessWidget {
  final List<MapEntry<String, String>> otherSections;

  OtherInsightsPopup({required this.otherSections});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          Text(
            "Other Insights",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const Divider(thickness: 1, color: Colors.grey),
          const SizedBox(height: 20),
          ...otherSections.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  MarkdownBody(
                    data: entry.value,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                      strong: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
