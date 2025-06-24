import 'package:achlys/colorThemes/colors.dart';
import 'package:achlys/pages/mainpage.dart';
import 'package:flutter/material.dart';

void main() { 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      color: colorThemes[0]['colorLight'],
      debugShowCheckedModeBanner: false,
      title: 'Achlys',
      home: MainScreen(),
    );
  }
}



