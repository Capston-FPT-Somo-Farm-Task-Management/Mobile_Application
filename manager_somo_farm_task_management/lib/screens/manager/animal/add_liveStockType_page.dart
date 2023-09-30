import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/manager/animal/livestock_page.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant/components/input_field.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant/components/input_number.dart';

class CreateLiveStockType extends StatefulWidget {
  const CreateLiveStockType({Key? key}) : super(key: key);

  @override
  CreateLiveStockTypeState createState() => CreateLiveStockTypeState();
}

class CreateLiveStockTypeState extends State<CreateLiveStockType> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<String> liveStockType = ["Bò", "Heo", "Gà", "Vịt"];
  String _selectedCrop = "Bò";
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
                "Thêm loại cho vật nuôi",
                style: headingStyle,
              ),
              MyInputField(
                title: "Tên loại vật nuôi",
                hint: "Nhập tên loại",
                controller: _titleController,
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
    if (_titleController.text.isNotEmpty) {
      //add database
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LiveStockPage(),
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
