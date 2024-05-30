import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:h2overview/features/analytics/analytics_test_screen.dart';
import 'package:h2overview/features/analytics/widgets/generalize_line_graph.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final db = FirebaseFirestore.instance;
  Calendar waterFlowCalendarView = Calendar.day;
  Calendar waterPressureCalendarView = Calendar.day;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Analytics'),
      // ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              // Test
              // StreamBuilder(
              //   stream: db
              //       .collection('devices')
              //       .doc('H2O-12345')
              //       .collection('waterflow')
              //       .snapshots(),
              //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //     if (snapshot.hasData) {
              //       return Column(
              //         children: snapshot.data!.docs.map((doc) {
              //           return ListTile(
              //             title: Text(doc['name']),
              //             subtitle: Text(doc['age'].toString()),
              //           );
              //         }).toList(),
              //       );
              //     } else {
              //       return const SizedBox();
              //     }
              //   },
              // ),

              const SizedBox(height: 8.0),

              // Calendar view segmented button (Water Flow).
              SegmentedButton<Calendar>(
                segments: const <ButtonSegment<Calendar>>[
                  ButtonSegment<Calendar>(
                    value: Calendar.day,
                    label: Text('Day'),
                    icon: Icon(Icons.calendar_view_day),
                  ),
                  ButtonSegment<Calendar>(
                    value: Calendar.week,
                    label: Text('Week'),
                    icon: Icon(Icons.calendar_view_week),
                  ),
                  ButtonSegment<Calendar>(
                    value: Calendar.month,
                    label: Text('Month'),
                    icon: Icon(Icons.calendar_view_month),
                  ),
                  ButtonSegment<Calendar>(
                    value: Calendar.year,
                    label: Text('Year'),
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
                selected: <Calendar>{waterFlowCalendarView},
                onSelectionChanged: (Set<Calendar> newSelection) {
                  setState(() {
                    // By default there is only a single segment that can be
                    // selected at one time, so its value is always the first
                    // item in the selected set.
                    waterFlowCalendarView = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 8.0),

              // Water flow line chart.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card.outlined(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8.0, 16.0, 4.0, 8.0),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        // Chart title
                        Text('Water Flow (mL)',
                            style: Theme.of(context).textTheme.headlineSmall),
                        const GeneralizeLineGraph(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Divider(),
              ),
              const SizedBox(height: 24.0),

              // Calendar view segmented button (Water Pressure).
              SegmentedButton<Calendar>(
                segments: const <ButtonSegment<Calendar>>[
                  ButtonSegment<Calendar>(
                    value: Calendar.day,
                    label: Text('Day'),
                    icon: Icon(Icons.calendar_view_day),
                  ),
                  ButtonSegment<Calendar>(
                    value: Calendar.week,
                    label: Text('Week'),
                    icon: Icon(Icons.calendar_view_week),
                  ),
                  ButtonSegment<Calendar>(
                    value: Calendar.month,
                    label: Text('Month'),
                    icon: Icon(Icons.calendar_view_month),
                  ),
                  ButtonSegment<Calendar>(
                    value: Calendar.year,
                    label: Text('Year'),
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
                selected: <Calendar>{waterPressureCalendarView},
                onSelectionChanged: (Set<Calendar> newSelection) {
                  setState(() {
                    // By default there is only a single segment that can be
                    // selected at one time, so its value is always the first
                    // item in the selected set.
                    waterPressureCalendarView = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 8.0),

              // Pressure line chart.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card.outlined(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8.0, 16.0, 4.0, 8.0),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        // Chart title
                        Text('Pressure (kPa)',
                            style: Theme.of(context).textTheme.headlineSmall),
                        const LineChartSample2(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
    );
  }
}

enum Calendar { day, week, month, year }
