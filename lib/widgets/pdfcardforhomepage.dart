import 'dart:io';
import 'package:achlys/colorThemes/colors.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'pdf_navigation_helper.dart';

class HomePdfCard extends StatelessWidget {
  final FileSystemEntity file;

  const HomePdfCard({super.key, required this.file});

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
              style: TextStyle(fontSize: 12, color: colorThemes[0]['colorDark']),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
