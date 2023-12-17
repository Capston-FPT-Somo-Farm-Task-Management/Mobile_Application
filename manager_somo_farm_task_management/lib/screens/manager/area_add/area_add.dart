import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_number.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';

import '../../../componets/input_field.dart';

class CreateArea extends StatefulWidget {
  final int farmId;
  const CreateArea({super.key, required this.farmId});

  @override
  CreateAreaState createState() => CreateAreaState();
}

class CreateAreaState extends State<CreateArea> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fareaController = TextEditingController();
  final TextEditingController _fareaCodeController = TextEditingController();
  bool isLoading = false;

  Future<bool> createArea(Map<String, dynamic> areaData) {
    return AreaService().createArea(areaData);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thêm khu vực",
                      style: headingStyle,
                    ),
                    MyInputField(
                      maxLength: 20,
                      title: "Mã khu vực",
                      hint: "Nhập mã khu vực",
                      controller: _fareaCodeController,
                    ),
                    MyInputField(
                      maxLength: 100,
                      title: "Tên khu vực",
                      hint: "Nhập tên khu vực",
                      controller: _nameController,
                    ),
                    MyInputNumber(
                      title: "Diện tích (mét vuông)",
                      hint: "Nhập diện tích",
                      controller: _fareaController,
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
                            "Tạo khu vực",
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
    setState(() {
      isLoading = true;
    });
    if (_nameController.text.isNotEmpty &&
        _fareaController.text.isNotEmpty &&
        _fareaCodeController.text.isNotEmpty) {
      Map<String, dynamic> areakData = {
        "code": _fareaCodeController.text,
        "name": _nameController.text,
        "fArea": _fareaController.text,
        "farmId": widget.farmId,
      };
      createArea(areakData).then((value) {
        if (value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context, "newArea");
        }
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        SnackbarShowNoti.showSnackbar(e.toString(), true);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar('Vui lòng điền đầy đủ thông tin!', true);
    }
  }
}
