import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/screens/shared/dashboard/dashboard_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/notification_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task/task_page.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_add/choose_habitant.dart';
import 'package:manager_somo_farm_task_management/services/notificantion_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/shared/settings_page.dart';

class BottomNavBar extends StatefulWidget {
  final int farmId;
  final int index;
  final dynamic page;
  const BottomNavBar(
      {super.key, required this.farmId, required this.index, this.page});
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with WidgetsBindingObserver {
  int myCurrentIndex = 0;
  int notificationCount = 0;
  int? userId;
  dynamic p;
  void getNewNotiCount() {
    NotiService().getCountNewNotificationByMemberId(userId!).then((value) {
      setState(() {
        notificationCount = value;
      });
    });
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userIdStored = prefs.getInt('userId');
    setState(() {
      userId = userIdStored;
    });
  }

  @override
  void initState() {
    super.initState();
    p = widget.page;
    WidgetsBinding.instance.addObserver(this);
    getUserId().then((_) {
      getNewNotiCount();
    });
    myCurrentIndex = widget.index;
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      // Xử lý thông báo khi có
      getNewNotiCount();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Gọi hàm cập nhật số lượng thông báo khi ứng dụng được khôi phục
      getNewNotiCount();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ]),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 5,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        p = StatisticsPage();
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.calendar_month,
                      size: _getCurrentTabSize(1),
                      color: _getCurrentTabColor(1),
                    ),
                    onPressed: () {
                      setState(() {
                        myCurrentIndex = 1;
                        //p = ManagerHomePage(
                        //  farmId: widget.farmId,
                        //);
                      });
                    }),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      border: Border.all(width: 1, color: kTextGreyColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ChooseHabitantPage(farmId: widget.farmId),
                      ),
                    );
                  },
                ),
                IconButton(
                    icon: Stack(
                      children: [
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
                      ],
                    ),
                    onPressed: () {
                      NotiService().makeAllNotiIsOld(userId!).then((value) {
                        if (value) {
                          getNewNotiCount();
                        }
                      }).catchError((e) {});
                      setState(() {
                        myCurrentIndex = 2;
                        //p = NotificationPage();
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
                        //p = SettingsPage();
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: myCurrentIndex,
        children: [
          p,
          //ManagerHomePage(farmId: widget.farmId),
          TaskPage(),
          //IntroducingFarmPage(farmId: widget.farmId),
          NotificationPage(),
          SettingsPage(),
        ],
      ),
    );
  }

  double _getCurrentTabSize(int tabIndex) {
    return myCurrentIndex == tabIndex ? 27.0 : 22.0;
  }

  Color _getCurrentTabColor(int tabIndex) {
    return myCurrentIndex == tabIndex ? kPrimaryColor : kTextGreyColor;
  }
}
