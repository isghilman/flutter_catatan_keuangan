class Users {
  final int? userId;
  final String username;
  final String password;

  Users({
    this.userId,
    required this.username,
    required this.password,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        userId: json["userId"],
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "username": username,
        "password": password,
      };
}