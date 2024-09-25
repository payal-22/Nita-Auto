import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nita_auto/services/firestore_service.dart';
import '../services/firestore_service.dart';

class BarGraphScreen extends StatefulWidget {
  @override
  _BarGraphScreenState createState() => _BarGraphScreenState();
}

class _BarGraphScreenState extends State<BarGraphScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  List<BarChartGroupData> barChartData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel Time vs People')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getTravelDetailsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Process data into bar chart format
          Map<int, int> travelTimeData = {};
          for (var doc in snapshot.data!.docs) {
            int travelTime =
                int.tryParse(doc['travel_time']) ?? 0; // Add null check
            int peopleCount = doc['people_count'] ?? 0; // Add null check

            travelTimeData[travelTime] =
                (travelTimeData[travelTime] ?? 0) + peopleCount;
          }

          // Convert processed data into bar chart groups
          barChartData = travelTimeData.entries
              .map((e) => BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.toDouble(),
                        color: Colors.blue, // Bar color
                        width: 20, // Adjusted bar width for better spacing
                        borderRadius:
                            BorderRadius.circular(4), // Rounded edges for bars
                      ),
                    ],
                  ))
              .toList();

          return BarChart(
            BarChartData(
              maxY: 200, // Set a maximum value for Y-axis for better visibility
              barGroups: barChartData,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1, // Show titles for each bar on X-axis
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()} min',
                          style: const TextStyle(fontSize: 12));
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 50, // Y-axis labels at 50 people intervals
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()}',
                          style: const TextStyle(fontSize: 12));
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                horizontalInterval: 50, // Gridline interval for Y-axis
                drawVerticalLine:
                    false, // Only horizontal gridlines for clarity
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipPadding:
                      const EdgeInsets.all(8), // Padding inside tooltip
                  tooltipMargin: 5, // Space between the tooltip and the chart
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${group.x.toInt()} min\n${rod.toY.toInt()} people',
                      const TextStyle(
                        color: Colors.white, // Text color for the tooltip
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      children: [],
                      // Removed backgroundColor here
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
