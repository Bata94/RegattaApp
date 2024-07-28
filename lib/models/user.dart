class JWT {
  String token;
  DateTime expiration;

  JWT({
    required this.token,
    required this.expiration,
  });

  factory JWT.fromJson(Map<String, dynamic> json) {
    return JWT(
      token: json['token'],
      expiration: DateTime.parse(json['expiration']),
    );
  }
}

class User {
  String ulid;
  String username;
  JWT jwt;

  User({
    required this.ulid,
    required this.username,
    required this.jwt
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      ulid: json['ulid'],
      username: json['username'],
      jwt: JWT.fromJson(json['jwt']),
    );
  }
}

