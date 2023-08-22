class UserModel {
  final String id;
  final String username;
  final String email;
  final String creationDate;
  final bool verified;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.creationDate,
    required this.verified,
    required this.isAdmin,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? creationDate,
    int? points,
    bool? verified,
    List<dynamic>? favoriteRoutes,
    bool? isAdmin,
  }) =>
      UserModel(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        creationDate: creationDate ?? this.creationDate,
        verified: verified ?? this.verified,
        isAdmin: isAdmin ?? this.isAdmin,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        creationDate: json["creationDate"],
        verified: json["verified"],
        isAdmin: json["isAdmin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "creationDate": creationDate,
        "verified": verified,
        "isAdmin": isAdmin,
      };
}
