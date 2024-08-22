class UserModel {
  final String name;
  final String age;
  final String gender;
  final String phoneNumber;
  final String? password;

  UserModel({
    required this.name,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    this.password,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'] ?? '',
      age: data['age'] ?? '',
      gender: data['gender'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }
}
