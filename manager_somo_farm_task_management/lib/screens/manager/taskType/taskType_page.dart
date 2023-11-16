import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/hamburger_show_menu.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words_with_ellipsis.dart';
import 'package:manager_somo_farm_task_management/models/livestock.dart';
import 'package:manager_somo_farm_task_management/screens/manager/habitantTpe_detail/habitantType_detail_popup.dart';
import 'package:manager_somo_farm_task_management/screens/manager/taskType_detail/taskType_detail_popup.dart';
import 'package:manager_somo_farm_task_management/screens/manager/tasktype_add/taskType_add_page.dart';
import 'package:manager_somo_farm_task_management/services/task_type_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

class TaskTypePage extends StatefulWidget {
  const TaskTypePage({Key? key}) : super(key: key);

  @override
  TaskTypePageState createState() => TaskTypePageState();
}

class TaskTypePageState extends State<TaskTypePage> {
  List<LiveStock> SearchTaskType = taskList;
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  void searchLiveStocks(String keyword) {
    setState(() {
      SearchTaskType = taskList
          .where((liveStock) => removeDiacritics(liveStock.name.toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
    });
  }

  List<Map<String, dynamic>> taskTypes = [];

  Future<void> GetAllTaskType() async {
    TaskTypeService().getListTaskType().then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.isNotEmpty) {
        setState(() {
          taskTypes = value;
        });
      } else {
        throw Exception();
      }
    });
  }

  Future<void> _initializeData() async {
    await GetAllTaskType();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        isLoading = false;
      });
    });
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.grey[200],
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Loại công việc',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            color: Colors.black,
            iconSize: 35,
            onPressed: () {
              HamburgerMenu.showReusableBottomSheet(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateTaskType()),
                            ).then((value) {
                              if (value != null) {
                                GetAllTaskType();
                                SnackbarShowNoti.showSnackbar(
                                    'Tạo thành công!', false);
                              }
                            });
                            ;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            minimumSize: Size(120, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Tạo loại công việc",
                              style: TextStyle(fontSize: 19),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 42,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (keyword) {
                          searchLiveStocks(keyword);
                        },
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm...",
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              flex: 2,
              child: RefreshIndicator(
                notificationPredicate: (_) => true,
                onRefresh: () => GetAllTaskType(),
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: taskTypes.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> taskType = taskTypes[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return TaskTypeDetailPopup(taskType: taskType);
                            },
                          );
                        },
                        onLongPress: () {
                          // _showBottomSheet(context, liveStock);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 8,
                                offset: Offset(2, 4), // Shadow position
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            height: 140,
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              taskType['name'],
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  taskType['isDelete'] == true
                                                      ? Colors.red[400]
                                                      : kPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              taskType['isDelete'] == false
                                                  ? "Active"
                                                  : "Inactive",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 7),
                                            height: 60,
                                            width: 4,
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "Loại công việc: ",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${taskType['status']}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.black87),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "Mô tả: ",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                    TextSpan(
                                                      text: taskType[
                                                                  'description'] ==
                                                              null
                                                          ? "chưa có"
                                                          : wrapWordsWithEllipsis(
                                                              '${taskType['description']}',
                                                              32),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Map<String, dynamic> liveStock) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height * 0.24,
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
                label: "Xóa",
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDeleteDialog(
                          title: "Xóa con vật",
                          content: "Bạn có chắc muốn xóa con vật này?",
                          onConfirm: () {
                            Navigator.of(context).pop();
                            setState(() {});
                            taskTypes.remove(liveStock);
                          },
                          buttonConfirmText: "Xóa",
                        );
                      });
                  SnackbarShowNoti.showSnackbar(
                      'Xóa thành công vật nuôi', false);
                },
                cls: Colors.red[300]!,
                context: context,
              ),
              const SizedBox(height: 20),
              _bottomSheetButton(
                label: "Đóng",
                onTap: () {
                  Navigator.of(context).pop();
                },
                cls: Colors.white,
                isClose: true,
                context: context,
              ),
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
