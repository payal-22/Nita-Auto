// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart'; // Ensure you're using fl_chart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For parsing dates and times
// import 'chart.dart'; // Your Graph class file

// class TravelGraph extends StatefulWidget {
//   const TravelGraph({super.key});

//   @override
//   State<TravelGraph> createState() => _TravelGraphState();
// }

// class _TravelGraphState extends State<TravelGraph> {
//   List<BarChartGroupData> barChartData = []; // fl_chart uses BarChartGroupData

//   // Generate the bar chart data
//   _generateData(List<Graph> myData) {
//     barChartData = myData.asMap().entries.map((entry) {
//       int index = entry.key;
//       Graph graph = entry.value;

//       return BarChartGroupData(
//         x: index,
//         barRods: [
//           BarChartRodData(
//             toY: graph.people_count.toDouble(), // Y-axis value
//             color: Colors.blueAccent, // Customize color
//             width: 16,
//           ),
//         ],
//       );
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Travel Details'),
//       ),
//       body: _buildBody(context),
//     );
//   }

//   Widget _buildBody(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream:
//           FirebaseFirestore.instance.collection('travel_details').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const LinearProgressIndicator();
//         } else {
//           List<Graph> myData = snapshot.data!.docs
//               .map((documentSnapshot) => Graph.fromMap(
//                   documentSnapshot.data() as Map<String, dynamic>))
//               .toList();

//           // Filter and group data by the current day's hours
//           List<Graph> groupedData = _filterAndGroupDataByHour(myData);
//           return _buildChart(context, groupedData);
//         }
//       },
//     );
//   }

//   Widget _buildChart(BuildContext context, List<Graph> myData) {
//     _generateData(myData); // Generate the data for the chart
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: BarChart(
//         BarChartData(
//           alignment: BarChartAlignment.spaceAround,
//           barGroups: barChartData, // Set the chart data here
//           titlesData: FlTitlesData(
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (double value, TitleMeta meta) {
//                   // Display X-axis labels (hour in "HH:MM" format)
//                   String travelTime = myData[value.toInt()].travel_time;
//                   return Text(travelTime, style: const TextStyle(fontSize: 10));
//                 },
//                 reservedSize: 30, // Reserved space for titles
//                 interval: 1, // 1 hour interval
//               ),
//             ),
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (double value, TitleMeta meta) {
//                   // Display Y-axis labels (people_count)
//                   return Text(value.toInt().toString(),
//                       style: const TextStyle(fontSize: 10));
//                 },
//                 reservedSize: 30,
//                 interval:
//                     1, // Adjust interval to display every label or skip as necessary
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Filter and group data by the current day's hours
//   List<Graph> _filterAndGroupDataByHour(List<Graph> data) {
//     String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     Map<int, int> peoplePerHour = {};

//     for (var record in data) {
//       if (record.travel_date == currentDate) {
//         DateTime travelTime;
//         try {
//           // Trim spaces and parse the 12-hour formatted time (e.g., "3:54 PM")
//           String cleanTravelTime = record.travel_time.trim();
//           travelTime = DateFormat.jm().parse(cleanTravelTime);
//         } catch (e) {
//           print("Error parsing time: $e");
//           continue; // Skip this record if parsing fails
//         }

//         int hour = travelTime.hour;

//         // Group people count by hour
//         if (peoplePerHour.containsKey(hour)) {
//           peoplePerHour[hour] = peoplePerHour[hour]! + record.people_count;
//         } else {
//           peoplePerHour[hour] = record.people_count;
//         }
//       }
//     }

//     List<Graph> groupedData = peoplePerHour.entries.map((entry) {
//       return Graph(entry.value, currentDate, "${entry.key}:00");
//     }).toList();

//     return groupedData;
//   }
// }
