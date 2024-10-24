import 'package:flutter/material.dart';

class KeyInsightsCard extends StatelessWidget {
  const KeyInsightsCard({Key? key}) : super(key: key);

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
              'Key Insights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.psychology_outlined, color: Colors.blue),
              title: Text('Confidence level: High'),
            ),
            ListTile(
              // Changed icon from Icons.stress_management to Icons.self_improvement
              leading: Icon(Icons.self_improvement, color: Colors.blue),
              title: Text('Stress level: Medium'),
            ),
            ListTile(
              leading: Icon(Icons.pan_tool_outlined, color: Colors.blue),
              title: Text('Gestures: Frequent'),
            ),
          ],
        ),
      ),
    );
  }
}
