import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/services/evidence_service.dart';

class ViewRejectionReasonPopup extends StatelessWidget {
  final int taskId;
  final String role;

  ViewRejectionReasonPopup({required this.taskId, required this.role});
  String rejectionReason = "";
  Future<void> getEvdidence() async {
    EvidenceService().getEvidencebyTaskId(taskId).then((value) {
      rejectionReason = value[0]['description'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Lý do từ chối"),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(rejectionReason),
            SizedBox(height: 20),
            if (role == "Manager")
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor, // Màu cho nút Hủy
                    ),
                    onPressed: () {
                      // Thực hiện hành động khi người dùng chấp nhận
                      Navigator.of(context).pop();
                      // Add code xử lý khi chấp nhận
                    },
                    child: Text("Chấp nhận"),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[300], // Màu cho nút Hủy
                    ),
                    onPressed: () {
                      // Thực hiện hành động khi người dùng không chấp nhận
                      Navigator.of(context).pop();
                      // Add code xử lý khi không chấp nhận
                    },
                    child: Text("Không chấp nhận"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
