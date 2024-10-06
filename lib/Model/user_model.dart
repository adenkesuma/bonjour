class User {
  String? username;
  String? tier;
  bool status;

  User([
    this.username, 
    this.tier, 
    this.status = false
  ]);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['username'] as String, 
      json['tier'] as String,
      json['status'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'tier': tier,
      'status': status,
    };
  }
}