import 'dart:io';
import 'package:achlys/colorThemes/colors.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'pdf_navigation_helper.dart';

class PdfCard extends StatelessWidget {
  final FileSystemEntity file;
  final void Function(BuildContext context, FileSystemEntity file) onEdit;

  const PdfCard({super.key, required this.file, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final fileName = p.basename(file.path); // <-- Use path package here

    return Container(
      width: 100,
      margin: const EdgeInsets.fromLTRB(4, 3, 10, 3),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              openPdf(context, file);
            },
            child: Icon(Icons.picture_as_pdf, size: 40, color: colorThemes[0]['colorDark']),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {
              openPdf(context, file);
            },
            child: Text(
              fileName,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () => onEdit(context, file) ,
            icon: Icon(Icons.edit),
            iconSize: 15,
          )
        ],
      ),
    );
  }
}
