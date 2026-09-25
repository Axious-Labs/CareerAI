class UserModel {
  final String id;
  final String name;
  final String email;
  final String targetRole;
  final int careerReadiness;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.targetRole,
    this.careerReadiness = 68,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      targetRole: json['targetRole'] ?? 'AI/ML Engineer',
      careerReadiness: json['careerReadiness'] ?? 68,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'targetRole': targetRole,
      'careerReadiness': careerReadiness,
    };
  }
}
