import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class BodyLanguageChart extends StatelessWidget {
  final List<BarChartGroupData>? dataGroups;

  const BodyLanguageChart({
    Key? key,
    this.dataGroups,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final barData = dataGroups ??
        List.generate(10, (index) => BarChartGroupData(
          x: index + 1,
          barRods: [
            BarChartRodData(
              toY: (index % 3 + 1) * 15.0 + 40.0, // Mock data
              color: Colors.purpleAccent,
            ),
          ],
        ));

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
              'Beden Dili (Dakika Bazlı)',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple[800],
              ),
            ),
            SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1.5,
              child: BarChart(
                BarChartData(
                  maxY: 100,
                  barGroups: barData,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: TextStyle(
                              color: Colors.purple[800],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: TextStyle(
                              color: Colors.purple[800],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true, horizontalInterval: 20),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Beden diliniz genel olarak olumlu.',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.purple[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
