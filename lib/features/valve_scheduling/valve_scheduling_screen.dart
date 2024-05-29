import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'models/schedule.dart';
import 'widgets/bottom_sheet_content.dart';

class ValveSchedulingScreen extends StatefulWidget {
  const ValveSchedulingScreen({super.key});

  @override
  State<ValveSchedulingScreen> createState() => _ValveSchedulingScreenState();
}

class _ValveSchedulingScreenState extends State<ValveSchedulingScreen> {
  bool _isEnabled = false;
  // ignore: prefer_final_fields
  List<Schedule> _schedules = [];

  @override
  void initState() {
    super.initState();

    // Mock data.
    _schedules = [
      Schedule(
        startTime: const TimeOfDay(hour: 8, minute: 15),
        endTime: const TimeOfDay(hour: 10, minute: 0),
        days: ['Monday', 'Wednesday', 'Friday'],
      ),
      Schedule(
        startTime: const TimeOfDay(hour: 12, minute: 0),
        endTime: const TimeOfDay(hour: 14, minute: 30),
        days: ['Tuesday', 'Thursday'],
      ),
      Schedule(
        startTime: const TimeOfDay(hour: 8, minute: 15),
        endTime: const TimeOfDay(hour: 10, minute: 0),
        days: ['Monday', 'Wednesday', 'Friday'],
      ),
      Schedule(
        startTime: const TimeOfDay(hour: 12, minute: 0),
        endTime: const TimeOfDay(hour: 14, minute: 30),
        days: ['Tuesday', 'Thursday'],
      ),
      Schedule(
        startTime: const TimeOfDay(hour: 8, minute: 15),
        endTime: const TimeOfDay(hour: 10, minute: 0),
        days: ['Monday', 'Wednesday', 'Friday'],
      ),
      Schedule(
        startTime: const TimeOfDay(hour: 12, minute: 0),
        endTime: const TimeOfDay(hour: 14, minute: 30),
        days: ['Tuesday', 'Thursday'],
      ),
      Schedule(
        startTime: const TimeOfDay(hour: 8, minute: 15),
        endTime: const TimeOfDay(hour: 10, minute: 0),
        days: ['Monday', 'Wednesday', 'Friday'],
      ),
      Schedule(
        startTime: const TimeOfDay(hour: 12, minute: 0),
        endTime: const TimeOfDay(hour: 14, minute: 30),
        days: ['Tuesday', 'Thursday'],
      ),
    ];
  }

  int _fromDayStringToInt(String day) {
    switch (day) {
      case 'Monday':
        return DateTime.monday;
      case 'Tuesday':
        return DateTime.tuesday;
      case 'Wednesday':
        return DateTime.wednesday;
      case 'Thursday':
        return DateTime.thursday;
      case 'Friday':
        return DateTime.friday;
      case 'Saturday':
        return DateTime.saturday;
      case 'Sunday':
        return DateTime.sunday;
      default:
        return DateTime.monday;
    }
  }

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
                Card(
                  child: SwitchListTile(
                    value: _isEnabled,
                    title: const Text('Is Enabled'),
                    subtitle:
                        const Text('Enable or disable the valve scheduling'),
                    // Remove the padding around the SwitchListTile.
                    // contentPadding: EdgeInsets.zero,
                    shape: ShapeBorder.lerp(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      1,
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        _isEnabled = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Container that displays the schedules.
                ..._schedules.map(
                  (Schedule schedule) {
                    return Column(
                      children: <Widget>[
                        Card.outlined(
                          child: Slidable(
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
                                          title: const Text('Delete Schedule'),
                                          content: const Text(
                                              'Are you sure you want to delete this schedule?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _schedules.remove(schedule);
                                                });
                                                Navigator.of(context).pop();
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
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  // Format: From startTime to endTime.
                                  Text('From ${DateFormat.jm().format(
                                    DateTime(
                                      2021,
                                      1,
                                      1,
                                      schedule.startTime.hour,
                                      schedule.startTime.minute,
                                    ),
                                  )} to ${DateFormat.jm().format(
                                    DateTime(
                                      2021,
                                      1,
                                      1,
                                      schedule.endTime.hour,
                                      schedule.endTime.minute,
                                    ),
                                  )}'),
                                  const SizedBox(height: 8),

                                  // Circular widget with the days of the week.
                                  Wrap(
                                    children: <Widget>[
                                      for (final day in schedule.days)
                                        Container(
                                          width: 48.0,
                                          height: 48.0,
                                          margin: const EdgeInsets.all(4.0),
                                          padding: const EdgeInsets.all(4.0),
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            DateFormat.E().format(
                                              DateTime(2021, 1, 1, 0, 0).add(
                                                  Duration(
                                                      days: _fromDayStringToInt(
                                                          day))),
                                            ),
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
                          ),
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    );
                  },
                ),

                // If there are no schedules.
                if (_schedules.isEmpty)
                  Card.outlined(
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
