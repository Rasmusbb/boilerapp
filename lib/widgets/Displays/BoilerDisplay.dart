import 'package:flutter/material.dart';
import '../BoilerGauge.dart';
import '../../logic/API.dart' as api;

class BoilerDisplay extends StatelessWidget {
  final String boilerID;
  final String name;
  final String description;
  final String type; 

  const BoilerDisplay({
    super.key,
    required this.boilerID,
    required this.name,
    required this.description,
    required this.type, 
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to a detailed screen when clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BoilerDetailPage(
              name: name,
              description: description,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.red,
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

class BoilerDetailPage extends StatefulWidget {
  final String name;
  final String description;


  const BoilerDetailPage({
    super.key,
    required this.name,
    required this.description,
  });

  @override
  _BoilerDetailPageState createState() => _BoilerDetailPageState();
}

class _BoilerDetailPageState extends State<BoilerDetailPage> {
  double currentFuelLevel = 0; // Start with an initial fuel level


  void initState() {
    super.initState();
    getBoilerData();
    // Simulate fetching the initial fuel level from an API
    
  }

  void getBoilerData() {
    print(widget.key);
    // Simulate fetching the initial fuel level from an API
    
  }

  // Function to increment the fuel level by 10
  void incrementFuelLevel() {
    setState(() {
      currentFuelLevel += 10;
      if (currentFuelLevel > 100) {
        currentFuelLevel = 100; // Limit fuel level to max 100
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = false; 
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            Text(widget.description, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              isOnline
                  ? 'Online'
                  : 'Offline',
              style: TextStyle(
                color: isOnline ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 16),
            Center(
              child: BoilerGauge(
                currentValue: currentFuelLevel, 
                minValue: 0.0, 
                maxValue: 200.0, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
