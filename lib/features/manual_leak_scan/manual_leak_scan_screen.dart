import 'package:flutter/material.dart';

class ManualLeakScanScreen extends StatelessWidget {
  const ManualLeakScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Leak Scan'),
      ),
      body: const Center(
        child: Text('Manual Leak Scan Screen'),
      ),
    );
  }
}
