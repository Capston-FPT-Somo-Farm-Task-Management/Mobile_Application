import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RejectionReasonPopup extends StatefulWidget {
  final int taskId;
  final bool? isRedo;
  const RejectionReasonPopup({super.key, required this.taskId, this.isRedo});
  @override
  _RejectionPopupState createState() => _RejectionPopupState();
}

class _RejectionPopupState extends State<RejectionReasonPopup> {
  final TextEditingController _desController = TextEditingController();
  bool isValidate = false;
  bool isLoading = false;
  int? userId;
  String? role;
  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu định dạng cho ngôn ngữ Việt Nam

    getUserId();
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userIdStored = prefs.getInt('userId');
    setState(() {
      userId = userIdStored;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          )
        : AlertDialog(
            title: Text(widget.isRedo != null
                ? "Nguyên nhân chưa đáp ứng"
                : "Nguyên nhân từ chối"),
            content: Container(
              width: MediaQuery.of(context).size.width *
                  0.8, // Đặt chiều rộng mong muốn ở đây
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _desController,
                      maxLines: null,
                      decoration:
                          InputDecoration(labelText: "Nhập nguyên nhân"),
                      onChanged: (value) {
                        if (value.isNotEmpty)
                          setState(() {
                            isValidate = true;
                          });
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isValidate
                                ? kPrimaryColor
                                : kTextGreyColor, // Màu cho nút Hủy
                          ),
                          onPressed: isValidate
                              ? () {
                                  widget.isRedo != null
                                      ? {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context1) {
                                              return ConfirmDeleteDialog(
                                                title:
                                                    "Thực hiện lại công việc",
                                                content:
                                                    'Công việc sẽ được chuyển sang "Đang thực hiện" ?',
                                                onConfirm: () {
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  TaskService()
                                                      .changeStatusFromDoneToDoing(
                                                          widget.taskId,
                                                          userId!,
                                                          _desController.text)
                                                      .then((value) {
                                                    if (value) {
                                                      Navigator.of(context)
                                                          .pop("Change");
                                                      SnackbarShowNoti
                                                          .showSnackbar(
                                                              "Đổi thành công!",
                                                              false);
                                                    } else {
                                                      SnackbarShowNoti
                                                          .showSnackbar(
                                                              "Xảy ra lỗi!",
                                                              true);
                                                    }
                                                  }).catchError((e) {
                                                    SnackbarShowNoti
                                                        .showSnackbar(
                                                            e.toString(), true);
                                                  });
                                                },
                                                buttonConfirmText: "Đồng ý",
                                              );
                                            },
                                          )
                                        }
                                      : {
                                          setState(() {
                                            isLoading = true;
                                          }),
                                          TaskService()
                                              .rejectTaskStatus(widget.taskId,
                                                  _desController.text)
                                              .then((value) {
                                            if (value) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              SnackbarShowNoti.showSnackbar(
                                                  "Đã từ chối!", false);
                                              Navigator.of(context)
                                                  .pop("Change");
                                            }
                                          }).catchError((e) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            SnackbarShowNoti.showSnackbar(
                                                e.toString(), true);
                                          })
                                        };
                                }
                              : null,
                          child: Text("Xác nhận"),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[300], // Màu cho nút Hủy
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Hủy"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
