import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/services/effort_service.dart';

class TotalTimeEffortPage extends StatefulWidget {
  final int employeeId;

  const TotalTimeEffortPage({super.key, required this.employeeId});
  @override
  _TotalTimeEffortPageState createState() => _TotalTimeEffortPageState();
}

class _TotalTimeEffortPageState extends State<TotalTimeEffortPage> {
  DateTime? startDate;
  DateTime? endDate;
  Map<String, dynamic>? data;
  bool isLoading = true;
  void getData(DateTime? start, DateTime? end) {
    EffortService()
        .getTotalEffortByEmployeeId(widget.employeeId, start, end)
        .then((value) {
      setState(() {
        data = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData(null, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.close_sharp, color: kSecondColor)),
        title: Text("Tổng giờ làm", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _selectDate(context, true);
                            },
                            child: Row(
                              children: [
                                Text(
                                  startDate == null
                                      ? "Ngày bắt đầu"
                                      : DateFormat('dd/MM/yyyy')
                                          .format(startDate!),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.calendar_month)
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 30),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _selectDate(context, false);
                            },
                            child: Row(
                              children: [
                                Text(
                                  endDate == null
                                      ? "Ngày kết thúc"
                                      : DateFormat('dd/MM/yyyy')
                                          .format(endDate!),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.calendar_month)
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (startDate != null && endDate != null)
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                startDate = null;
                                endDate = null;
                                isLoading = true;
                              });
                              getData(startDate, endDate);
                            },
                            child: Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            )),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: startDate != null && endDate != null
                            ? () {
                                setState(() {
                                  isLoading = true;
                                });
                                getData(startDate, endDate);
                              }
                            : null,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: startDate != null && endDate != null
                                ? kPrimaryColor
                                : kTextGreyColor,
                          ),
                          child: Text(
                            'Lọc',
                            style: TextStyle(color: Colors.grey[100]),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 50),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  )
                : Column(
                    children: [
                      _buildInfoCard('Mã nhân viên',
                          data!["employeeId"].toString(), Icons.tag),
                      _buildInfoCard('Tên nhân viên', data!["employeeName"],
                          Icons.person_outline),
                      _buildInfoCard('Effort Time',
                          '${data!["effortTime"]} giờ', Icons.timer),
                      _buildInfoCard(
                          'Tổng số công việc đã làm',
                          data!["totalTask"].toString(),
                          Icons.sticky_note_2_sharp),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          isStartDate ? startDate ?? DateTime.now() : endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime date) {
        // Check if the date is before the start date
        if (isStartDate && endDate != null) {
          return date.isBefore(endDate!) || date.isAtSameMomentAs(endDate!);
        }
        // Check if the date is after the end date
        else if (!isStartDate && startDate != null) {
          return date.isAfter(startDate!) || date.isAtSameMomentAs(startDate!);
        }
        return true; // Default, allow all other dates
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
          if (endDate != null && startDate!.isAfter(endDate!)) {
            endDate = null;
          }
        } else {
          endDate = pickedDate;
          if (startDate != null && endDate!.isBefore(startDate!)) {
            startDate = null;
          }
        }
      });
    }
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.blue,
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
