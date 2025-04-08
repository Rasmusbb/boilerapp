import 'package:flutter/material.dart';
import 'Dialogs/AddBoilerDialog.dart';
import 'Dialogs/AddHomeDialog.dart';

class AddButton extends StatelessWidget {
  final void Function(String name, String typeOrAddress) onAdd; // Single callback for both
  final bool isHome; // Flag to toggle between adding home and boiler

  const AddButton({
    super.key,
    required this.onAdd, // General callback
    this.isHome = false, // Default to adding a boiler
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (isHome) {
          // Show Add Home Dialog
          showDialog(
            context: context,
            builder: (context) => AddHomeDialog(
              onSave: (name, address) {
                onAdd(name, address); // Pass data back to onAdd
              },
            ),
          );
        } else {
          // Show Add Boiler Dialog
          showDialog(
            context: context,
            builder: (context) => AddBoilerDialog(
              onSave: (name, type) {
                onAdd(name, type); // Pass data back to onAdd
              },
            ),
          );
        }
      },
      child: Icon(Icons.add),
    );
  }
}
