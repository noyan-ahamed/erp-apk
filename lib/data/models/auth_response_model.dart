class AuthResponseModel {
  final String token;
  final List<String> roles;
  final bool passwordChanged;

  AuthResponseModel({
    required this.token,
    required this.roles,
    required this.passwordChanged,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'],
      roles: List<String>.from(json['roles']),
      passwordChanged: json['passwordChanged'],
    );
  }
}
