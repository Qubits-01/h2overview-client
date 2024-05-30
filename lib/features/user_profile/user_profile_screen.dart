import 'package:flutter/material.dart';
import 'models/user_model.dart'; // Import the UserModel class

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final userProfile = UserModel(
    name: 'H2Overview Corp',
    email: 'save_water@gmail.com',
    address: 'HQ, TL2, UP Diliman',
    phoneNumber: '695-965-6996',
  );

  String getInitials(String fullName) {
    List<String> names = fullName.split(' ');
    String initials = '';
    for (String name in names) {
      initials += name[0].toUpperCase();
    }
    return initials.length > 1 ? initials.substring(0, 2) : initials;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shadowColor: Colors.grey[300]!,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      radius: 24, // Adjust the size of the avatar
                      backgroundColor:
                          Colors.blue[800], // Background color of the avatar
                      child: Text(getInitials(userProfile.name),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24)), // Display initials
                    ),
                    title: Text(
                      userProfile.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.blue[800]),
                    title: Text(userProfile.email,
                        style: const TextStyle(fontSize: 16)),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_city, color: Colors.blue[800]),
                    title: Text(userProfile.address,
                        style: const TextStyle(fontSize: 16)),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.blue[800]),
                    title: Text(userProfile.phoneNumber,
                        style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
