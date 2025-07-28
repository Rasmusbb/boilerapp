import 'package:flutter/material.dart';
import 'Dialogs/FindDevice.dart';
import 'Dialogs/AddHomeDialog.dart';
import 'Dialogs/AddMemberDialog.dart';

class AddButton extends StatelessWidget {
  final void Function(String name, String typeOrAddress) onAdd; 
  final String homeId;
  String addType = ""; 
  AddButton({
    super.key,
    required this.homeId,
    required this.onAdd, 
    required this.addType,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "add $addType",
      onPressed: () {
        switch(addType){
          case "Home":
            // Show Add Home Dialog
            showDialog(
              context: context,
              builder: (context) => AddHomeDialog(
                onSave: (name, address) {
                  onAdd(name, address); 
                },
              ),
            );
          break;
        case "Boiler":
          // Show Add Boiler Dialog
          showDialog(
            context: context,
            builder: (context) => FindDeviceDialog( 
              homeId: homeId, // Pass homeId to FindDeviceDialog
              onSave: (name, type,id) {
                onAdd(name, type); // Pass data back to onAdd
              },
            ),
          );
          break;

        case "Member":
          // Show Add Member Dialog
          showDialog(
            context: context,
            builder: (context) => AddMemberDialog(
              onSave: (email) {
                onAdd(email, "Member"); // Pass data back to onAdd
              },
            ),
          );
          break;
        }
      },
      child: Icon(Icons.add),
    );
  }
}
