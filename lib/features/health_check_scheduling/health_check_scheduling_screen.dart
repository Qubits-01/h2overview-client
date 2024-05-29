import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../utils/utils.dart';
import 'models/schedule.dart';
import 'widgets/bottom_sheet_content.dart';
import 'widgets/is_enabled_switch.dart';

class HealthCheckSchedulingScreen extends StatefulWidget {
  const HealthCheckSchedulingScreen({super.key});

  @override
  State<HealthCheckSchedulingScreen> createState() =>
      _HealthCheckSchedulingScreenState();
}

class _HealthCheckSchedulingScreenState
    extends State<HealthCheckSchedulingScreen> {
  final db = FirebaseFirestore.instance;
  List<Schedule> _schedules = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Is Enabled Switch.
                const IsEnabledSwitch(),
                const SizedBox(height: 16),

                // Get the schedules from Firestore.
                StreamBuilder<DocumentSnapshot>(
                  stream: db
                      .collection('devices')
                      .doc('H2O-12345')
                      .collection('preferences')
                      .doc('scheduled_health_scan')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Text('An error occurred.');
                    }

                    // Get the schedules from the snapshot.
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final schedules = data['schedules'] as List<dynamic>;

                    // If there are no schedules.
                    if (schedules.isEmpty) {
                      return Card.outlined(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: <Widget>[
                              // Show an svg illustration.
                              SvgPicture.asset(
                                'assets/illustrations/undraw_time_management_re_tk5w.svg',
                                width: 120.0,
                              ),
                              const SizedBox(height: 16),
                              const Text('No schedules added yet.',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  )),
                            ],
                          ),
                        ),
                      );
                    }

                    // Convert the schedules to a list of Schedule objects.
                    _schedules = schedules.map((schedule) {
                      final rawDays = schedule['days'] as List<dynamic>;
                      final List<int> days =
                          rawDays.map((day) => day as int).toList();
                      days.sort();

                      return Schedule(
                        startTime: minutesFromMidnightToTimeOfDay(
                            schedule['start_time'] as int),
                        days: days.map((day) {
                          return numDayToStringDay(day);
                        }).toList(),
                      );
                    }).toList();

                    return Column(
                      children: <Widget>[
                        ..._schedules.map(
                          (Schedule schedule) {
                            return Column(
                              children: <Widget>[
                                Slidable(
                                  // The start action pane is the one at the left or the top side.
                                  startActionPane: ActionPane(
                                    // A motion is a widget used to control how the pane animates.
                                    motion: const ScrollMotion(),

                                    // All actions are defined in the children parameter.
                                    children: [
                                      // A SlidableAction can have an icon and/or a label.
                                      SlidableAction(
                                        onPressed: (context) {
                                          // Show dialog asking for confirmation. The dialog should not close if tapped outside.
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Delete Schedule'),
                                                content: const Text(
                                                    'Are you sure you want to delete this schedule?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        _schedules
                                                            .remove(schedule);
                                                      });

                                                      // Delete the schedule from Firestore.
                                                      await db
                                                          .collection('devices')
                                                          .doc('H2O-12345')
                                                          .collection(
                                                              'preferences')
                                                          .doc(
                                                              'scheduled_health_scan')
                                                          .update({
                                                        'schedules': _schedules
                                                            .map((schedule) {
                                                          return {
                                                            'start_time':
                                                                fromTimeOfDayToMinutesFromMidnight(
                                                                    schedule
                                                                        .startTime),
                                                            'days': schedule
                                                                .days
                                                                .map((day) {
                                                              return fromDayStringToInt(
                                                                  day);
                                                            }).toList(),
                                                          };
                                                        }).toList(),
                                                      });

                                                      if (context.mounted) {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12.0),
                                          bottomLeft: Radius.circular(12.0),
                                        ),
                                        backgroundColor:
                                            const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: Card.outlined(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              // Format: From startTime to endTime.
                                              Text(
                                                  'Starts at ${DateFormat.jm().format(DateTime(
                                                2021,
                                                1,
                                                1,
                                                schedule.startTime.hour,
                                                schedule.startTime.minute,
                                              ))}'),
                                              const SizedBox(height: 8),

                                              // Circular widget with the days of the week.
                                              Wrap(
                                                children: <Widget>[
                                                  for (final day
                                                      in schedule.days)
                                                    Container(
                                                      width: 48.0,
                                                      height: 48.0,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.blue,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Text(
                                                        dayStringToAbbreviation(
                                                            day),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Add a new schedule button.
                FilledButton.tonal(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return BottomSheetContent(_schedules);
                      },
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text('Add New Schedule'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
