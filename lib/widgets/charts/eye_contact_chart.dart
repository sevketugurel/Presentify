import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class EyeContactChart extends StatelessWidget {
  final List<FlSpot>? dataPoints;

  const EyeContactChart({
    Key? key,
    this.dataPoints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chartData = dataPoints ?? [
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
              'Göz Teması (Dakika Bazlı)',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
            SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 100,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 20,
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData,
                      isCurved: true,
                      color: Colors.orangeAccent,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.orangeAccent.withOpacity(0.3),
                      ),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Göz temasınız genel olarak iyi seviyede.',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.orange[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
