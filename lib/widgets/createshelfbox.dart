import 'package:flutter/material.dart';

void showCreateShelfDialog(
  BuildContext context, {
  required Function(String) onShelfCreated,
}) {
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Create Shelf"),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintText: "Enter a unique shelf name",
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            final input = controller.text.trim();
            if (input.isNotEmpty) {
              onShelfCreated(input);
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.done),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.cancel),
        ),
      ],
    ),
  );
}
