import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/task_type_service.dart';

import '../../../componets/input_field.dart';

class UpdateTaskType extends StatefulWidget {
  final Map<String, dynamic> taskType;
  const UpdateTaskType({super.key, required this.taskType});

  @override
  UpdateTaskTypeState createState() => UpdateTaskTypeState();
}

class UpdateTaskTypeState extends State<UpdateTaskType> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> filterStatus = [
    "Công việc cây trồng",
    "Công việc chăn nuôi",
    "Công việc khác"
  ];
  String _selectedStatus = "";

  bool isLoading = true;
  // bool isUpdating = false;

  Future<bool> UpdateTaskType(Map<String, dynamic> taskType, int id) {
    return TaskTypeService().UpdateTaskType(taskType, id);
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.taskType['name'];
    _descriptionController.text = widget.taskType['description'];
    _selectedStatus = widget.taskType['status'];
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
    // if (isUpdating) {
    //   return Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }
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
                "Chỉnh sửa loại công việc",
                style: headingStyle,
              ),
              MyInputField(
                maxLength: 100,
                title: "Tên loại",
                hint: "Nhập tên loại",
                controller: _nameController,
              ),
              MyInputField(
                title: "Mô tả",
                hint: "Nhập mô tả",
                controller: _descriptionController,
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
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedStatus = newValue!;
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
                        Positioned(
                            top: 17, left: 16, child: Text(_selectedStatus))
                      ],
                    ),
                  ],
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
    if (_nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      Map<String, dynamic> taskTpye = {
        'name': _nameController.text,
        if (_selectedStatus == "Công việc cây trồng") 'status': 0,
        if (_selectedStatus == "Công việc chăn nuôi") 'status': 1,
        if (_selectedStatus == "Công việc khác") 'status': 2,
        'description': _descriptionController.text
      };
      UpdateTaskType(taskTpye, widget.taskType['id']).then((value) {
        if (value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context, "newTaskType");
          SnackbarShowNoti.showSnackbar("Cập nhật thành công", false);

          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => TaskTypePage(),
          //   ),
          // );
        }
      }).catchError((e) {
        setState(() {
          // isUpdating = true;
        });
        SnackbarShowNoti.showSnackbar(e.toString(), true);
      });
    } else {
      SnackbarShowNoti.showSnackbar(
          'Vui lòng điền đầy đủ thông tin của vật nuôi', true);
    }
  }
}
