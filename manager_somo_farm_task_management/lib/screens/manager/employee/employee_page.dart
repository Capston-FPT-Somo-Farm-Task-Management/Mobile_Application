import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/hamburger_show_menu.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/employee_add/employee_add_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/employee_detail/employee_details_popup.dart';
import 'package:manager_somo_farm_task_management/screens/supervisor/total_time_effort/total_time_effort_page.dart';
import 'package:manager_somo_farm_task_management/services/employee_service.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeekPage extends StatefulWidget {
  final bool viewTime;
  final String role;
  const EmployeekPage({super.key, required this.viewTime, required this.role});

  @override
  EmployeekPageState createState() => EmployeekPageState();
}

class EmployeekPageState extends State<EmployeekPage> {
  int? farmId;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> employees = [];
  List<Map<String, dynamic>> filteredEmployeeList = [];
  final List<String> filters = [
    "Tất cả",
    "Active",
    "Inactive",
  ];
  String? selectedFilter;
  bool isLoading = true;
  @override
  initState() {
    super.initState();
    selectedFilter = filters[0];
    _initializeData();
  }

  Future<void> _initializeData() async {
    await getFarmId();
    await getEmployees();
  }

  Future<void> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');
    setState(() {
      farmId = storedFarmId;
    });
  }

  void searchEmployees(String keyword) {
    setState(() {
      filteredEmployeeList = employees
          .where((task) => removeDiacritics(task['name'].toLowerCase())
              .contains(removeDiacritics(keyword.toLowerCase())))
          .toList();
    });
  }

  Future<void> getEmployees() async {
    EmployeeService().getEmployeesbyFarmId(farmId!).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.isNotEmpty) {
        setState(() {
          employees = value;
          filteredEmployeeList = employees;
        });
      } else {
        throw Exception();
      }
    });
  }

  Future<bool> changeStatusEmployee(int id) async {
    return EmployeeService().changeStatusEmployee(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.grey[200],
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Nhân viên',
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
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  if (!widget.viewTime)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateEmployee(
                                          farmId: farmId!,
                                        )),
                              ).then((value) {
                                if (value != null) {
                                  getEmployees();
                                  SnackbarShowNoti.showSnackbar(
                                      'Tạo nhân viên thành công', false);
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              minimumSize: Size(100, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Thêm nhân viên",
                                style: TextStyle(fontSize: 19),
                              ),
                            ),
                          ),
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
                          searchEmployees(keyword);
                        },
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm...",
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey, // Màu đường viền
                            width: 1.0, // Độ rộng của đường viền
                          ),
                          borderRadius: BorderRadius.circular(
                              5.0), // Độ bo góc của đường viền
                        ),
                        child: DropdownButton<String>(
                          isDense: true,
                          alignment: Alignment.center,
                          hint: Text(selectedFilter!),
                          value:
                              selectedFilter, // Giá trị đã chọn cho Dropdown 1
                          onChanged: (newValue) {
                            setState(() {
                              selectedFilter =
                                  newValue; // Cập nhật giá trị đã chọn cho Dropdown 1
                              if (selectedFilter == "Tất cả") {
                                filteredEmployeeList = employees;
                              }
                              if (selectedFilter == "Active") {
                                filteredEmployeeList = employees
                                    .where((t) => t['status'] == "Active")
                                    .toList();
                              }
                              if (selectedFilter == "Inactive") {
                                filteredEmployeeList = employees
                                    .where((t) => t['status'] == "Inactive")
                                    .toList();
                              }
                            });
                          },
                          items: filters
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              flex: 3,
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    )
                  : filteredEmployeeList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.no_accounts_outlined,
                                size:
                                    75, // Kích thước biểu tượng có thể điều chỉnh
                                color: Colors.grey, // Màu của biểu tượng
                              ),
                              SizedBox(
                                  height:
                                      16), // Khoảng cách giữa biểu tượng và văn bản
                              Text(
                                "Không có nhân viên nào",
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
                          onRefresh: () => getEmployees(),
                          child: ListView.separated(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: filteredEmployeeList.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 20);
                            },
                            itemBuilder: (context, index) {
                              final employee = filteredEmployeeList[index];

                              return GestureDetector(
                                onTap: () {
                                  !widget.viewTime
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return EmployeeDetailsPopup(
                                              employee: employee,
                                              farmId: farmId!,
                                            );
                                          },
                                        ).then((value) => {
                                            if (value != null) {getEmployees()}
                                          })
                                      : Navigator.of(context)
                                          .push(MaterialPageRoute(
                                          builder: (context) =>
                                              TotalTimeEffortPage(
                                                  employeeId: employee['id']),
                                        ));
                                },
                                onLongPress: () {
                                  widget.role == "Manager" && !widget.viewTime
                                      ? _showBottomSheet(context, employee)
                                      : null;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 10,
                                        offset: Offset(1, 4), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10))),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            employee['avatar'] != null
                                                ? Container(
                                                    height: 70,
                                                    width: 70,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100.0),
                                                      child: Image.network(
                                                        employee['avatar'],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 70,
                                                    width: 70,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.person,
                                                          size: 60,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            SizedBox(width: 10),
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
                                                          "${employee['name']}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: employee[
                                                                      'status'] ==
                                                                  "Inactive"
                                                              ? Colors.red[400]
                                                              : kPrimaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Text(
                                                          employee['status'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Icon(
                                                        Icons.tag,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        "Mã nhân viên: ${employee['code']}",
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .phone_android_outlined,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        "Điện thoại: ${employee['phoneNumber']}",
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.green[100],
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        height: 45,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'Địa chỉ: ${employee['address']}',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
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

  _showBottomSheet(BuildContext context, Map<String, dynamic> employee) {
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
                label: "Đổi trạng thái của nhân viên",
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context1) {
                        return ConfirmDeleteDialog(
                          title: "Đổi trạng thái",
                          content: "Bạn có chắc muốn đổi trạng thái nhân viên?",
                          onConfirm: () {
                            changeStatusEmployee(employee['id']).then((value) {
                              if (value) {
                                getEmployees();
                                Navigator.of(context).pop();
                                SnackbarShowNoti.showSnackbar(
                                    'Đổi trạng thái thành công!', false);
                              } else {
                                SnackbarShowNoti.showSnackbar(
                                    'Đổi trạng thái không thành công!', true);
                              }
                            });
                          },
                          buttonConfirmText: "Có",
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
