import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/models/farm.dart';
import 'package:manager_somo_farm_task_management/screens/manager/home/manager_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/other/settings_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const BottomNavBar(
      {super.key, required this.currentIndex, required this.onTabChanged});

  _onTabChanged(int index, BuildContext context) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ManagerHomePage(
                  farm: getFarm(),
                )),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        color: kTextWhiteColor,
      ),
      padding: const EdgeInsets.all(1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              size: _getCurrentTabSize(0),
              color: _getCurrentTabColor(0),
            ),
            onPressed: () => _onTabChanged(0, context),
          ),
          IconButton(
            icon: Icon(
              Icons.chat_sharp,
              size: _getCurrentTabSize(1),
              color: _getCurrentTabColor(1),
            ),
            onPressed: () => _onTabChanged(1, context),
          ),
          IconButton(
            icon: Icon(
              Icons.calendar_month_outlined,
              size: _getCurrentTabSize(2),
              color: _getCurrentTabColor(2),
            ),
            onPressed: () => _onTabChanged(2, context),
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              size: _getCurrentTabSize(3),
              color: _getCurrentTabColor(3),
            ),
            onPressed: () => _onTabChanged(3, context),
          ),
        ],
      ),
    );
  }

  double _getCurrentTabSize(int tabIndex) {
    return currentIndex == tabIndex ? 30.0 : 22.0;
  }

  Color _getCurrentTabColor(int tabIndex) {
    return currentIndex == tabIndex ? kPrimaryColor : kTextGreyColor;
  }

  Future<int?> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    int? farmId = prefs.getInt('farmId');
    return farmId;
  }

  Farm getFarm() {
    Farm farm = products.first;
    getFarmId().then((value) {
      if (value != null) {
        return products.where((f) => f.id == value);
      }
    });
    return farm;
  }
}
