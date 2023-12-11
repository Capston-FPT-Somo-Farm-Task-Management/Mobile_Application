import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_field.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RejectionReasonPopup extends StatefulWidget {
  final int taskId;
  final bool? isRedo;
  final String? endDate;
  const RejectionReasonPopup(
      {super.key, required this.taskId, this.isRedo, this.endDate});
  @override
  _RejectionPopupState createState() => _RejectionPopupState();
}

class _RejectionPopupState extends State<RejectionReasonPopup> {
  final TextEditingController _desController = TextEditingController();
  bool isValidate = false;
  bool isLoading = false;
  int? userId;
  String? role;
  DateTime? _selectedEndDate;
  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu định dạng cho ngôn ngữ Việt Nam

    getUserId();
    if (widget.endDate != null)
      _selectedEndDate = DateTime.parse(widget.endDate!);
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
            content: IntrinsicHeight(
              child: Column(
                children: [
                  Container(
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
                              if (value.isEmpty)
                                setState(() {
                                  isValidate = false;
                                });
                            },
                          ),
                          if (widget.isRedo != null)
                            MyInputField(
                              title: "Ngày giờ kết thúc",
                              hint: _selectedEndDate == null
                                  ? "dd/MM/yyyy HH:mm a"
                                  : DateFormat('dd/MM/yyyy HH:mm a')
                                      .format(_selectedEndDate!),
                              widget: IconButton(
                                icon: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _getDateTimeFromUser(false);
                                },
                              ),
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
                                                  builder:
                                                      (BuildContext context1) {
                                                    return ConfirmDeleteDialog(
                                                      title:
                                                          "Thực hiện lại công việc",
                                                      content:
                                                          'Công việc sẽ được chuyển sang "Đang thực hiện" ?',
                                                      onConfirm: () {
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        TaskService()
                                                            .changeStatusFromDoneToDoing(
                                                                widget.taskId,
                                                                userId!,
                                                                _desController
                                                                    .text,
                                                                DateFormat(
                                                                        'yyyy-MM-ddTHH:mm:ss.SSSZ')
                                                                    .format(
                                                                        _selectedEndDate!))
                                                            .then((value) {
                                                          if (value) {
                                                            SnackbarShowNoti
                                                                .showSnackbar(
                                                                    "Đổi thành công!",
                                                                    false);
                                                            setState(() {
                                                              isLoading = false;
                                                              Navigator.of(
                                                                      context)
                                                                  .pop("ok");
                                                            });
                                                          } else {
                                                            SnackbarShowNoti
                                                                .showSnackbar(
                                                                    "Xảy ra lỗi!",
                                                                    true);
                                                          }
                                                        }).catchError((e) {
                                                          SnackbarShowNoti
                                                              .showSnackbar(
                                                                  e.toString(),
                                                                  true);
                                                        });
                                                      },
                                                      buttonConfirmText:
                                                          "Đồng ý",
                                                    );
                                                  },
                                                )
                                              }
                                            : {
                                                setState(() {
                                                  isLoading = true;
                                                }),
                                                TaskService()
                                                    .rejectTaskStatus(
                                                        widget.taskId,
                                                        _desController.text)
                                                    .then((value) {
                                                  if (value) {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    SnackbarShowNoti
                                                        .showSnackbar(
                                                            "Đã từ chối!",
                                                            false);
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
                                  backgroundColor:
                                      Colors.red[300], // Màu cho nút Hủy
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
                ],
              ),
            ),
          );
  }

  _getDateTimeFromUser(bool isStart) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.endDate!),
      firstDate: DateTime.parse(widget.endDate!),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (selectedDate != null) {
      // Nếu người dùng đã chọn một ngày, tiếp theo bạn có thể chọn giờ
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        // Người dùng đã chọn cả ngày và giờ
        DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        setState(() {
          _selectedEndDate = selectedDateTime;
        });
      }
      return;
    }
    return;
  }
}
