import 'package:flutter/material.dart';

class Schedule {
  Schedule({
    required this.startTime,
    required this.days,
  });

  final TimeOfDay startTime;
  List<String> days;
}
