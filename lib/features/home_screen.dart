import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'analytics/analytics_screen.dart';
import 'manual_leak_scan/manual_leak_scan_screen.dart';
import 'remote_valve_control/remote_valve_control_screen.dart';
import 'valve_scheduling/valve_scheduling_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('H2Overview FE + BE POC'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'This is a POC build of H2Overview',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Analytics'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AnalyticsScreen();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.leak_add),
              title: const Text('Manual Leak Scan'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ManualLeakScanScreen();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Valve Scheduling'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ValveSchedulingScreen();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Remote Valve Control'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const RemoteValveControlScreen();
                }));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Hello, World!'),
      ),
    );
  }
}
