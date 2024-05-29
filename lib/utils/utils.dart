// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Future<bool> isAlive() async {
//   final db = FirebaseFirestore.instance;

//   final ref = db
//       .collection('devices')
//       .doc('H2O-12345')
//       .collection('flags')
//       .doc('is_alive');

//   // Trigger is_alive in the backend (MQQT).
//   await ref.set(
//     <String, dynamic>{
//       'value': false,
//       'timestamp': DateTime.now(),
//     },
//   );

//   // Listen to the is_alive flag. If no changes are detected within 5 seconds, return false.
//   // Otherwise, return true. Use real-time listeners to listen to changes in Firestore.
//   ref.snapshots().listen((snapshot) {
//     final data = snapshot.data() as Map<String, dynamic>;
//     if (data['value'] == false) {
//       return false;
//     }
//   });
// }

int fromDayStringToInt(String day) {
  switch (day) {
    case 'Saturday':
      return 0;
    case 'Sunday':
      return 1;
    case 'Monday':
      return 2;
    case 'Tuesday':
      return 3;
    case 'Wednesday':
      return 4;
    case 'Thursday':
      return 5;
    case 'Friday':
      return 6;
    default:
      return 0;
  }
}

String numDayToStringDay(int numDay) {
  switch (numDay) {
    case 0:
      return 'Saturday';
    case 1:
      return 'Sunday';
    case 2:
      return 'Monday';
    case 3:
      return 'Tuesday';
    case 4:
      return 'Wednesday';
    case 5:
      return 'Thursday';
    case 6:
      return 'Friday';
    default:
      return 'Saturday';
  }
}

String dayStringToAbbreviation(String day) {
  switch (day) {
    case 'Saturday':
      return 'Sat';
    case 'Sunday':
      return 'Sun';
    case 'Monday':
      return 'Mon';
    case 'Tuesday':
      return 'Tue';
    case 'Wednesday':
      return 'Wed';
    case 'Thursday':
      return 'Thu';
    case 'Friday':
      return 'Fri';
    default:
      return 'Sat';
  }
}

TimeOfDay minutesFromMidnightToTimeOfDay(int minutesFromMidnight) {
  final int hours = minutesFromMidnight ~/ 60;
  final int minutes = minutesFromMidnight % 60;

  return TimeOfDay(hour: hours, minute: minutes);
}

int fromTimeOfDayToMinutesFromMidnight(TimeOfDay time) {
  return time.hour * 60 + time.minute;
}
