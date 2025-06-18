import 'package:flutter/material.dart';

void showCreateShelfDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Create Shelf"),
      content: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          hintText: "Enter a non-existing name"
        ),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.done)),
        IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.cancel))
      ],
    ),
  );
}
