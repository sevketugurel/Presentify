import 'package:flutter/material.dart';
import 'package:myapp/widgets/detailed_results_card.dart';
import '../widgets/key_insights_card.dart';
import '../widgets/video_analysis_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _analysisText;

  // Callback function to set the analysis result
  void _onAnalysisComplete(String analysisResult) {
    setState(() {
      _analysisText = analysisResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Language Analyzer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              VideoAnalysisCard(onAnalysisComplete: _onAnalysisComplete),
              const SizedBox(height: 16),
              if (_analysisText != null)
                KeyInsightCard(text: _analysisText!), // Conditionally display KeyInsightCard
              const SizedBox(height: 16),
              DetailedResultsCard(),
            ],
          ),
        ),
      ),
    );
  }
}
