import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/liveStock/livestockType_page.dart';
import 'package:manager_somo_farm_task_management/services/habittantType_service.dart';

import '../../../componets/input_field.dart';

class CreateLiveStockType extends StatefulWidget {
  final int farmId;
  const CreateLiveStockType({Key? key, required this.farmId}) : super(key: key);

  @override
  CreateLiveStockTypeState createState() => CreateLiveStockTypeState();
}

class CreateLiveStockTypeState extends State<CreateLiveStockType> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _environmentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String name = "";
  int? status;
  int? quantity;
  bool isCreating = false;

  Future<bool> CreateLiveStockType(Map<String, dynamic> liveStock) {
    return HabitantTypeService().CreateHabitantType(liveStock);
  }

  @override
  Widget build(BuildContext context) {
    if (isCreating) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: kSecondColor,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thêm loại cho vật nuôi",
                style: headingStyle,
              ),
              MyInputField(
                title: "Tên loại vật nuôi",
                hint: "Nhập tên loại",
                controller: _nameController,
              ),
              MyInputField(
                title: "Xuất xứ của loại vật nuôi",
                hint: "Nhập xuất xứ",
                controller: _originController,
              ),
              MyInputField(
                title: "Môi trường sống của loại vật nuôi",
                hint: "Nhập môi trường sống",
                controller: _environmentController,
              ),
              MyInputField(
                title: "Mô tả loại vật nuôi",
                hint: "Nhập mô tả",
                controller: _descriptionController,
              ),
              const SizedBox(height: 40),
              const Divider(
                color: Colors.grey, // Đặt màu xám
                height: 1, // Độ dày của dòng gạch
                thickness: 1, // Độ dày của dòng gạch (có thể thay đổi)
              ),
              const SizedBox(height: 30),
              Align(
                child: ElevatedButton(
                  onPressed: () {
                    _validateDate();
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
                      "Tạo loại vật nuôi",
                      style: TextStyle(fontSize: 19),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_nameController.text.isNotEmpty &&
        _originController.text.isNotEmpty &&
        _environmentController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      setState(() {
        isCreating = true;
      });
      Map<String, dynamic> liveStock = {
        'name': _nameController.text,
        'origin': _originController.text,
        'environment': _environmentController.text,
        'description': _descriptionController.text,
        'status': 1,
      };
      CreateLiveStockType(liveStock).then((value) {
        if (value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LiveStockTypePage(farmId: widget.farmId),
            ),
          );
        }
      }).catchError((e) {
        setState(() {
          isCreating = false;
        });
        SnackbarShowNoti.showSnackbar(e.toString(), true);
      });
    } else {
      // Nếu có ô trống, hiển thị Snackbar với biểu tượng cảnh báo và màu đỏ
      SnackbarShowNoti.showSnackbar('Vui lòng điền đầy đủ thông tin', true);
    }
  }
}
