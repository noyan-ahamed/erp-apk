class LoginRequestModel {
  final String userName;
  final String userPassword;

  LoginRequestModel({
    required this.userName,
    required this.userPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "userPassword": userPassword,
    };
  }
}
