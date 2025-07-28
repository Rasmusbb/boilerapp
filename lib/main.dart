import 'package:flutter/material.dart';
import 'logic/API.dart' as api;
import 'widgets/LoginScreen.dart';
import 'widgets/UserProfil.dart';

final homeKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool loggedIn = false;
  try {
    loggedIn = await api.accessTokenVaild().timeout(Duration(seconds: 5));
  } catch (e) {
    // handle error if necessary
  }
  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;

  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loggedIn ? MyHomePage(key: homeKey, title: "Home") : const LoginScreen(),
    );
  }
}
