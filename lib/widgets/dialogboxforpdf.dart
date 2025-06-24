import 'dart:io';

import 'package:flutter/material.dart';

void showPdfEditDialog({
  required BuildContext context,
  required FileSystemEntity file,
  required VoidCallback onRename,
  required VoidCallback onDelete,
}) {
  final TextEditingController controller = TextEditingController(
    text: file.path.split('/').last.replaceAll('.pdf', ''),
  );

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Edit PDF"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: "Rename"),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final newName = controller.text.trim();
            if (newName.isNotEmpty) {
              final directory = file.parent.path;
              final newPath = '$directory/$newName.pdf';
              await File(file.path).rename(newPath);
              onRename();
              Navigator.pop(ctx);
            }
          },
          child: const Text("Rename"),
        ),
        TextButton(
          onPressed: () async {
            await File(file.path).delete();
            onDelete();
            Navigator.pop(ctx);
          },
          child: const Text("Delete"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text("Cancel"),
        ),
      ],
    ),
  );
}
