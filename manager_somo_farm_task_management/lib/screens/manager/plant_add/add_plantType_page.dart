import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/input_number.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/liveStock/livestock_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant/plantType_page.dart';
import 'package:manager_somo_farm_task_management/services/habittantType_service.dart';

import '../../../componets/input_field.dart';

class CreatePlantType extends StatefulWidget {
  const CreatePlantType({Key? key}) : super(key: key);

  @override
  CreatePlantTypeState createState() => CreatePlantTypeState();
}

class CreatePlantTypeState extends State<CreatePlantType> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _titleNumberController = TextEditingController();
  String name = "";
  int? status;
  int? quantity;
  Future<Map<String, dynamic>> CreatePlantType(Map<String, dynamic> plant) {
    return HabitantTypeService().CreateHabitantType(plant);
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
                title: "Tên loại cây trồng",
                hint: "Nhập tên loại",
                controller: _titleController,
              ),
              MyInputNumber(
                title: "Nhập số lượng",
                hint: "Nhập số lượng",
                controller: _titleNumberController,
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
    if (_titleController.text.isNotEmpty) {
      //add database
      Map<String, dynamic> liveStock = {
        'name': _titleController.text,
        'status': 0,
        'quantity': _titleNumberController.hashCode,
      };
      CreatePlantType(liveStock).then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PlantTypePage(),
          ),
        );
      });
    } else {
      // Nếu có ô trống, hiển thị Snackbar với biểu tượng cảnh báo và màu đỏ
      SnackbarShowNoti.showSnackbar(
          context, 'Vui lòng điền đầy đủ thông tin', true);
    }
  }
}
