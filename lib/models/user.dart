class User {
  String ulid;
  String username;
  String jwt;

  User({
    required this.ulid,
    required this.username,
    required this.jwt
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      ulid: json['ulid'],
      username: json['username'],
      jwt: json['jwt'],
    );
  }
}

