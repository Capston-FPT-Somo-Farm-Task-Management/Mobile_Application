import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/screens/shared/home/manager_home_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/notification_page.dart';
import '../screens/shared/settings_page.dart';

class BottomNavBar extends StatefulWidget {
  final int farmId;

  const BottomNavBar({super.key, required this.farmId});
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int myCurrentIndex = 0;
  int notificationCount = 0;
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      // Xử lý thông báo khi có
      setState(() {
        // Tăng số lượng thông báo
        notificationCount++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      ManagerHomePage(
        farmId: widget.farmId,
      ),
      NotificationPage(),
      NotificationPage(),
      SettingsPage(),
    ];
    return Scaffold(
      bottomNavigationBar: Container(
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
                onPressed: () {
                  setState(() {
                    myCurrentIndex = 0;
                  });
                }),
            IconButton(
                icon: Icon(
                  Icons.chat_sharp,
                  size: _getCurrentTabSize(1),
                  color: _getCurrentTabColor(1),
                ),
                onPressed: () {
                  setState(() {
                    myCurrentIndex = 1;
                  });
                }),
            IconButton(
                icon: Stack(children: [
                  Icon(
                    Icons.notifications_rounded,
                    size: _getCurrentTabSize(2),
                    color: _getCurrentTabColor(2),
                  ),
                  notificationCount > 0
                      ? Positioned(
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Text(
                              '$notificationCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : SizedBox(),
                ]),
                onPressed: () {
                  setState(() {
                    myCurrentIndex = 2;
                  });
                }),
            IconButton(
                icon: Icon(
                  Icons.settings,
                  size: _getCurrentTabSize(3),
                  color: _getCurrentTabColor(3),
                ),
                onPressed: () {
                  setState(() {
                    myCurrentIndex = 3;
                  });
                }),
          ],
        ),
      ),
      body: pages[myCurrentIndex],
    );
  }

  double _getCurrentTabSize(int tabIndex) {
    return myCurrentIndex == tabIndex ? 30.0 : 22.0;
  }

  Color _getCurrentTabColor(int tabIndex) {
    return myCurrentIndex == tabIndex ? kPrimaryColor : kTextGreyColor;
  }
}
