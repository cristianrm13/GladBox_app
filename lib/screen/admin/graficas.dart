import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportesView extends StatelessWidget {
  const ReportesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Resultados de reportes'),
        actions: const [
          Icon(Icons.add),
          SizedBox(width: 16),
          Icon(Icons.notifications),
          SizedBox(width: 16),
          Icon(Icons.menu),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gráfica de reportes de los ultimos meses',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildBarChart(),
            const SizedBox(height: 16),
            const Text(
              'Gráfica de cuantas personas reportan las mismas categorías',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildLineChart(),
            const SizedBox(height: 16),
            const Text(
              'Gráfica semanal de reportes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildWeeklyBarChart(),
          ],
        ),
      ),
    );
  }

 Widget _buildBarChart() {
  return AspectRatio(
    aspectRatio: 1.5,
    child: BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(fromY: 0, toY: 300, color: Colors.blue),
            BarChartRodData(fromY: 0, toY: 350, color: Colors.green),
          ]),
            // Añade más datos según sea necesario
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(1, 200),
                const FlSpot(2, 400),
                const FlSpot(3, 600),
                const FlSpot(4, 800),
                const FlSpot(5, 600),
                const FlSpot(6, 400),
              ],
              isCurved: true,
              color: Colors.red,
              barWidth: 4,
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyBarChart() {
  return AspectRatio(
    aspectRatio: 1.5,
    child: BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(fromY: 0, toY: 150, color: Colors.blue.shade100)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(fromY: 0, toY: 100, color: Colors.blue.shade100)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(fromY: 0, toY: 120, color: Colors.blue.shade100)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(fromY: 0, toY: 200, color: Colors.blue)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(fromY: 0, toY: 130, color: Colors.blue.shade100)]),
          BarChartGroupData(x: 5, barRods: [BarChartRodData(fromY: 0, toY: 90, color: Colors.blue.shade100)]),
          BarChartGroupData(x: 6, barRods: [BarChartRodData(fromY: 0, toY: 80, color: Colors.blue.shade100)]),
        ],
        ),
      ),
    );
  }
}
