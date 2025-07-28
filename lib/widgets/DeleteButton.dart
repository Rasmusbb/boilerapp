import 'package:flutter/material.dart';



class DeleteButton extends StatelessWidget {
  final VoidCallback onDelete;
  final String tag;
  
  const DeleteButton({
    super.key,
    required this.tag,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: FloatingActionButton(
        heroTag: tag, // Important for unique hero tag
        backgroundColor: Colors.red,
        onPressed: onDelete,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
    );
  }
}