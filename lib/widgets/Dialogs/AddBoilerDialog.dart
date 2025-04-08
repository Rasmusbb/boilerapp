import 'package:flutter/material.dart';

class AddBoilerDialog extends StatefulWidget {
  final void Function(String name, String type) onSave;

  const AddBoilerDialog({super.key, required this.onSave});

  @override
  State<AddBoilerDialog> createState() => _AddBoilerDialogState();
}

class _AddBoilerDialogState extends State<AddBoilerDialog> {
  final _nameController = TextEditingController();
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Boiler'),
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
              widget.onSave(name, type);
              Navigator.pop(context);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
