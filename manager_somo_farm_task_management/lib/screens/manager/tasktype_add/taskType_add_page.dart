import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/taskType/taskType_page.dart';
import 'package:manager_somo_farm_task_management/services/task_type_service.dart';

import '../../../componets/input_field.dart';

class CreateTaskType extends StatefulWidget {
  const CreateTaskType({Key? key}) : super(key: key);

  @override
  CreateTaskTypeState createState() => CreateTaskTypeState();
}

class CreateTaskTypeState extends State<CreateTaskType> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> filterStatus = [
    "Công việc cây trồng",
    "Công việc chăn nuôi",
    "Công việc khác"
  ];
  String? _selectedStatus = "Chọn";
  bool isCreating = false;

  Future<bool> CreateTaskType(Map<String, dynamic> tasktype) {
    return TaskTypeService().CreateTaskType(tasktype);
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
                "Thêm loại công việc",
                style: headingStyle,
              ),
              MyInputField(
                maxLength: 100,
                title: "Tên loại công việc",
                hint: "Nhập tên",
                controller: _nameController,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Loại công việc",
                      style: titileStyle,
                    ),
                    SizedBox(height: 5),
                    Stack(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            minHeight:
                                50.0, // Đặt giá trị minHeight theo ý muốn của bạn
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            underline: Container(height: 0),
                            // value: _selectedArea,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedStatus = newValue;
                              });
                            },
                            items: filterStatus
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Positioned(
                            top: 17, left: 16, child: Text(_selectedStatus!))
                      ],
                    ),
                  ],
                ),
              ),
              MyInputField(
                title: "Mô tả loại công việc",
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
                      "Tạo loại công việc",
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
        _descriptionController.text.isNotEmpty &&
        _selectedStatus != "Chọn") {
      setState(() {
        isCreating = true;
      });
      Map<String, dynamic> liveStock = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        if (_selectedStatus == "Công việc cây trồng") 'status': 0,
        if (_selectedStatus == "Công việc chăn nuôi") 'status': 1,
        if (_selectedStatus == "Công việc khác") 'status': 2,
      };
      CreateTaskType(liveStock).then((value) {
        if (value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => TaskTypePage(),
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
