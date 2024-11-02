// lib/screens/personalized_charts_page.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/charts/voice_tone_chart.dart';
import '../widgets/charts/speech_speed_chart.dart';
import '../widgets/charts/body_language_chart.dart';
import '../widgets/charts/eye_contact_chart.dart';

class PersonalizedChartsPage extends StatelessWidget {
  const PersonalizedChartsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ses tonu verileri - artık direkt double listesi olarak
    final List<double> voiceToneData = [7.0, 6.0, 7.5, 7.0, 6.5];

    // Konuşma hızı verileri
    final List<ScatterSpot> speechSpeedData = [
      ScatterSpot(1, 110),
      ScatterSpot(2, 115),
      ScatterSpot(3, 120),
      ScatterSpot(4, 118),
      ScatterSpot(5, 122),
      ScatterSpot(6, 125),
      ScatterSpot(7, 130),
      ScatterSpot(8, 128),
      ScatterSpot(9, 126),
      ScatterSpot(10, 124),
    ];

    // Beden dili verileri
    final List<BarChartGroupData> bodyLanguageData = List.generate(
      10,
          (index) => BarChartGroupData(
        x: index + 1,
        barRods: [
          BarChartRodData(
            toY: (index % 3 + 1) * 15.0 + 40.0,
            color: Colors.purpleAccent,
            width: 15,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          ),
        ],
      ),
    );

    // Göz teması verileri
    final List<FlSpot> eyeContactData = [
      FlSpot(1, 60),
      FlSpot(2, 65),
      FlSpot(3, 55),
      FlSpot(4, 70),
      FlSpot(5, 75),
      FlSpot(6, 80),
      FlSpot(7, 85),
      FlSpot(8, 80),
      FlSpot(9, 75),
      FlSpot(10, 70),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kişiselleştirilmiş Grafikler',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            VoiceToneChart(dataPoints: voiceToneData),
            const SizedBox(height: 20),
            SpeechSpeedChart(dataPoints: speechSpeedData),
            const SizedBox(height: 20),
            BodyLanguageChart(dataGroups: bodyLanguageData),
            const SizedBox(height: 20),
            EyeContactChart(dataPoints: eyeContactData),
          ],
        ),
      ),
    );
  }
}