import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/services/habittantType_service.dart';

import '../../../componets/input_field.dart';

class CreatePlantType extends StatefulWidget {
  final int farmId;
  const CreatePlantType({Key? key, required this.farmId}) : super(key: key);

  @override
  CreatePlantTypeState createState() => CreatePlantTypeState();
}

class CreatePlantTypeState extends State<CreatePlantType> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _environmentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool isCreating = false;

  Future<bool> CreatePlantType(Map<String, dynamic> plant) {
    return HabitantTypeService().CreateHabitantType(plant);
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
                "Thêm loại cho cây trồng",
                style: headingStyle,
              ),
              MyInputField(
                maxLength: 100,
                title: "Tên loại cây trồng",
                hint: "Nhập tên loại",
                controller: _nameController,
              ),
              MyInputField(
                title: "Xuất xứ của loại cây trồng",
                hint: "Nhập xuất xứ",
                controller: _originController,
              ),
              MyInputField(
                title: "Môi trường sống của loại cây trồng",
                hint: "Nhập môi trường sống",
                controller: _environmentController,
              ),
              MyInputField(
                title: "Mô tả loại cây trồng",
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
                      "Tạo loại cây trồng",
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
        'status': 0,
        'farmId': widget.farmId
      };
      CreatePlantType(liveStock).then((value) {
        if (value) {
          Navigator.of(context).pop("Ok");
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => PlantTypePage(farmId: widget.farmId),
          //   ),
          // );
        }
      }).catchError((e) {
        setState(() {
          isCreating = false;
        });
        SnackbarShowNoti.showSnackbar(e.toString(), true);
      });
    } else {
      // Nếu có ô trống, hiển thị Snackbar với biểu tượng cảnh báo và màu đỏ
      SnackbarShowNoti.showSnackbar(
          'Vui lòng điền đầy đủ thông tin của loại cây', true);
    }
  }
}
