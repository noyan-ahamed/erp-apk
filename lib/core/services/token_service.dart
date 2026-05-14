import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String tokenKey = "jwt_token";
  static const String roleKey = "user_roles";
  static const String userKey = "current_user";
  static const String passwordChangedKey =
      "password_changed";

  //save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(tokenKey, token);
  }

  // get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(tokenKey);
  }

  // save role
  static Future<void> saveRoles(List<String> roles) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(roleKey, roles);
  }

  // get role
  static Future<List<String>> getRoles() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(roleKey) ?? [];
  }

  // delete token
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }

  // check login
  static Future<bool> isLoggedIn() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      return false;
    }

    // check is token expired
    bool isExpired = JwtDecoder.isExpired(token);

    if (isExpired) {
      await clearAll();

      return false;
    }

    return true;
  }

  // save current user
  static Future<void> saveUser(String userJson) async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(userKey, userJson);
  }

  // get current user
  static Future<String?> getUser() async {

    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getString(userKey);
  }
  // save password changed status
  static Future<void> savePasswordChanged(
      bool value,
      ) async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool(
      passwordChangedKey,
      value,
    );
  }

  // get password changed status
  static Future<bool> isPasswordChanged() async {

    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getBool(
        passwordChangedKey
    ) ??
        false;
  }

}