import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_number.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/area/area_page.dart';
import 'package:manager_somo_farm_task_management/services/area_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componets/input_field.dart';

class UpdateArea extends StatefulWidget {
  final Map<String, dynamic> area;
  const UpdateArea({super.key, required this.area});

  @override
  UpdateAreaState createState() => UpdateAreaState();
}

class UpdateAreaState extends State<UpdateArea> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fareaController = TextEditingController();
  final TextEditingController _fareaCodeController = TextEditingController();
  bool isLoading = false;
  int? farmId;
  int? id;

  Future<bool> UpdateArea(Map<String, dynamic> areaData, int id) {
    return AreaService().UpdateArea(areaData, id);
  }

  Future<void> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');
    setState(() {
      farmId = storedFarmId;
    });
  }

  @override
  void initState() {
    super.initState();
    getFarmId();
    _nameController.text = widget.area['name'];
    _fareaController.text = widget.area['fArea'].toString();
    _fareaCodeController.text = widget.area['code'];
    id = widget.area['id'];
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
                      "Chỉnh sửa khu vực",
                      style: headingStyle,
                    ),
                    MyInputField(
                      title: "Mã khu vực",
                      hint: "Nhập mã khu vực",
                      controller: _fareaCodeController,
                    ),
                    MyInputField(
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
                            "Chỉnh sửa khu vực",
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
        "farmId": farmId,
      };
      UpdateArea(areakData, id!).then((value) {
        if (value) {
          setState(() {
            isLoading = false;
          });
          // Navigator.pop(context, "newArea");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AreaPage(farmId: farmId!),
            ),
          );
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
