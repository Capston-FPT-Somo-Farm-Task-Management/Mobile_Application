import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/hamburger_show_menu.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/componets/title_text_bold.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words_with_ellipsis.dart';
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
  bool isLoading = true;
  List<Map<String, dynamic>> taskTypes = [];
  List<Map<String, dynamic>> filteredTaskTypeList = [];
  final TextEditingController searchController = TextEditingController();

  void searchTaskType(String keyword) {
    setState(() {
      filteredTaskTypeList = taskTypes
          .where((a) => removeDiacritics(a['name'].toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
    });
  }

  Future<void> GetAllTaskType() async {
    TaskTypeService().getListTaskType().then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.isNotEmpty) {
        setState(() {
          taskTypes = value;
          filteredTaskTypeList = taskTypes;
          isLoading = false;
        });
      } else {
        throw Exception();
      }
    });
  }

  Future<bool> deleteTaskType(int id) {
    return TaskTypeService().DeleteTaskType(id);
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
                          searchTaskType(keyword);
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
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    )
                  : filteredTaskTypeList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.not_interested,
                                size:
                                    75, // Kích thước biểu tượng có thể điều chỉnh
                                color: Colors.grey, // Màu của biểu tượng
                              ),
                              SizedBox(
                                  height:
                                      16), // Khoảng cách giữa biểu tượng và văn bản
                              Text(
                                "Không có loại công việc",
                                style: TextStyle(
                                  fontSize:
                                      20, // Kích thước văn bản có thể điều chỉnh
                                  color: Colors.grey, // Màu văn bản
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          notificationPredicate: (_) => true,
                          onRefresh: () => GetAllTaskType(),
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: filteredTaskTypeList.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> taskType =
                                  filteredTaskTypeList[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return TaskTypeDetailPopup(
                                            taskType: taskType);
                                      },
                                    ).then(
                                      (value) => {
                                        if (value != null) {GetAllTaskType()}
                                      },
                                    );
                                  },
                                  onLongPress: () {
                                    _showBottomSheet(context, taskType);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 8,
                                          offset:
                                              Offset(2, 4), // Shadow position
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: 140,
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        taskType['name'],
                                                        style: const TextStyle(
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 7),
                                                      height: 60,
                                                      width: 4,
                                                      decoration: BoxDecoration(
                                                        color: kPrimaryColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(20),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            if (taskType[
                                                                    'status'] ==
                                                                "Công việc chăn nuôi")
                                                              const Icon(
                                                                FontAwesomeIcons
                                                                    .paw,
                                                                color:
                                                                    kSecondColor,
                                                                size: 17,
                                                              ),
                                                            if (taskType[
                                                                    'status'] ==
                                                                "Công việc cây trồng")
                                                              const Icon(
                                                                FontAwesomeIcons
                                                                    .tree,
                                                                color:
                                                                    kSecondColor,
                                                                size: 17,
                                                              ),
                                                            if (taskType[
                                                                    'status'] ==
                                                                "Công việc khác")
                                                              const Icon(
                                                                FontAwesomeIcons
                                                                    .hashtag,
                                                                color:
                                                                    kSecondColor,
                                                                size: 17,
                                                              ),
                                                            SizedBox(width: 8),
                                                            TitleText.titleText(
                                                                "Loại công việc",
                                                                "${taskType['status']}",
                                                                17)
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.description,
                                                              color:
                                                                  kSecondColor,
                                                              size: 20,
                                                            ),
                                                            SizedBox(width: 8),
                                                            TitleText.titleText(
                                                                "Mô tả",
                                                                wrapWordsWithEllipsis(
                                                                    "${taskType['description']}",
                                                                    27),
                                                                17),
                                                          ],
                                                        )
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

  _showBottomSheet(BuildContext context, Map<String, dynamic> taskType) {
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
                label: "Xóa loại công việc",
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDeleteDialog(
                          title: "Xóa loại công việc",
                          content: "Bạn có chắc muốn xóa loại công việc này?",
                          onConfirm: () {
                            deleteTaskType(taskType['id']).then((value) {
                              if (value) {
                                GetAllTaskType();
                                SnackbarShowNoti.showSnackbar(
                                    'Xóa thành công!', false);
                              } else {
                                SnackbarShowNoti.showSnackbar(
                                    'Không thể xóa loại công việc đang được sử dụng',
                                    true);
                              }
                            });
                            Navigator.of(context).pop();
                          },
                          buttonConfirmText: "Xóa",
                        );
                      });
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
