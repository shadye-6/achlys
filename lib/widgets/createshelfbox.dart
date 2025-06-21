import 'package:flutter/material.dart';

void showShelfOptionsDialog(
  BuildContext context, {
  required String currentShelfName,
  required Function(String newName) onRename,
  required Function() onDelete,
}) {
  final TextEditingController controller = TextEditingController(text: currentShelfName);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Shelf Options"),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: "New Shelf Name",
          hintText: "Enter a unique name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            final newName = controller.text.trim();
            if (newName.isNotEmpty && newName != currentShelfName) {
              onRename(newName);
              Navigator.pop(context);
            }
          },
          child: const Text("Rename"),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          child: const Text("Delete"),
        ),
      ],
    ),
  );
}
