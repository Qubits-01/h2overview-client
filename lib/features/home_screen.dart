import 'package:flutter/material.dart';
import 'package:h2overview/features/analytics/analytics_test_screen.dart';
import 'health_check_scheduling/health_check_scheduling_screen.dart';
import 'user_profile/user_profile_screen.dart';

import 'analytics/analytics_screen.dart';
import 'manual_leak_scan/manual_leak_scan_screen.dart';
import 'remote_valve_control/remote_valve_control_screen.dart';
import 'valve_scheduling/valve_scheduling_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _screenIndex = 0;

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      _screenIndex = selectedScreen;

      // Close the drawer after the user selects a screen.
      Navigator.of(context).pop();
    });
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return const AnalyticsScreen();
      case 1:
        return const UserProfileScreen();
      case 2:
        return const ManualLeakScanScreen();
      case 3:
        return const HealthCheckSchedulingScreen();
      case 4:
        return const RemoteValveControlScreen();
      case 5:
        return const ValveSchedulingScreen();
      case 6:
        return const LineChartSample2();
      default:
        return const AnalyticsScreen();
    }
  }

  String getScreenTitle(int index) {
    switch (index) {
      case 0:
        return 'Analytics';
      case 1:
        return 'User Profile';
      case 2:
        return 'Manual Leak Scan';
      case 3:
        return 'Health Check Scheduling';
      case 4:
        return 'Remote Valve Control';
      case 5:
        return 'Valve Scheduling';
      case 6:
        return 'Data Visualization';
      default:
        return 'Analytics';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getScreenTitle(_screenIndex)),
        actions: <Widget>[
          // Info
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show info dialog.
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('H2Overview'),
                    content: const Text(
                      'This is a demo app for a fictitious company called H2Overview. '
                      'The app is designed to help users manage their water systems. '
                      'This demo app is not connected to any real water systems. '
                      'The app is for demonstration purposes only.',
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
          ),
        ],
      ),
      drawer: NavigationDrawer(
        onDestinationSelected: handleScreenChanged,
        selectedIndex: _screenIndex,
        children: <Widget>[
          // Main
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'Main',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const NavigationDrawerDestination(
            label: Text('Analytics'),
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
          ),
          const NavigationDrawerDestination(
            label: Text('User Profile'),
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),

          // Leak Detection
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'Leak Detection',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const NavigationDrawerDestination(
            label: Text('Manual Leak Scan'),
            icon: Icon(Icons.leak_add),
            selectedIcon: Icon(Icons.leak_add),
          ),
          const NavigationDrawerDestination(
            label: Text('Health Check Scheduling'),
            icon: Icon(Icons.health_and_safety_outlined),
            selectedIcon: Icon(Icons.health_and_safety),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),

          // Valve Control
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'Valve Control',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const NavigationDrawerDestination(
            label: Text('Remote Valve Control'),
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
          ),
          const NavigationDrawerDestination(
            label: Text('Valve Scheduling'),
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),

          // Playground
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'Playground',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const NavigationDrawerDestination(
            label: Text('Data Visualization'),
            icon: Icon(Icons.graphic_eq_outlined),
            selectedIcon: Icon(Icons.graphic_eq),
          ),
        ],
      ),
      body: getBody(_screenIndex),
    );
  }
}
