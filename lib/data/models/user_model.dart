class UserModel {
  final String? name;
  final String? username;
  final String? email;
  final String? imageBase64;
  final String? imageType;
  final String? status;
  final String? createdAt;

  UserModel({
    this.name,
    this.username,
    this.email,
    this.imageBase64,
    this.imageType,
    this.status,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      username: json['username'],
      email: json['email'],
      imageBase64: json['imageBase64'],
      imageType: json['imageType'],
      status: json['status'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "username": username,
      "email": email,
      "imageBase64": imageBase64,
      "imageType": imageType,
      "status": status,
      "createdAt": createdAt,
    };
  }
}