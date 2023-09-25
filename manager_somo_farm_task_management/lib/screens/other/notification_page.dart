import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/models/notification.dart';
import 'package:manager_somo_farm_task_management/widgets/bottom_navigation_bar.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool showUnreadOnly = false;
  List<Notifications> filteredNoti = notificationList;
  List<String> optionsNoti = ["Đánh dấu chưa đọc", "Xóa thông báo"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        automaticallyImplyLeading: false, // Ẩn nút quay lại
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Thông báo',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.settings),
                color: kPrimaryColor,
                onPressed: () {
                  _showBottomSheet(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showUnreadOnly = false;
                      filteredNoti = notificationList;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color:
                          showUnreadOnly ? Colors.transparent : kPrimaryColor,
                    ),
                    alignment: Alignment
                        .center, // Đặt alignment thành Alignment.center
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Tất cả",
                        style: TextStyle(
                          color:
                              showUnreadOnly ? kPrimaryColor : kTextWhiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showUnreadOnly = true;
                      filteredNoti = notificationList
                          .where((m) => m.isRead == false)
                          .toList();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:
                          !showUnreadOnly ? Colors.transparent : kPrimaryColor,
                    ),
                    alignment: Alignment
                        .center, // Đặt alignment thành Alignment.center
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Chưa đọc",
                        style: TextStyle(
                          color:
                              !showUnreadOnly ? kPrimaryColor : kTextWhiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
                child: filteredNoti.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off,
                              size:
                                  80, // Kích thước biểu tượng có thể điều chỉnh
                              color: Colors.grey, // Màu của biểu tượng
                            ),
                            SizedBox(
                                height:
                                    16), // Khoảng cách giữa biểu tượng và văn bản
                            Text(
                              "Bạn không có thông báo nào",
                              style: TextStyle(
                                fontSize:
                                    18, // Kích thước văn bản có thể điều chỉnh
                                color: Colors.grey, // Màu văn bản
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredNoti.length,
                        itemExtent: 90,
                        itemBuilder: (_, index) {
                          Notifications noti = filteredNoti[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            child: SlideAnimation(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (!noti.isRead) {
                                      noti.isRead = true;
                                    }
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        noti.isRead
                                            ? Icons.notifications
                                            : Icons.notifications_on_rounded,
                                        color: noti.isRead
                                            ? Colors.black54
                                            : Colors.black,
                                      ),
                                      title: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: noti.sender,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                                color: noti.isRead
                                                    ? Colors.black54
                                                    : Colors
                                                        .black, // Màu cho đoạn text đầu tiên
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  " ${noti.content.toLowerCase()}.",
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: noti.isRead
                                                    ? Colors.black54
                                                    : Colors
                                                        .black, // Màu cho đoạn text thứ hai
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      subtitle: Text(
                                        "2 tuan truoc",
                                        style: TextStyle(
                                          height: 2,
                                          color: noti.isRead
                                              ? Colors.grey
                                              : Colors.grey[700],
                                        ),
                                      ),
                                      trailing: PopupMenuButton<String>(
                                        icon: Icon(
                                          Icons.more_horiz,
                                          color: noti.isRead
                                              ? Colors.grey
                                              : Colors.grey[700],
                                        ),
                                        onSelected: (String selected) {},
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            PopupMenuItem<String>(
                                              value: 'delete',
                                              child: Text('Xóa thông báo'),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'markAsUnread',
                                              child: Text('Đánh dấu chưa đọc'),
                                            ),
                                          ];
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTabChanged: (index) {},
      ),
    );
  }

  _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height * 0.20,
          color: kBackgroundColor,
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kTextGreyColor,
                ),
              ),
              const Spacer(),
              _bottomSheetButton(
                label: "Đánh dấu đã đọc tất cả",
                onTap: () {
                  Navigator.of(context).pop();
                },
                cls: kPrimaryColor,
                context: context,
              ),
              const Spacer(),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color cls,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true ? Colors.grey[300]! : cls,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : cls,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titileStyle
                : titileStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
