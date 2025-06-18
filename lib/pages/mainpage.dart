import 'package:achlys/colorThemes/colors.dart';
import 'package:achlys/pages/analytics.dart';
import 'package:achlys/pages/library.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:achlys/pages/homepage.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int selectedIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  List<Widget> pages = [Homepage(), LibraryPage(), AnalyticsPage()];
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: pages
      ),
      bottomNavigationBar: SafeArea(
        child: CurvedNavigationBar(
          height: 60,
          maxWidth: double.infinity,
          key: _bottomNavigationKey,
          items: [
            Icon(Icons.home, color: colorThemes[0]['colorLight'],),
            Icon(Icons.library_books, color: colorThemes[0]['colorLight'],),
            Icon(Icons.analytics, color: colorThemes[0]['colorLight'],)
          ],
          color: colorThemes[0]['colorDark'] as Color,
          backgroundColor: colorThemes[0]['colorLight'] as Color,
          animationDuration: const Duration(milliseconds: 100),
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.jumpToPage(index);
          }
        ),
      ),
    );
  }
}

