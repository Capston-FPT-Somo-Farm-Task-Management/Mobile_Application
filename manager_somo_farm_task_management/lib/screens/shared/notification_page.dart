import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_details/task_details_page.dart';
import 'package:manager_somo_farm_task_management/services/notificantion_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with WidgetsBindingObserver {
  bool isLoading = true;
  bool showUnreadOnly = false;
  List<String> optionsNoti = ["Đánh dấu chưa đọc", "Xóa thông báo"];
  List<Map<String, dynamic>> filteredNoti = [];
  int? userId;
  bool isLoadingMore = false;
  int page = 1;
  final scrollController = ScrollController();
  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      if (showUnreadOnly) {
        await getNotSeenNoti(page, 10, false);
      } else {
        await getAllNoti(page, 10, false);
      }
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userIdStored = prefs.getInt('userId');
    setState(() {
      userId = userIdStored;
    });
  }

  Future<void> getNotSeenNoti(int index, int pageSize, bool isReset) async {
    await NotiService()
        .getNotSeenNotificationByMemberId(index, pageSize, userId!)
        .then((value) {
      if (isReset) {
        setState(() {
          filteredNoti = value;
          isLoading = false;
        });
      } else {
        setState(() {
          filteredNoti = filteredNoti + value;
          isLoading = false;
        });
      }
    });
  }

  Future<void> getAllNoti(int index, int pageSize, bool isReset) async {
    await NotiService()
        .getAllNotificationByMemberId(index, pageSize, userId!)
        .then((value) {
      if (isReset) {
        setState(() {
          filteredNoti = value;
          isLoading = false;
        });
      } else {
        setState(() {
          filteredNoti = filteredNoti + value;
          isLoading = false;
        });
      }
    });
  }

  void initData() {
    getUserId().then((_) {
      NotiService().getAllNotificationByMemberId(1, 10, userId!).then((value) {
        setState(() {
          filteredNoti = value;
          isLoading = false;
        });
      });
    });
    scrollController.addListener(() {
      _scrollListener();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Gọi hàm cập nhật số lượng thông báo khi ứng dụng được khôi phục
      showUnreadOnly ? getNotSeenNoti(1, 10, true) : getAllNoti(1, 10, true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initData();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      showUnreadOnly ? getNotSeenNoti(1, 10, true) : getAllNoti(1, 10, true);
    });
    WidgetsBinding.instance.addObserver(this);
  }

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
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showUnreadOnly = false;
                        isLoading = true;
                        page = 1;
                        getAllNoti(1, 10, true);
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
                            color: showUnreadOnly
                                ? kPrimaryColor
                                : kTextWhiteColor,
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
                        isLoading = true;
                        page = 1;
                        getNotSeenNoti(1, 10, true);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: !showUnreadOnly
                            ? Colors.transparent
                            : kPrimaryColor,
                      ),
                      alignment: Alignment
                          .center, // Đặt alignment thành Alignment.center
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          "Chưa đọc",
                          style: TextStyle(
                            color: !showUnreadOnly
                                ? kPrimaryColor
                                : kTextWhiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    )
                  : filteredNoti.isEmpty
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
                      : RefreshIndicator(
                          onRefresh: () async {
                            if (showUnreadOnly) {
                              getNotSeenNoti(1, 10, true);
                            } else {
                              getAllNoti(1, 10, true);
                            }
                            // Add a return statement or throw an error here if needed.
                          },
                          child: ListView.builder(
                              itemCount: isLoadingMore
                                  ? filteredNoti.length + 1
                                  : filteredNoti.length,
                              controller: scrollController,
                              itemExtent: 90,
                              itemBuilder: (_, index) {
                                if (index < filteredNoti.length) {
                                  Map<String, dynamic> noti =
                                      filteredNoti[index];
                                  bool isRead = noti['isRead'] ?? false;
                                  String message = noti['message'];
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    child: SlideAnimation(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskDetailsPage(
                                                      taskId: noti['taskId']),
                                            ),
                                          );
                                          NotiService()
                                              .isReadNoti(noti['id'])
                                              .then((value) {
                                            showUnreadOnly
                                                ? getNotSeenNoti(1, 10, true)
                                                : getAllNoti(1, 10, true);
                                          }).catchError((e) {
                                            SnackbarShowNoti.showSnackbar(
                                                e.toString(), true);
                                          });
                                        },
                                        child: Container(
                                          color: isRead
                                              ? Colors.white
                                              : Color.fromARGB(
                                                  255, 209, 222, 233),
                                          child: Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.notifications,
                                                    color: Colors.black,
                                                  ),
                                                  title: message.contains("'")
                                                      ? RichText(
                                                          text: TextSpan(
                                                            style: DefaultTextStyle
                                                                    .of(context)
                                                                .style
                                                                .copyWith(
                                                                    fontSize:
                                                                        16),
                                                            children: [
                                                              TextSpan(
                                                                text: message
                                                                    .substring(
                                                                        0,
                                                                        message.indexOf("'") +
                                                                            1),
                                                              ),
                                                              TextSpan(
                                                                text: message
                                                                    .substring(
                                                                  message.indexOf(
                                                                          "'") +
                                                                      1,
                                                                  message
                                                                      .lastIndexOf(
                                                                          "'"),
                                                                ),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              TextSpan(
                                                                text: message
                                                                    .substring(message
                                                                        .lastIndexOf(
                                                                            "'")),
                                                                // Không cần style ở đây vì đã được thiết lập ở style chung
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Text(noti['message']),
                                                  subtitle: Text(
                                                    noti['time'],
                                                    style: TextStyle(
                                                      height: 2,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  trailing:
                                                      PopupMenuButton<String>(
                                                    icon: Icon(
                                                      Icons.more_horiz,
                                                      color: Colors.grey[700],
                                                    ),
                                                    onSelected:
                                                        (String selected) {},
                                                    itemBuilder:
                                                        (BuildContext context) {
                                                      return [
                                                        PopupMenuItem<String>(
                                                          value: 'delete',
                                                          child: Text(
                                                              'Xóa thông báo'),
                                                        ),
                                                        PopupMenuItem<String>(
                                                          value: 'markAsUnread',
                                                          child: Text(
                                                              'Đánh dấu chưa đọc'),
                                                        ),
                                                      ];
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                        color: kPrimaryColor),
                                  );
                                }
                              }),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height * 0.18,
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
                  setState(() {
                    isLoading = true;
                  });
                  NotiService().makeAllNotiIsRead(userId!).then((value) {
                    if (value) {
                      showUnreadOnly
                          ? getNotSeenNoti(1, 10, true)
                          : getAllNoti(1, 10, true);
                    }
                    setState(() {
                      isLoading = false;
                    });
                  });
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
