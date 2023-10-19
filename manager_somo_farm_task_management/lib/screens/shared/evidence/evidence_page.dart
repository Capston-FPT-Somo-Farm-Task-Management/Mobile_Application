import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence/components/evidence_card.dart';
import 'package:manager_somo_farm_task_management/services/evidence_service.dart';

class EvidencePage extends StatefulWidget {
  final Map<String, dynamic> task;

  const EvidencePage({super.key, required this.task});
  @override
  EvidencePageState createState() => EvidencePageState();
}

class EvidencePageState extends State<EvidencePage> {
  bool isLoading = true;
  List<Map<String, dynamic>> evidences = [];
  File? _image; // Biến để lưu trữ ảnh đã chọn

  // Hàm này để chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> getEvdidence() async {
    EvidenceService().getEvidencebyTaskId(widget.task['id']).then((value) {
      setState(() {
        evidences = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getEvdidence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEvidenceDialog(); // Hiển thị popup khi nhấn nút
        },
        tooltip: 'Thêm Báo Cáo',
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
          color: kSecondColor, // Change to your preferred color
        ),
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            'Báo cáo công việc',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                width: double.infinity,
                color: Colors.grey[200],
                child: Text(
                  widget.task['name'],
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Container(
              //   color: Colors.white,
              //   padding: EdgeInsets.symmetric(vertical: 5),
              //   child: ListTile(
              //     leading: Icon(
              //       Icons.account_circle_sharp,
              //       size: 45,
              //     ),
              //     title: GestureDetector(
              //       onTap: () {
              //         _showAddEvidenceDialog();
              //       },
              //       child: const TextField(
              //         enabled: false,
              //         decoration: InputDecoration(
              //           hintText: "Tạo báo cáo ngay!",
              //           border: InputBorder.none,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                margin: EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  )
                : evidences.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.no_backpack,
                              size:
                                  75, // Kích thước biểu tượng có thể điều chỉnh
                              color: Colors.grey, // Màu của biểu tượng
                            ),
                            SizedBox(
                                height:
                                    16), // Khoảng cách giữa biểu tượng và văn bản
                            Text(
                              "Chưa có báo cáo nào",
                              style: TextStyle(
                                fontSize:
                                    20, // Kích thước văn bản có thể điều chỉnh
                                color: Colors.grey, // Màu văn bản
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => getEvdidence(),
                        child: ListView.builder(
                          itemCount: evidences.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                EvidenceCard(
                                  evidence: evidences[index],
                                  task: widget.task,
                                  updateEvidence: getEvdidence,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddEvidenceDialog() async {
    TextEditingController descriptionController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm Báo Cáo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Mô Tả'),
                ),
                SizedBox(height: 16),
                // Nút để chọn ảnh
                ElevatedButton(
                  onPressed: () {
                    _pickImage(); // Gọi hàm chọn ảnh khi nhấn nút
                  },
                  child: Text('Chọn Ảnh'),
                ),
                // Hiển thị ảnh đã chọn (nếu có)
                _image != null
                    ? Image.file(
                        _image!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Xử lý lưu thông tin mô tả và ảnh
                String description = descriptionController.text;
                // Sử dụng _image cho việc xử lý ảnh

                // Sau khi xử lý xong, đóng hộp thoại
                Navigator.of(context).pop();
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}
