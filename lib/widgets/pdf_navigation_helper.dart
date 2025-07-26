import 'dart:io';
import 'package:flutter/material.dart';
import 'package:achlys/pages/pdfviewer.dart';

void openPdf(BuildContext context, FileSystemEntity file) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
        file: File(file.path),
      ),
    ),
  );
}