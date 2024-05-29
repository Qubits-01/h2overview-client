import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ValveSchedulingScreen extends StatelessWidget {
  const ValveSchedulingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Valve Scheduling'),
        // ),
        // body: StreamBuilder<QuerySnapshot>(
        //   stream: FirebaseFirestore.instance
        //       .collection('your_collection_name')
        //       .snapshots(),
        //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //     if (snapshot.hasError) {
        //       return Text('Something went wrong');
        //     }

        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Text("Loading");
        //     }

        //     return ListView(
        //       children: snapshot.data!.docs.map((DocumentSnapshot document) {
        //         Map<String, dynamic> data = document.data()!;
        //         return ListTile(
        //           title: Text(data[
        //               'title']), // Adjust according to your document structure
        //         );
        //       }).toList(),
        //     );
        //   },
        // ),
        );
  }
}
