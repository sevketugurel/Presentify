import 'package:flutter/material.dart';

class DetailedResultsCard extends StatelessWidget {
  const DetailedResultsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: Placeholder(), // Placeholder for the graph
            ),
            SizedBox(height: 8),
            Center(child: Text('Stress Level Over Time')),
          ],
        ),
      ),
    );
  }
}
