import 'package:flutter/material.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/bottom_navigation_bar.dart';

class LiveStockPage extends StatefulWidget {
  const LiveStockPage({Key? key}) : super(key: key);

  @override
  LiveStockPageState createState() => LiveStockPageState();
}

class LiveStockPageState extends State<LiveStockPage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: CustomAppBar(),
      ),
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
