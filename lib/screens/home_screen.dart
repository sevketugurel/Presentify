// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/widgets/detailed_results_card.dart';
import 'package:myapp/widgets/insights_card.dart';
import 'package:myapp/widgets/video_analysis_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _analysisText;
  bool _isLoading = false;
  String? _error;

  // Analiz tamamlandığında çağrılan callback
  void _onAnalysisComplete(String analysisResult) {
    setState(() {
      _isLoading = false;
      _analysisText = analysisResult;
      _error = null;
    });
  }

  // Analiz sırasında hata oluştuğunda çağrılan callback
  void _onAnalysisError(String errorMessage) {
    setState(() {
      _isLoading = false;
      _error = errorMessage;
    });
  }

  // Analizi başlatmak için çağrılan metod
  void _startAnalysis() {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    // Analiz servisini burada başlatın
    // Örneğin: VideoAnalysisService.startAnalysis(onComplete: _onAnalysisComplete, onError: _onAnalysisError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildVideoAnalysisCard(),
              const SizedBox(height: 16),
              _buildInsightsSection(),
              const SizedBox(height: 16),
              _buildDetailedResultsSection(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Body Language Analyzer'),
      centerTitle: true,
      // AppBar still uses the theme's styling
    );
  }

  Widget _buildVideoAnalysisCard() {
    return VideoAnalysisCard(
      onAnalysisComplete: _onAnalysisComplete,
    );
  }

  Widget _buildInsightsSection() {
    if (_isLoading) {
      return InsightCard(
        text: 'Analiz yapılıyor, lütfen bekleyin...',
      );
    } else if (_error != null) {
      return InsightCard(
        text: 'Hata: $_error',
      );
    } else {
      return InsightCard(
        text: _analysisText ?? 'Detayları görmek için lütfen analiz yapın.',
      );
    }
  }

  Widget _buildDetailedResultsSection() {
    if (_analysisText != null && !_isLoading && _error == null) {
      return const DetailedResultsCard();
    } else {
      return const SizedBox.shrink(); // DetailedResultsCard gösterilmez
    }
  }
}
