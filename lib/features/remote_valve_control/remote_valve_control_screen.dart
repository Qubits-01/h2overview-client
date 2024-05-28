import 'package:flutter/material.dart';

class RemoteValveControlScreen extends StatelessWidget {
  const RemoteValveControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Valve Control'),
      ),
      body: const Center(
        child: Text('Remote Valve Control Screen'),
      ),
    );
  }
}
