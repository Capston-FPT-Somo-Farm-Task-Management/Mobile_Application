import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/habittantType_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componets/input_field.dart';

class UpdateHabitantType extends StatefulWidget {
  final Map<String, dynamic> habitantType;
  const UpdateHabitantType({super.key, required this.habitantType});

  @override
  UpdateHabitantTypeState createState() => UpdateHabitantTypeState();
}

class UpdateHabitantTypeState extends State<UpdateHabitantType> {
  final TextEditingController _titleOriginController = TextEditingController();
  final TextEditingController _titleNameController = TextEditingController();
  final TextEditingController _titleEnvironmentController =
      TextEditingController();
  final TextEditingController _titleDescriptionController =
      TextEditingController();

  List<String> filterStatus = ["Động vật", "Thực vật"];
  String _selectedStatus = "";

  String name = "";
  String origin = "";
  String environment = "";
  String description = "";
  int? weight;
  int status = 0;
  int? farmId;
  int? id;
  bool isLoading = true;
  bool isUpdating = false;

  Future<void> getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFarmId = prefs.getInt('farmId');
    setState(() {
      farmId = storedFarmId;
    });
  }

  Future<bool> UpdateHabitantType(Map<String, dynamic> habitantType, int id) {
    return HabitantTypeService().UpdateHabitantType(habitantType, id);
  }

  @override
  void initState() {
    super.initState();
    _titleOriginController.text = widget.habitantType['origin'];
    _titleNameController.text = widget.habitantType['name'];
    _titleEnvironmentController.text = widget.habitantType['environment'];
    _titleDescriptionController.text = widget.habitantType['description'];
    _selectedStatus = widget.habitantType['status'];
    farmId = widget.habitantType['farmId'];
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (isUpdating) {
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
              widget.habitantType['status'] == "Động vật"
                  ? Text(
                      "Chỉnh sửa loại vật nuôi",
                      style: headingStyle,
                    )
                  : Text(
                      "Chỉnh sửa loại cây trồng",
                      style: headingStyle,
                    ),
              MyInputField(
                maxLength: 100,
                title: "Tên loại",
                hint: "Nhập tên loại",
                controller: _titleNameController,
              ),
              MyInputField(
                title: "Nơi xuất xứ",
                hint: "Nhập nơi xuất xứ",
                controller: _titleOriginController,
              ),
              MyInputField(
                title: "Môi trường sống",
                hint: "Nhập môi trường sống",
                controller: _titleEnvironmentController,
              ),
              MyInputField(
                title: "Mô tả",
                hint: "Nhập mô tả",
                controller: _titleDescriptionController,
              ),
              MyInputField(
                title: "Chọn loại (động vật/thực vật)",
                hint: _selectedStatus,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  underline: Container(height: 0),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitileStyle,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue!;
                      if (_selectedStatus == 'Động vật') {
                        status = 1;
                      }
                      if (_selectedStatus == "Thực vật") {
                        status = 0;
                      }
                    });
                  },
                  items: filterStatus
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
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
                      "Hoàn tất chỉnh sửa",
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
    if (_titleOriginController.text.isNotEmpty &&
        _titleNameController.text.isNotEmpty &&
        _titleEnvironmentController.text.isNotEmpty &&
        _titleDescriptionController.text.isNotEmpty) {
      setState(() {
        isUpdating = true;
      });
      Map<String, dynamic> habitantTpye = {
        'name': _titleNameController.text,
        'origin': _titleOriginController.text,
        'environment': _titleEnvironmentController.text,
        if (_selectedStatus == "Động vật") 'status': 1,
        if (_selectedStatus == "Thực vật") 'status': 0,
        'description': _titleDescriptionController.text
      };
      UpdateHabitantType(habitantTpye, widget.habitantType['id']).then((value) {
        if (value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context, "newType");
          SnackbarShowNoti.showSnackbar("Cập nhật thành công", false);
        }
      }).catchError((e) {
        setState(() {
          isUpdating = true;
        });
        SnackbarShowNoti.showSnackbar(e.toString(), true);
      });
    } else {
      SnackbarShowNoti.showSnackbar(
          'Vui lòng điền đầy đủ thông tin của vật nuôi', true);
    }
  }
}
