import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

class BoilerGauge extends StatelessWidget {
  final double currentValue;
  final double minValue;
  final double maxValue;

  const BoilerGauge({
    super.key,
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    String rangeLabel = ''; // Variable to hold the range label

    // Determine the range label based on the current value
    if (currentValue <= maxValue * 0.3) {
      rangeLabel = 'Low';
    } else if (currentValue <= maxValue * 0.7) {
      rangeLabel = 'Medium';
    } else {
      rangeLabel = 'High';
    }

    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: minValue, // Minimum value passed as a parameter
          maximum: maxValue, // Maximum value passed as a parameter
          ranges: <GaugeRange>[
            // Red range for low values (0% to 30% of max value)
            GaugeRange(
              startValue: minValue,
              endValue: maxValue * 0.3,
              color: Colors.red, // Red color for low range
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.1, // Set the start width of the range
              endWidth: 0.1,   // Set the end width of the range
            ),
            // Yellow range for medium values (30% to 70% of max value)
            GaugeRange(
              startValue: maxValue * 0.3,
              endValue: maxValue * 0.7,
              color: Colors.yellow, // Yellow color for medium range
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.1, // Set the start width of the range
              endWidth: 0.1,   // Set the end width of the range
            ),
            // Green range for high values (70% to max value)
            GaugeRange(
              startValue: maxValue * 0.7,
              endValue: maxValue,
              color: Colors.green, // Green color for high range
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.1, // Set the start width of the range
              endWidth: 0.1,   // Set the end width of the range
            ),
          ],
          pointers: <GaugePointer>[
            NeedlePointer(value: currentValue), // Dynamically update the value
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                rangeLabel, // Display the corresponding range label
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: rangeLabel == 'High' ? Colors.green :
                         rangeLabel == 'Medium' ? Colors.yellow : Colors.red, // Set color based on the range
                ),
              ),
              positionFactor: 0.9, // Position the text near the outer edge of the gauge
              angle: 90, // Rotate the text so it aligns with the gauge
            ),
          ],
        ),
      ],
    );
  }
}
