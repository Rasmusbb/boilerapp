import 'package:flutter/material.dart';
import '../../logic/API.dart' as api;


class AddBoilerDialog extends StatefulWidget {
  final void Function(String name, String type) onSave;
  final String? deviceId;
  final String? homeId;

  const AddBoilerDialog({super.key, required this.onSave,required this.deviceId, required this.homeId});

  @override
  State<AddBoilerDialog> createState() => _AddBoilerDialogState();
}

class _AddBoilerDialogState extends State<AddBoilerDialog> {
  final _nameController = TextEditingController();
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Boiler Setup'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Type'),
            items: ['Electric', 'Gas', 'Oil','pellet','Wood'].map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) => _selectedType = value,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text;
            final type = _selectedType;

            if (name.isNotEmpty && type != null) {
              api.post("Homes/AddBoiler", {
                "boilerName": _nameController.text,
                "boilerType": _selectedType,
                "deviceId": widget.deviceId,
                "homeID": widget.homeId,
              });
              Navigator.pop(context);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
