class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String plan;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.plan,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name_text'] ?? 'N/A',
      email: json['emailtext_text'] ?? json['authentication']?['email']?['email'] ?? 'N/A',
      avatarUrl: json['avatar_image'] != null
          ? 'https:${json['avatar_image']}'
          : null,
      plan: json['userplan_option_user_type'] ?? 'Free',
    );
  }
}
