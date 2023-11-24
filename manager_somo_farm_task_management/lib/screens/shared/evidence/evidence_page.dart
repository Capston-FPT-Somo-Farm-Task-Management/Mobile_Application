import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence/components/evidence_card.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence_add/evidence_add_page.dart';
import 'package:manager_somo_farm_task_management/services/evidence_service.dart';
import 'package:photo_manager/photo_manager.dart';

class EvidencePage extends StatefulWidget {
  final String role;
  final Map<String, dynamic> task;

  const EvidencePage({super.key, required this.task, required this.role});
  @override
  EvidencePageState createState() => EvidencePageState();
}

class EvidencePageState extends State<EvidencePage> {
  bool isLoading = true;
  List<Map<String, dynamic>> evidences = [];
  List<AssetEntity> selectedAssetList = [];

  Future<void> getEvdidence() async {
    EvidenceService().getEvidencebyTaskId(widget.task['id']).then((value) {
      setState(() {
        evidences = value;
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar(e.toString(), true);
    });
  }

  @override
  void initState() {
    print(widget.role);
    super.initState();
    getEvdidence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.role == "Manager"
          ? null
          : FloatingActionButton(
              backgroundColor: kPrimaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateEvidencePage(taskId: widget.task['id'])),
                ).then((value) {
                  if (value != null) {
                    getEvdidence();
                  }
                });
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
            'Báo cáo',
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
                padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                width: double.infinity,
                color: Colors.grey[200],
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "#${widget.task['codeTask'] ?? widget.task['code']}",
                        style: TextStyle(
                          fontSize: 23.0, // Kích thước nhỏ hơn
                          fontStyle: FontStyle.italic, // Chữ in nghiêng
                          color: kSecondColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " - " + widget.task['name'],
                        style: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                          color: kSecondColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
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
                        notificationPredicate: (_) => true,
                        onRefresh: () => getEvdidence(),
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: evidences.map((evidence) {
                              return EvidenceCard(
                                role: widget.role,
                                evidence: evidence,
                                task: widget.task,
                                updateEvidence: getEvdidence,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
