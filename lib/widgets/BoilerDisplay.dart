import 'package:flutter/material.dart';
import 'BoilerGauge.dart';
import 'AddButton.dart';

class BoilerDisplay extends StatelessWidget {
  final String name;
  final String description;

  const BoilerDisplay({
    super.key,
    required this.name,
    required this.description,
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
            SizedBox(height: 16),
            Center(
              child: BoilerGauge(
                currentValue: currentFuelLevel, // Dynamic value for current fuel level
                minValue: 0.0, // Minimum value for the gauge
                maxValue: 100.0, // Maximum value for the gauge
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AddButton(onPressed: incrementFuelLevel), // Use incrementFuelLevel function
    );
  }
}
