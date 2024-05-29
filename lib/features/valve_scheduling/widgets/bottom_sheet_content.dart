import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:h2overview/utils/utils.dart';
import 'package:intl/intl.dart';

import '../models/schedule.dart';

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent(List<Schedule> schedules, {super.key})
      : _schedules = schedules;

  final List<Schedule> _schedules;

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  final db = FirebaseFirestore.instance;
  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  // ignore: prefer_final_fields
  List<String> _selectedDays = [];
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool _isStartTimeLessThanEndTime() {
    if (_startTime == null || _endTime == null) {
      return false;
    }

    DateTime startTime =
        DateTime(2021, 1, 1, _startTime!.hour, _startTime!.minute);
    DateTime endTime = DateTime(2021, 1, 1, _endTime!.hour, _endTime!.minute);

    return startTime.isBefore(endTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Start time.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Start Time',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8.0),
                    if (_startTime != null)
                      Text(
                        DateFormat.jm().format(
                          DateTime(
                            2021,
                            1,
                            1,
                            _startTime!.hour,
                            _startTime!.minute,
                          ),
                        ),
                      )
                    else
                      const Text('__ : __  AM/PM'),
                  ],
                ),
                Column(
                  children: <Widget>[
                    FilledButton.tonal(
                      onPressed: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((time) {
                          setState(() {
                            _startTime = time;
                          });
                        });
                      },
                      child: const Text('Select Time'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // End time.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'End Time',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8.0),
                    if (_endTime != null)
                      Text(DateFormat.jm().format(DateTime(
                          2021, 1, 1, _endTime!.hour, _endTime!.minute)))
                    else
                      const Text('__ : __  AM/PM'),
                  ],
                ),
                Column(
                  children: <Widget>[
                    FilledButton.tonal(
                      onPressed: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((time) {
                          setState(() {
                            _endTime = time;
                          });
                        });
                      },
                      child: const Text('Select Time'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),

            // Days Selection Chips.
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _daysOfWeek.map((String day) {
                return ChoiceChip(
                  label: Text(day),
                  selected: _selectedDays.contains(day),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedDays.add(day);
                      } else {
                        _selectedDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 48.0),

            // Save Button.
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // Validate start time should not be null.
                  if (_startTime == null) {
                    // Show dialog with error message.
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Bruh...'),
                          content: const Text('Please select a start time.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  // Validate end time should not be null.
                  if (_endTime == null) {
                    // Show dialog with error message.
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Bruh...'),
                          content: const Text('Please select an end time.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  // Validate that the end time is greater than the start time.
                  if (!_isStartTimeLessThanEndTime()) {
                    // Show dialog with error message.
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Bruh...'),
                          content: const Text(
                              'The end time should be greater than the start time.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  // TODO: Validation that this schedule has no intersection with other schedules.

                  // Validate that at least one day is selected.
                  if (_selectedDays.isEmpty) {
                    // Show dialog with error message.
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Bruh...'),
                          content:
                              const Text('Please select at least one day.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  // // Save the schedule.
                  // final newSchedule = Schedule(
                  //   startTime: _startTime!,
                  //   endTime: _endTime!,
                  //   days: _selectedDays,
                  // );

                  // widget._schedules.add(newSchedule);

                  final List<int> days = _selectedDays.map((day) {
                    return fromDayStringToInt(day);
                  }).toList();
                  days.sort();

                  final int startTime = fromTimeOfDayToMinutesFromMidnight(
                    _startTime!,
                  );
                  final int endTime = fromTimeOfDayToMinutesFromMidnight(
                    _endTime!,
                  );

                  // Save the new schedule to Firestore.
                  db
                      .collection('devices')
                      .doc('H2O-12345')
                      .collection('preferences')
                      .doc('scheduled_valve_control')
                      .update({
                    'schedules': FieldValue.arrayUnion(
                      [
                        {
                          'days': days,
                          'start_time': startTime,
                          'end_time': endTime,
                        },
                      ],
                    ),
                  });

                  // setState(() {});

                  Navigator.pop(context);
                },
                child: const Text('Save Schedule'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
