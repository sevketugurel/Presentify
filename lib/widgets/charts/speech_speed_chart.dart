import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class SpeechSpeedChart extends StatelessWidget {
  final List<ScatterSpot>? dataPoints;

  const SpeechSpeedChart({
    Key? key,
    this.dataPoints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scatterData = dataPoints ?? [
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

    return Card(
      color: Colors.white, // Daha iyi kontrast için
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Konuşma Hızı (Dakika Bazlı)',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1.5,
              child: ScatterChart(
                ScatterChartData(
                  minX: 0,
                  maxX: 11,
                  minY: 100,
                  maxY: 140,
                  scatterSpots: scatterData,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: TextStyle(
                              color: Colors.green[800],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 10,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()} wpm',
                            style: TextStyle(
                              color: Colors.green[800],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    horizontalInterval: 10,
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Konuşma hızınız tutarlı ve normal seviyede.',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.green[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
