import 'package:achlys/colorThemes/colors.dart';
import 'package:achlys/pages/analytics.dart';
import 'package:achlys/pages/library.dart';
import 'package:flutter/material.dart';
import 'package:achlys/pages/homepage.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int selectedIndex = 0;
  List<Widget> pages = [Homepage(), LibraryPage(), AnalyticsPage()];
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: pageController,
        children: pages,
      ),

      bottomNavigationBar: StylishBottomBar(
        backgroundColor: colorThemes[0]['colorDark'],
        option: AnimatedBarOptions(
          iconStyle: IconStyle.animated,
          barAnimation: BarAnimation.blink,
        ),
        items: [
          BottomBarItem(icon: Icon(Icons.home), title: const Text("Home"), backgroundColor: colorThemes[0]['colorLight']),
          BottomBarItem(icon: Icon(Icons.library_books), title: const Text("Library"), backgroundColor: colorThemes[0]['colorLight']),
          BottomBarItem(icon: Icon(Icons.analytics), title: const Text("Analytics"), backgroundColor: colorThemes[0]['colorLight']),
        ],
        fabLocation: StylishBarFabLocation.end,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
          pageController.jumpToPage(index);
        },
        ),
    );
  }
}
