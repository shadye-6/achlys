import 'dart:io';
import 'package:achlys/colorThemes/colors.dart';
import 'package:achlys/widgets/pdfcardforhomepage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String username = "username";
  int timeRead = 0;
  String favBook = "favbook";
  List<String> favoritePdfPaths = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoritePdfPaths = prefs.getStringList('favorite_pdfs') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorThemes[0]['colorLight'],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: colorThemes[0]['colorDark'],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorThemes[0]['colorLight'] as Color,
                          width: 5,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/default.jpg',
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome back $username.",
                            style: TextStyle(
                                color: colorThemes[0]['colorLight'], fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            "Your favourite book is $favBook.",
                            style: TextStyle(
                                color: colorThemes[0]['colorLight'], fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Text(
                            "Your total time read is $timeRead hours.",
                            style: TextStyle(
                                color: colorThemes[0]['colorLight'], fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // open profile editor
                      },
                      icon: const Icon(Icons.more),
                      color: colorThemes[0]['colorLight'],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "Favourites",
                style: TextStyle(
                    color: colorThemes[0]['colorDark'],
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              color: colorThemes[0]['colorMed'],
              width: double.infinity,
              height: 150,
              child: favoritePdfPaths.isEmpty
                  ? Center(
                      child: Text(
                        "No favourites yet",
                        style: TextStyle(color: colorThemes[0]['colorDark']),
                      ),
                    )
                  : CarouselSlider(
                      options: CarouselOptions(
                        height: 150,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: true,
                        viewportFraction: 0.33,
                        autoPlay: favoritePdfPaths.length >= 3,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800)
                      ),
                      items: favoritePdfPaths.map((path) {
                        return HomePdfCard(file: File(path));
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "History",
                style: TextStyle(
                    color: colorThemes[0]['colorDark'],
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              color: colorThemes[0]['colorMed'],
              width: double.infinity,
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
