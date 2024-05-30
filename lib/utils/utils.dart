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
    case 'Sunday':
      return 0;
    case 'Monday':
      return 1;
    case 'Tuesday':
      return 2;
    case 'Wednesday':
      return 3;
    case 'Thursday':
      return 4;
    case 'Friday':
      return 5;
    case 'Saturday':
      return 6;
    default:
      return 0;
  }
}

String numDayToStringDay(int numDay) {
  switch (numDay) {
    case 0:
      return 'Sunday';
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    default:
      return 'Sunday';
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

String scanTypeToReadable(String scanType) {
  switch (scanType) {
    case 'quick':
      return 'Quick';
    case 'recommended':
      return 'Recommended';
    case 'long':
      return 'Long';
    default:
      return 'Quick';
  }
}

String leakResultToReadable(String leakResult) {
  switch (leakResult) {
    case 'no_leak':
      return 'No leak detected :)';
    case 'leak':
      return 'Leak detected!';
    case 'error':
      return 'Error! Something went wrong';
    default:
      return 'No leak detected :)';
  }
}
