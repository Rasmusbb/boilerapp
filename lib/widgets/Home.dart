import 'package:flutter/material.dart';
import 'BoilerDisplay.dart';
import 'AddButton.dart';



class HomeDisplay extends StatelessWidget {
  final String name;
  final String description;
  final String address;
  final List<BoilerDisplay> boilers;
  const HomeDisplay({
    super.key,
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
  final String name;
  final String description;
  final String address;
  final List<BoilerDisplay> boilers;

  const HomeDetailPage({
    super.key,
    required this.name,
    required this.description,
    required this.address,
    required this.boilers,
  });

  @override
  _HomeDetailPageState createState() => _HomeDetailPageState();

  }
class _HomeDetailPageState extends State<HomeDetailPage> {
  void _AddBoiler(String name, String type) {
    setState(() {
      widget.boilers.add(BoilerDisplay(name: name, description: type, type: type));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("${widget.name} Details"),
      ),
      body: Column(
        children: [
          Text("Home Details",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(widget.description),
          Text(widget.address),
          Text("Boilers",
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
        ],
      ),
      floatingActionButton: AddButton(onAdd: _AddBoiler,isHome: false,),
    );
  }
}
