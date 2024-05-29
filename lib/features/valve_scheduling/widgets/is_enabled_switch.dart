import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IsEnabledSwitch extends StatefulWidget {
  const IsEnabledSwitch({super.key});

  @override
  State<IsEnabledSwitch> createState() => _IsEnabledSwitchState();
}

class _IsEnabledSwitchState extends State<IsEnabledSwitch> {
  final db = FirebaseFirestore.instance;
  bool _isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db
          .collection('devices')
          .doc('H2O-12345')
          .collection('preferences')
          .doc('scheduled_valve_control')
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        _isEnabled = data['is_enabled'] as bool;

        return Card(
          child: SwitchListTile(
            value: _isEnabled,
            title: const Text('Is Enabled'),
            subtitle: const Text('Enable or disable the valve scheduling'),
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
            onChanged: (bool value) async {
              setState(() {
                _isEnabled = value;
              });

              final isEnabledData = <String, dynamic>{
                'is_enabled': _isEnabled,
                'timestamp': DateTime.now(),
              };

              try {
                await db
                    .collection('devices')
                    .doc('H2O-12345')
                    .collection('preferences')
                    .doc('scheduled_valve_control')
                    .update(isEnabledData);
              } catch (e) {
                // Revert  the switch state if the update fails.
                setState(() {
                  _isEnabled = !_isEnabled;
                });
              }
            },
          ),
        );
      },
    );
  }
}
