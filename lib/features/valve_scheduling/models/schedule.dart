import 'package:flutter/material.dart';

class Schedule {
  Schedule({
    required this.startTime,
    required this.endTime,
    required this.days,
  });

  final TimeOfDay startTime;
  final TimeOfDay endTime;
  List<String> days;
}
