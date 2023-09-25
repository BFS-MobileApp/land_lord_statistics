class User {
  String name;
  String email;
  String token;
  bool active;

  User({
    required this.name,
    required this.email,
    required this.token,
    required this.active,
  });

  // Convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'token': token,
      'active': active ? 1 : 0, // Store bool as 1 (true) or 0 (false)
    };
  }

  // Create a User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      email: map['email'],
      token: map['token'],
      active: map['active'] == 1, // Convert 1 to true, 0 to false
    );
  }
}
