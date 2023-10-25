import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';

class RejectionReasonPopup extends StatefulWidget {
  final int taskId;

  const RejectionReasonPopup({super.key, required this.taskId});
  @override
  _RejectionPopupState createState() => _RejectionPopupState();
}

class _RejectionPopupState extends State<RejectionReasonPopup> {
  final TextEditingController _desController = TextEditingController();
  bool isValidate = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          )
        : AlertDialog(
            title: Text("Lý do từ chối"),
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
                      decoration: InputDecoration(labelText: "Nhập lý do"),
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
                                  setState(() {
                                    isLoading = true;
                                  });
                                  TaskService()
                                      .rejectTaskStatus(
                                          widget.taskId, _desController.text)
                                      .then((value) {
                                    if (value) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      SnackbarShowNoti.showSnackbar(
                                          "Đã từ chối!", false);
                                      Navigator.of(context).pop("Change");
                                    }
                                  }).catchError((e) {
                                    SnackbarShowNoti.showSnackbar(
                                        e.toString(), true);
                                  });
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
