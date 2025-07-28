import 'package:boilerapp/widgets/DeleteButton.dart';
import 'package:boilerapp/widgets/Displays/UserDisplay.dart';
import 'package:boilerapp/widgets/Displays/BoilerDisplay.dart';
import '../logic/UserSecureStorage.dart';
import 'package:flutter/material.dart';
import '../logic/API.dart' as api;
import 'AddButton.dart';



class HomeDisplay extends StatelessWidget {
  final String homeID;
  final String name;
  final String description;
  final String address;
  final List<BoilerDisplay> boilers;
  const HomeDisplay({
    super.key,
    required this.homeID,
    required this.name,
    required this.description,
    required this.address,
    required this.boilers,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to a detailed screen when clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeDetailPage(
              homeID: homeID,
              name: name,
              description: description,
              address: address,
              boilers: boilers,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.blue,
        child: Column(
          children: [
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(description),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class HomeDetailPage extends StatefulWidget {
  final String homeID;
  final String name;
  final String description;
  final String address;
  List<BoilerDisplay> boilers;
  List<UserDisplay> members = [];

  HomeDetailPage({
    super.key,
    required this.homeID,
    required this.name,
    required this.description,
    required this.address,
    required this.boilers,
  });

  @override
  _HomeDetailPageState createState() => _HomeDetailPageState();

  }
class _HomeDetailPageState extends State<HomeDetailPage> {
  String ownerID = "";
  bool isOwner = false;
  @override
  void initState() {
    super.initState();
    widget.members = [];
    widget.boilers = [];
    _GetMembers();
    _GetBoilers();

  }
  void _AddBoiler(String name, String type) {
  }

  void _DelHome() async {
    var data = await api.delete('Homes/DeleteHome?HomeID=${widget.homeID}');
    data = data.toString();
    if (data == '"Deleted"') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Home deleted successfully')),
      );
      Navigator.pop(context, true); // Navigate back to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete home')),
      );
    }
  }

  void _AddMember(String name) async {
    final payload = {
      'homeID': widget.homeID,
      'email': name,
    };
    final data = await api.put('Homes/AddUserByEmail',payload);
    final user = data['Response'];
    if (user == null || user.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not found: $name')),
      );
      return;
    }
    setState(() {
      widget.members = [];
      _GetMembers();
    });
  }
void _GetMembers() async {
  final value = await api.get('Homes/GetHomeMembers?HomeID=${widget.homeID}');
  
  final currentUserID = await UserSecureStorage.getUserID();
  if (value != "") {
    for (var member in value) {
      if (member['role'] == "Owner") {
        ownerID = member['userID'];
      }
      setState(() {
        if (ownerID != ""){
          isOwner = (ownerID == currentUserID);
        } 
        widget.members.add(
          UserDisplay(
            key: Key(member['userID']),
            name: member['userName'],
            role: member['role'],
          ),
        );
      });
    }
  }
}


void _GetBoilers() async {
  final value = await api.get('Homes/GetBoilers?HomeID=${widget.homeID}');
  if (value != "") {
    for (var boiler in value) {
      setState(() {
        widget.boilers.add(BoilerDisplay(boilerID: boiler["boilerID"],name: boiler["boilerName"],description: boiler["boilerType"], type: boiler["boilerType"]));
      });
      print("=====================================");
      print("Boiler: ${boiler['boilerName']} of type ${boiler['boilerType']}");
      print("=====================================");
    }
  }
}



@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.name),
    ),
    body: Column(
      children: [
        Text(
          "Home Members",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Container(
          width: screenWidth * 0.8,
          height: screenWidth * 0.2 + (20 * widget.members.length),
          decoration: BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.members.length,
                  itemBuilder: (context, index) {
                    return widget.members[index];
                  },
                ),
              ),
                AddButton(
                  onAdd: (a, b) => _AddMember(a),
                  addType: "Member",
                  homeId: widget.homeID,
                ),
            ],
            
          ),
        ),
        Text(widget.description),
        Text(widget.address),
        Text(
          "Boilers",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.boilers.length,
            itemBuilder: (context, index) {
              return widget.boilers[index];
            },
          ),
        ),
        DeleteButton(
          tag: "DeleteHome",
          onDelete: _DelHome,
        ),
      ],
    ),
    // ✅ Conditional FAB
    floatingActionButton: isOwner
        ? AddButton(onAdd: _AddBoiler, addType: "Boiler", homeId: widget.homeID)
        : null,

  );
}

}