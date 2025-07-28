import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserSecureStorage {
  static final storage = FlutterSecureStorage();

  static const _keyEmail = 'Email';
  static const _keyAccessToken = 'AccessToken';
  static const _keyRefreshToken = 'RefreshToken';
  static Future setEmail(String email) async {
    await storage.write(key: _keyEmail, value: email);
  }

  static Future<String?> getEmail() async {
    return await storage.read(key: _keyEmail);
  }

  static Future setAccessToken(String? token) async {
    await storage.write(key: _keyAccessToken, value: token);
  }

  static Future<String?> getAccessToken() async {
    return await storage.read(key: _keyAccessToken);
  }

  static Future setRefreshToken(String? token) async {
    await storage.write(key: _keyRefreshToken, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await storage.read(key: _keyRefreshToken);
  }

  static Future<String?> getUserID () async {
    String? token = await getAccessToken();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['userID'];
    }
    return null;

  } 

  
}
