class FirstPasswordChangeRequest {

  final String newPassword;
  final String confirmPassword;

  FirstPasswordChangeRequest({
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {

    return {
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };
  }
}