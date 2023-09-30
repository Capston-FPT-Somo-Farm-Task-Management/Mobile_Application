import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant/components/input_field.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant/components/input_number.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant/plant_page.dart';

class CreatePlantField extends StatefulWidget {
  const CreatePlantField({Key? key}) : super(key: key);

  @override
  CreatePlantFieldState createState() => CreatePlantFieldState();
}

class CreatePlantFieldState extends State<CreatePlantField> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<String> crops = ["Sầu riêng", "Mít", "Cam", "Xoai"];
  String _selectedCrop = "Mít";
  List<String> area = ["Khu vực 1", "Khu vực 2", "Khu vực 3", "Khu vực 4"];
  List<String> zones = [];
  List<String> lands = [];
  String _selectedArea = "Khu vực 1";
  String _selectedZone = "Vùng 1";
  String _selectedLand = "Khu đất 1";
  int _currentIndex = 0;

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
                "Thêm vườn cây",
                style: headingStyle,
              ),
              MyInputField(
                title: "Tên vườn",
                hint: "Nhập tên vườn cây",
                controller: _titleController,
              ),
              MyInputField(
                title: "Loại cây trồng",
                hint: _selectedCrop,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitileStyle,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCrop = newValue!;
                    });
                  },
                  items: crops.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              MyInputField(
                title: "Chọn khu vực",
                hint: _selectedArea,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitileStyle,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedArea = newValue!;
                    });
                    updateZones(_selectedArea);
                  },
                  items: area.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              MyInputField(
                title: "Chọn vùng",
                hint: _selectedZone,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitileStyle,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedZone = newValue!;
                    });
                    updateLands(_selectedZone);
                  },
                  items: zones.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              MyInputNumber(
                title: "Số lượng cây trong vườn",
                hint: "Nhập số lượng",
                controller: _noteController,
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
                      "Tạo cây trồng",
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
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      //add database
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const PlantPage(),
        ),
      );
    } else {
      // Nếu có ô trống, hiển thị Snackbar với biểu tượng cảnh báo và màu đỏ
      SnackbarShowNoti.showSnackbar(
          context, 'Vui lòng điền đầy đủ thông tin', true);
    }
  }

  void updateZones(String area) {
    if (area == "Khu vực 1") {
      setState(() {
        zones = ["Vùng 1", "Vùng 2", "Vùng 3", "Vùng 4"];
      });
    } else {
      setState(() {
        zones = [];
        _selectedZone = "";
      });
    }
  }

  void updateLands(String zone) {
    if (zone == "Vùng 1") {
      setState(() {
        lands = ["Khu đất 1", "Khu đất 2", "Khu đất 3", "Khu đất 4"];
      });
    } else {
      setState(() {
        lands = [];
        _selectedLand = "";
      });
    }
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 36525)),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("it's null or something is wrong");
    }
  }
}
