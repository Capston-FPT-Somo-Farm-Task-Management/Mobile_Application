import 'package:flutter/material.dart';

import '../../widgets/bottom_navigation_bar.dart';

class ManagerHomePage extends StatefulWidget {
  const ManagerHomePage({Key? key}) : super(key: key);

  @override
  ManagerHomePageState createState() => ManagerHomePageState();
}

class ManagerHomePageState extends State<ManagerHomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTabChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
