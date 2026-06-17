class UserModel {
  final int id;
  final String email;
  final String role;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.profileImage,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      profileImage: json['profile_image'],
    );
  }
}