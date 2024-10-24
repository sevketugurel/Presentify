import 'package:flutter/material.dart';
import '../widgets/video_analysis_card.dart';
import '../widgets/key_insights_card.dart';
import '../widgets/detailed_results_card.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Language Analyzer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: const [
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
