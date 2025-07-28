import 'package:flutter/material.dart';

class AddMemberDialog extends StatefulWidget {
  final void Function(String email) onSave;

  const AddMemberDialog({super.key, required this.onSave});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Memeber'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'E-mail'),
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
            widget.onSave(name);
            Navigator.pop(context);
            
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
