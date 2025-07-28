import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';



class UserDisplay extends StatefulWidget{
  final String name;
  final String role;
  const UserDisplay({
    super.key,
    required this.name,
    required this.role,
  });

  @override
  State<UserDisplay> createState() => _UserDisplayState();
}

class _UserDisplayState extends State<UserDisplay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        color: Colors.blue,
        child: Column(
          children: [
            Text("${widget.name} (${widget.role})", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
          ],
          
        ),
      ),
    );
  }
}


