import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/task_update/task_update_page.dart';
import 'package:manager_somo_farm_task_management/services/evidence_service.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';

class ViewRejectionReasonPopup extends StatefulWidget {
  final Map<String, dynamic> task;
  final String role;

  ViewRejectionReasonPopup({required this.role, required this.task});

  @override
  State<ViewRejectionReasonPopup> createState() =>
      _ViewRejectionReasonPopupState();
}

class _ViewRejectionReasonPopupState extends State<ViewRejectionReasonPopup> {
  String rejectionReason = "";
  bool isLoading = true;
  Future<void> getEvdidence() async {
    EvidenceService().getEvidencebyTaskId(widget.task['id']).then((value) {
      setState(() {
        rejectionReason = value[0]['description'];
        isLoading = false;
      });
    });
  }

  Future<bool> cancelRejectTaskStatus(int taskId) async {
    setState(() {
      isLoading = true;
    });
    return TaskService().cancelRejectTaskStatus(taskId);
  }

  @override
  void initState() {
    super.initState();
    getEvdidence();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          )
        : AlertDialog(
            title: Text("Lý do từ chối"),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 150,
                    margin: const EdgeInsets.only(top: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      enabled: false,
                      maxLines: null,
                      autofocus: false,
                      style: subTitileStyle,
                      decoration: InputDecoration(
                        hintText: rejectionReason,
                        hintStyle: subTitileStyle,
                        border: InputBorder.none, // Ẩn border ở đây
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (widget.role == "Manager")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor, // Màu cho nút Hủy
                          ),
                          onPressed: () {
                            // Thực hiện hành động khi người dùng chấp nhận
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UpdateTaskPage(
                                  task: widget.task,
                                  role: widget.role,
                                ),
                              ),
                            );
                          },
                          child: Text("Giao lại"),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[300], // Màu cho nút Hủy
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context1) {
                                return ConfirmDeleteDialog(
                                  title: "Không chấp nhận từ chối",
                                  content:
                                      'Công việc sẽ chuyển sang trạng thái "Chuẩn bị"',
                                  onConfirm: () {
                                    cancelRejectTaskStatus(widget.task['id'])
                                        .then((value) {
                                      if (value) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Navigator.of(context).pop("ok");
                                        SnackbarShowNoti.showSnackbar(
                                            "Đổi thành công!", false);
                                      } else {
                                        SnackbarShowNoti.showSnackbar(
                                            "Xảy ra lỗi!", true);
                                      }
                                    });
                                  },
                                  buttonConfirmText: "Đồng ý",
                                );
                              },
                            );
                          },
                          child: Text("Không chấp nhận"),
                        ),
                      ],
                    ),
                  if (widget.role != "Manager")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[300], // Màu cho nút Hủy
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context1) {
                                return ConfirmDeleteDialog(
                                  title: "Hủy từ chối",
                                  content:
                                      'Công việc sẽ chuyển sang trạng thái "Chuẩn bị"',
                                  onConfirm: () {
                                    cancelRejectTaskStatus(widget.task['id'])
                                        .then((value) {
                                      if (value) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Navigator.of(context).pop("ok");
                                        SnackbarShowNoti.showSnackbar(
                                            "Hủy thành công!", false);
                                      } else {
                                        SnackbarShowNoti.showSnackbar(
                                            "Xảy ra lỗi!", true);
                                      }
                                    });
                                  },
                                  buttonConfirmText: "Đồng ý",
                                );
                              },
                            );
                          },
                          child: Text("Hủy từ chối"),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // Màu cho nút Hủy
                          ),
                          onPressed: () {
                            // Thực hiện hành động khi người dùng không chấp nhận
                            Navigator.of(context).pop();
                            // Add code xử lý khi không chấp nhận
                          },
                          child: Text(
                            "Đóng",
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
  }
}
