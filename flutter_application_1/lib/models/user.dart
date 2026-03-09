class User {

  final int id;
  final String username;
  final String role;
  final String? fullname;

  User({
    required this.id,
    required this.username,
    required this.role,
    this.fullname,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      username: json["username"],
      role: json["role"],
      fullname: json["fullname"],
    );
  }

}