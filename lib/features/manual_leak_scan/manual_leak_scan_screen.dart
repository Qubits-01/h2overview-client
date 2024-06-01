import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h2overview/utils/utils.dart';

class ManualLeakScanScreen extends StatefulWidget {
  const ManualLeakScanScreen({super.key});

  @override
  State<ManualLeakScanScreen> createState() => _ManualLeakScanScreenState();
}

class _ManualLeakScanScreenState extends State<ManualLeakScanScreen> {
  final db = FirebaseFirestore.instance;

  bool _isManualLeakScanRunning = false;
  String _scanType = 'quick';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Get the initial state of the valve from Firestore.
    db
        .collection('devices')
        .doc('H2O-12345')
        .collection('flags')
        .doc('is_manual_leak_scan_running')
        .get()
        .then((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      _isManualLeakScanRunning = data['value'] as bool;
      setState(() {});
    });
  }

  Future<Map<String, dynamic>> _getLatestManualResult() async {
    final result = db
        .collection('devices')
        .doc('H2O-12345')
        .collection('manual_results')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get()
        .then((snapshot) {
      final data = snapshot.docs.first.data();
      final timestamp = data['timestamp'] as Timestamp;
      final dateTime = timestamp.toDate();
      final leakResult = data['leak_result'] as String;
      final scanType = data['scan_type'] as String;

      return {
        'timestamp': dateTime,
        'leak_result': leakResultToReadable(leakResult),
        'scan_type': scanTypeToReadable(scanType),
      };
    });

    return result;
  }

  Future<Map<String, dynamic>> _getLatestAutoResult() async {
    final result = db
        .collection('devices')
        .doc('H2O-12345')
        .collection('auto_results')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get()
        .then((snapshot) {
      final data = snapshot.docs.first.data();
      final timestamp = data['timestamp'] as Timestamp;
      final dateTime = timestamp.toDate();
      final leakResult = data['leak_result'] as String;
      final scanType = data['scan_type'] as String;

      return {
        'timestamp': dateTime,
        'leak_result': leakResultToReadable(leakResult),
        'scan_type': scanTypeToReadable(scanType),
      };
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Manual Leak Scan'),
      // ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // A big circle button.
            ElevatedButton(
              onPressed: () async {
                // Is a manual leak scan already running? Get the data from Firestore.
                _isManualLeakScanRunning = await db
                    .collection('devices')
                    .doc('H2O-12345')
                    .collection('flags')
                    .doc('is_manual_leak_scan_running')
                    .get()
                    .then((snapshot) {
                  final data = snapshot.data() as Map<String, dynamic>;
                  return data['value'] as bool;
                });

                if (_isManualLeakScanRunning) {
                  // Show dialog with error message.
                  showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                            'A manual leak scan is already running.'),
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

                _isManualLeakScanRunning = !_isManualLeakScanRunning;
                final isManualLeakScanRunningData = <String, dynamic>{
                  'value': _isManualLeakScanRunning,
                  'scan_type': _scanType,
                  'timestamp': DateTime.now(),
                };

                final iotDeviceRef = db.collection('devices').doc('H2O-12345');
                try {
                  await iotDeviceRef
                      .collection('flags')
                      .doc('is_manual_leak_scan_running')
                      .update(isManualLeakScanRunningData);

                  setState(() {});
                } on FirebaseException catch (e) {
                  // Show dialog with error message.
                  showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text(e.message ?? 'An error occurred.'),
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
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(50),
              ),
              child: const Icon(
                Icons.settings_remote,
                size: 100,
              ),
            ),
            const SizedBox(height: 8.0),

            // Radio button selector for 'quick' or 'recommended' or 'long' scan.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio<String>(
                  value: 'quick',
                  groupValue: _scanType,
                  onChanged: (value) {
                    setState(() {
                      _scanType = value!;
                    });
                  },
                ),
                const Text('Quick'),
                Radio<String>(
                  value: 'recommended',
                  groupValue: _scanType,
                  onChanged: (value) {
                    setState(() {
                      _scanType = value!;
                    });
                  },
                ),
                const Text('Recommended'),
                Radio<String>(
                  value: 'long',
                  groupValue: _scanType,
                  onChanged: (value) {
                    setState(() {
                      _scanType = value!;
                    });
                  },
                ),
                const Text('Long'),
              ],
            ),
            const SizedBox(height: 48.0),

            // Stream builder to listen for changes in the valve state.
            StreamBuilder<DocumentSnapshot>(
              stream: db
                  .collection('devices')
                  .doc('H2O-12345')
                  .collection('flags')
                  .doc('is_manual_leak_scan_running')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('An error occurred.');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                }

                final data = snapshot.data?.data() as Map<String, dynamic>;
                final isManualLeakScanRunning = data['value'] as bool;

                return Column(
                  children: [
                    Text(
                      isManualLeakScanRunning
                          ? 'A manual scan is ongoing...'
                          : 'No manual scan is ongoing',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),

                    // Button to open the results dialog.
                    Visibility(
                      visible: true,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Latest Leak Scan Results'),
                                content: FutureBuilder<Map<String, dynamic>>(
                                  future: _getLatestManualResult(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text('Loading...');
                                    }

                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const Text('MANUAL MODE'),
                                        Text(
                                          'Leak Result: ${snapshot.data!['leak_result']}',
                                        ),
                                        Text(
                                          'Scan Type: ${snapshot.data!['scan_type']}',
                                        ),
                                        Text(
                                          'Timestamp: ${snapshot.data!['timestamp']}',
                                        ),
                                        const SizedBox(height: 20),
                                        FutureBuilder<Map<String, dynamic>>(
                                          future: _getLatestAutoResult(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Text('Loading...');
                                            }

                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                const Text('AUTO MODE'),
                                                Text(
                                                    'Leak Result: ${snapshot.data!['leak_result']}'),
                                                Text(
                                                    'Scan Type: ${snapshot.data!['scan_type']}'),
                                                Text(
                                                    'Timestamp: ${snapshot.data!['timestamp']}'),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
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
                        },
                        child: const Text('View Latest Result'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
