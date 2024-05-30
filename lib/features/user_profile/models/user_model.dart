class UserModel {
  final String name;
  final String email;
  final String address;
  final String phoneNumber;

  UserModel({
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
