/* import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportesView extends StatefulWidget {
  const ReportesView({super.key});

  @override
  _ReportesViewState createState() => _ReportesViewState();
}

class _ReportesViewState extends State<ReportesView> {
  List<BarChartGroupData> complaintsByStatusData = [];
  Map<String, int> statusCounts = {};

  List<BarChartGroupData> complaintsByCategoryData = [];
  Map<String, int> categoryCounts = {};

  @override
  void initState() {
    super.initState();
    fetchComplaintsByStatusData();
    fetchComplaintsByCategoryData();
  }

  Future<void> fetchComplaintsByStatusData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://gladboxapi.integrador.xyz:3000/api/v1/quejas/estadisticas/estados'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;

        final Map<String, int> counts = {};
        for (var item in data) {
          final status = item['_id'] ?? 'Sin estado';
          counts[status] = item['count'] ?? 0;
        }

        setState(() {
          statusCounts = counts;
          complaintsByStatusData = statusCounts.entries.map((entry) {
            final index = statusCounts.keys.toList().indexOf(entry.key);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: entry.value.toDouble(),
                  width: 15,
                  color: Colors.blueAccent,
                  borderSide: const BorderSide(color: Colors.lightBlue, width: 1),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: entry.value.toDouble(),
                    color: Colors.blue.withOpacity(0.3),
                  ),
                ),
              ],
            );
          }).toList();
        });
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching complaints by status data: $e');
    }
  }

  Future<void> fetchComplaintsByCategoryData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://gladboxapi.integrador.xyz:3000/api/v1/quejas/estadisticas/categorias'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;

        final Map<String, int> counts = {};
        for (var item in data) {
          final category = item['_id'] ?? 'Sin categoría';
          counts[category] = item['count'] ?? 0;
        }

        setState(() {
          categoryCounts = counts;
          complaintsByCategoryData = categoryCounts.entries.map((entry) {
            final index = categoryCounts.keys.toList().indexOf(entry.key);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: entry.value.toDouble(),
                  width: 15,
                  color: Colors.orangeAccent,
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 255, 195, 177), width: 1),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: entry.value.toDouble(),
                    color: Colors.orange.withOpacity(0.3),
                  ),
                ),
              ],
            );
          }).toList();
        });
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching complaints by category data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Reportes de Quejas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gráfica de quejas por estado',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildBarChart(complaintsByStatusData, statusCounts.keys.toList(),
                  Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'Gráfica de quejas por categoría',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildBarChart(complaintsByCategoryData,
                  categoryCounts.keys.toList(), Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(List<BarChartGroupData> data, List<String> labels,
      Color barColor) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < labels.length) {
                    return Transform.rotate(
                      angle: -0.5,
                      child: Text(
                        labels[value.toInt()],
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          barGroups: data,
          gridData: FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipPadding: const EdgeInsets.all(8),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${labels[group.x.toInt()]}\n${rod.toY.toInt()} quejas',
                  TextStyle(
                    color: Colors.white,
                    backgroundColor: Colors.grey.withOpacity(0.8), // Tooltip background color
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
 */


import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportesView extends StatefulWidget {
  const ReportesView({super.key});

  @override
  _ReportesViewState createState() => _ReportesViewState();
}

class _ReportesViewState extends State<ReportesView> {
  List<BarChartGroupData> complaintsByStatusData = [];
  Map<String, int> statusCounts = {};

  List<BarChartGroupData> complaintsByCategoryData = [];
  Map<String, int> categoryCounts = {};

  @override
  void initState() {
    super.initState();
    fetchComplaintsByStatusData();
    fetchComplaintsByCategoryData();
  }

  Future<void> fetchComplaintsByStatusData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://gladboxapi.integrador.xyz:3000/api/v1/quejas/estadisticas/estados'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;

        final Map<String, int> counts = {};
        for (var item in data) {
          final status = item['_id'] ?? 'Sin estado';
          counts[status] = item['count'] ?? 0;
        }

        setState(() {
          statusCounts = counts;
          complaintsByStatusData = statusCounts.entries.map((entry) {
            final index = statusCounts.keys.toList().indexOf(entry.key);
            Color barColor = _getColorForIndex(index);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: entry.value.toDouble(),
                  width: 30,
                  color: barColor,
                  borderSide: BorderSide(
                      color: barColor.withOpacity(0.5), width: 1),
                  borderRadius: BorderRadius.zero, 
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: entry.value.toDouble(),
                    color: barColor.withOpacity(0.3),
                  ),
                ),
              ],
            );
          }).toList();
        });
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching complaints by status data: $e');
    }
  }

  Future<void> fetchComplaintsByCategoryData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://gladboxapi.integrador.xyz:3000/api/v1/quejas/estadisticas/categorias'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;

        final Map<String, int> counts = {};
        for (var item in data) {
          final category = item['_id'] ?? 'Sin categoría';
          counts[category] = item['count'] ?? 0;
        }

        setState(() {
          categoryCounts = counts;
          complaintsByCategoryData = categoryCounts.entries.map((entry) {
            final index = categoryCounts.keys.toList().indexOf(entry.key);
            Color barColor = _getColorForIndex(index);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: entry.value.toDouble(),
                  width: 30, 
                  color: barColor,
                  borderSide: BorderSide(
                      color: barColor.withOpacity(0.5), width: 1),
                  borderRadius: BorderRadius.zero, 
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: entry.value.toDouble(),
                    color: barColor.withOpacity(0.3),
                  ),
                ),
              ],
            );
          }).toList();
        });
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching complaints by category data: $e');
    }
  }

  Color _getColorForIndex(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.yellow,
      Colors.cyan,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Reportes de Quejas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gráfica de quejas por estado',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildBarChart(complaintsByStatusData, statusCounts.keys.toList()),
              const SizedBox(height: 24),
              const Text(
                'Gráfica de quejas por categoría',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildBarChart(complaintsByCategoryData, categoryCounts.keys.toList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(List<BarChartGroupData> data, List<String> labels) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < labels.length) {
                    final barColor = _getColorForIndex(value.toInt());
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        labels[value.toInt()],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: barColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          barGroups: data,
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipPadding: const EdgeInsets.all(8),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${labels[group.x.toInt()]}\n${rod.toY.toInt()} quejas',
                  TextStyle(
                    color: Colors.white,
                    backgroundColor: Colors.black.withOpacity(0.7),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

