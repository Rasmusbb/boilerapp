import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'UserSecureStorage.dart';
import 'dart:convert';

final storage = FlutterSecureStorage(); 
final String apiurl = 'http://apimoniteringapp.runasp.net/'; 
Future<Map<String, dynamic>> post(String call, Map<String, dynamic> payload) async {
  final response = await http.post(
    Uri.parse(apiurl + call),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await storage.read(key: 'AccessToken')}',
    },
    body: jsonEncode(payload),
  );
  if (call == 'User/Login') {
    Map<String, dynamic> data = jsonDecode(response.body);
    data["status"] = response.statusCode;
    await UserSecureStorage.setAccessToken(data['accessToken'] ?? '');
    await UserSecureStorage.setRefreshToken(data['refreshToken'] ?? '');
    if(response.statusCode == 201 || response.statusCode == 200){
      return data;
    }
  }

    return {'status': response.statusCode, 'Response': response.body}; // <-- this returns a Map
  }



Future<dynamic> get(String call) async {
  print(apiurl + call);
  final response = await http.get(
    Uri.parse(apiurl + call),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await storage.read(key: 'AccessToken')}',
    },
  );
  try{
    if(response.body == ""){
      return "";
    }
    return jsonDecode(response.body);
  }catch(e){
    print("Error decoding JSON: $e");
    print("Response body: ${response.body}");
    return "";
  }
}

Future<Map<String,dynamic>> put(String call, Map<String, dynamic> payload) async {
  final response = await http.put(
    Uri.parse(apiurl + call),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await storage.read(key: 'AccessToken')}',
    },
    body: jsonEncode(payload),
  );
  if (call == 'User/UpdateUser') {
    Map<String, dynamic> data = jsonDecode(response.body);
    data["status"] = response.statusCode;
    UserSecureStorage.setAccessToken(data['accessToken'] ?? '');
    UserSecureStorage.setRefreshToken(data['refreshToken'] ?? '');
    return data;
  }
  return {'status': response.statusCode, 'Response': response.body}; // <-- this returns a Map
}


Future<String> delete(String call) async {
  final response = await http.delete(
    Uri.parse(apiurl + call),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await storage.read(key: 'AccessToken')}',
    },
  );
  if(call == 'User/Logout') {
    UserSecureStorage.setAccessToken(null);
    UserSecureStorage.setRefreshToken(null);
  } 
  return response.body;

}




Future<bool> accessTokenVaild() async {
  String? accessToken = await UserSecureStorage.getAccessToken();
  String? refreshToken = await UserSecureStorage.getRefreshToken();
  if(accessToken != null || accessToken != '') {
    bool isexpired = JwtDecoder.isExpired(accessToken ?? '');
    if (isexpired) {
      if (refreshToken == null) {
        print("Refresh token is null");
        return false;
      }
      print("Access token is expired");
      final payload = {
        'refreshToken': refreshToken,
        'accessToken': accessToken,
      };
      final response = await post("User/RefreshToken",payload);
        if (response['status'] == 200) {
          UserSecureStorage.setAccessToken(response['accessToken'] ?? '');
          UserSecureStorage.setRefreshToken(response['refreshToken'] ?? '');
          return true;
        }
      } else {
        return true;
      }
    }else{
      print("Access token is null");
  }
  return false;
}



