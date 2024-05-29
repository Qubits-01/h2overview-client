import 'package:flutter/material.dart';
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

    // switch (selectedScreen) {
    //   case 0:
    //     Navigator.of(context).push(MaterialPageRoute<void>(
    //       builder: (BuildContext context) {
    //         return const UserProfileScreen();
    //       },
    //     ));
    //     break;
    //   case 1:
    //     Navigator.of(context).push(MaterialPageRoute<void>(
    //       builder: (BuildContext context) {
    //         return const AnalyticsScreen();
    //       },
    //     ));
    //     break;
    //   case 2:
    //     Navigator.of(context).push(MaterialPageRoute<void>(
    //       builder: (BuildContext context) {
    //         return const ManualLeakScanScreen();
    //       },
    //     ));
    //     break;
    //   case 3:
    //     Navigator.of(context).push(MaterialPageRoute<void>(
    //       builder: (BuildContext context) {
    //         return const HealthCheckSchedulingScreen();
    //       },
    //     ));
    //     break;
    //   case 4:
    //     Navigator.of(context).push(MaterialPageRoute<void>(
    //       builder: (BuildContext context) {
    //         return const RemoteValveControlScreen();
    //       },
    //     ));
    //     break;
    //   case 5:
    //     Navigator.of(context).push(MaterialPageRoute<void>(
    //       builder: (BuildContext context) {
    //         return const ValveSchedulingScreen();
    //       },
    //     ));
    //     break;
    //   default:
    //     Navigator.of(context).push(MaterialPageRoute<void>(
    //       builder: (BuildContext context) {
    //         return const UserProfileScreen();
    //       },
    //     ));
    // }
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return const UserProfileScreen();
      case 1:
        return const AnalyticsScreen();
      case 2:
        return const ManualLeakScanScreen();
      case 3:
        return const HealthCheckSchedulingScreen();
      case 4:
        return const RemoteValveControlScreen();
      case 5:
        return const ValveSchedulingScreen();
      default:
        return const UserProfileScreen();
    }
  }

  String getScreenTitle(int index) {
    switch (index) {
      case 0:
        return 'User Profile';
      case 1:
        return 'Analytics';
      case 2:
        return 'Manual Leak Scan';
      case 3:
        return 'Health Check Scheduling';
      case 4:
        return 'Remote Valve Control';
      case 5:
        return 'Valve Scheduling';
      default:
        return 'User Profile';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getScreenTitle(_screenIndex)),
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
            label: Text('User Profile'),
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
          ),
          const NavigationDrawerDestination(
            label: Text('Analytics'),
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
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
        ],
      ),
      body: getBody(_screenIndex),
    );
  }
}
