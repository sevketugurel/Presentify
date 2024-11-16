// lib/widgets/skill_card.dart

import 'package:flutter/material.dart';

class SkillCard extends StatelessWidget {
  final String title;
  final String thumbnailUrl;
  final VoidCallback onTap;

  SkillCard({required this.title, required this.thumbnailUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: thumbnailUrl.isNotEmpty
                  ? Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: 50);
                },
              )
                  : Icon(Icons.video_library, size: 50),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
