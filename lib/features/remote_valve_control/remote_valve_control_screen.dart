import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteValveControlScreen extends StatefulWidget {
  const RemoteValveControlScreen({super.key});

  @override
  State<RemoteValveControlScreen> createState() =>
      _RemoteValveControlScreenState();
}

class _RemoteValveControlScreenState extends State<RemoteValveControlScreen> {
  final db = FirebaseFirestore.instance;

  bool _isValveOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Get the initial state of the valve from Firestore.
    db
        .collection('devices')
        .doc('H2O-12345')
        .collection('flags')
        .doc('is_valve_open')
        .get()
        .then((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      _isValveOpen = data['value'] as bool;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Valve Control'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // A big circle button.
            ElevatedButton(
              onPressed: () async {
                _isValveOpen = !_isValveOpen;
                final isValveOpenData = <String, dynamic>{
                  'value': _isValveOpen,
                  'timestamp': DateTime.now(),
                };

                final iotDeviceRef = db.collection('devices').doc('H2O-12345');
                try {
                  await iotDeviceRef
                      .collection('flags')
                      .doc('is_valve_open')
                      .update(isValveOpenData);

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

                // Green if valve is open, red if valve is closed.
                iconColor: _isValveOpen ? Colors.green : Colors.red,
              ),
              child: const Icon(
                Icons.settings_remote,
                size: 100,
              ),
            ),
            const SizedBox(height: 20),

            // Stream builder to listen for changes in the valve state.
            StreamBuilder<DocumentSnapshot>(
              stream: db
                  .collection('devices')
                  .doc('H2O-12345')
                  .collection('flags')
                  .doc('is_valve_open')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('An error occurred.');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'Loading...',
                    style: TextStyle(fontSize: 24),
                  );
                }

                final data = snapshot.data?.data() as Map<String, dynamic>;
                final isValveOpen = data['value'] as bool;

                return Text(
                  isValveOpen ? 'Valve is open' : 'Valve is closed',
                  style: const TextStyle(fontSize: 24),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
