import 'package:flutter/material.dart';

class AddHomeDialog extends StatefulWidget {
  final void Function(String name, String type) onSave;

  const AddHomeDialog({super.key, required this.onSave});

  @override
  State<AddHomeDialog> createState() => _AddHomeDialogState();
}

class _AddHomeDialogState extends State<AddHomeDialog> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Home'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Address'),
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
            final address = _addressController.text;
            widget.onSave(name, address);
            Navigator.pop(context);
            
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
