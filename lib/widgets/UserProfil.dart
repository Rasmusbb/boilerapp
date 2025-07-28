import 'package:flutter/material.dart';
import 'AddButton.dart';
import 'Home.dart';
import 'dart:convert';
import '../logic/API.dart' as api;
import 'LoginScreen.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BoilerApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 5, 243, 56)),
      ),
      home: const MyHomePage(title: 'BoilerApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<HomeDisplay> _homes = [];
  @override
  void initState() {
    super.initState();
    api.get('User/GetUsersHomes').then((value) {
      if (value != "") {
        for (var home in value) {
          setState(() {
            _homes.add(HomeDisplay(
            homeID: home['homeID'],
            name: home['homeName'],
            address: home['address'],
            description: "Home Description",
            boilers: [],
          ),);});
        }
      }
    });
  }

  void _AddHome(String name, String address) {
    final payload = {
      'homeName': name,
      'address': address,
    };
    api.post('Homes/AddHome', payload).then((value) {
      Map<String, dynamic> data = json.decode(value["Response"]);
      HomeDisplay home = HomeDisplay(
        homeID: data["homeID"],
        name: data['homeName'],
        address: data['address'],
        description: 'Home Description',
        boilers: [],
      );
    setState(() {
      _homes.add(home);
    });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Homes'),
        actions: [
          IconButton (
            icon: const Icon(Icons.logout),
            onPressed: () {
              api.delete('User/LogoutUser').then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
                            });
            },
          ),
        ],

      ),
      body: ListView.builder(
        itemCount: _homes.length,
        itemBuilder: (context, index) {
          return _homes[index];
        },
      ),
      floatingActionButton:
      AddButton(
        onAdd: _AddHome, 
        addType: "Home",
        homeId: "Not needed",)
    );
  }
}
