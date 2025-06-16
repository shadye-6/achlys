import 'package:achlys/colorThemes/colors.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorThemes[0]['colorLight'],
      body: Center(
        child: Text("Library"),
      ),
    );
  }
}