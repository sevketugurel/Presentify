import 'package:flutter/material.dart';
import '../widgets/video_analysis_card.dart'; // Import VideoAnalysisCard widget
import '../widgets/key_insights_card.dart';  // Import KeyInsightsCard widget
import '../widgets/detailed_results_card.dart';  // Import DetailedResultsCard widget
import '../widgets/bottom_nav_bar.dart';  // Import BottomNavBar widget

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Language Analyzer'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              VideoAnalysisCard(),
              SizedBox(height: 16),
              KeyInsightsCard(),
              SizedBox(height: 16),
              DetailedResultsCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
