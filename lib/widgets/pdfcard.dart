import 'dart:io';
import 'package:achlys/colorThemes/colors.dart';
import 'package:flutter/material.dart';

class PdfCard extends StatelessWidget {
  final FileSystemEntity file;
  final VoidCallback onEdit;

  const PdfCard({super.key, required this.file, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final fileName = file.path.split('/').last;

    return Container(
      width: 100,
      margin: const EdgeInsets.fromLTRB(4, 3, 10, 3),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.picture_as_pdf, size: 40, color: colorThemes[0]['colorDark'],),
          const SizedBox(height: 6),
          Text(
            fileName,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.edit),iconSize: 15,)
        ],
      ),
    );


  }
}
