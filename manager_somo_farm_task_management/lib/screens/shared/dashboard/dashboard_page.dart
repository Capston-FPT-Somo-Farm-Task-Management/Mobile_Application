import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/hamburger_show_menu.dart';
import 'package:manager_somo_farm_task_management/services/member_service.dart';
import 'package:manager_somo_farm_task_management/services/task_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<int> dailyTasks = []; // Replace with your data
  int maxTask = 0;
  List<int> totalTasks = []; // Replace with your data
  int totalTasksLiveStock = 0;
  int totalTasksPlant = 0;
  int totalTasksOther = 0;
  int selectedDay = 0; // Default to show the total tasks
  int selectedColumnIndex = -1;
  bool rotateEffect = false;
  int? memberId;
  bool isLoading = true;
  int totalTaskToDo = 0;
  int totalTaskDoing = 0;
  int totalTaskClose = 0;
  int totalTaskPending = 0;
  List<Map<String, dynamic>>? listTotal;
  Map<String, dynamic>? member;
  Future<void> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? userIdStored = prefs.getInt('userId');
    setState(() {
      memberId = userIdStored;
    });
  }

  Future<void> getTotalTaskByDay(int index) async {
    setState(() {
      totalTasksLiveStock = listTotal![index]['totalTaskOfLivestock'];
      totalTasksPlant = listTotal![index]['totalTaskOfPlant'];
      totalTasksOther = listTotal![index]['totalTaskOfOther'];
      totalTaskToDo = listTotal![index]['totalTaskToDo'];
      totalTaskDoing = listTotal![index]['totalTaskDoing'];
      totalTaskClose = listTotal![index]['totalTaskClose'];
      totalTaskPending = listTotal![index]['totalTaskPending'];
      totalTasks = [totalTasksLiveStock, totalTasksPlant, totalTasksOther];
    });
  }

  Future<void> getTotalTaskByWeek() async {
    setState(() {
      dailyTasks.clear();
      totalTasksPlant = 0;
      totalTasksOther = 0;
      totalTasksLiveStock = 0;
      totalTaskToDo = 0;
      totalTaskDoing = 0;
      totalTaskClose = 0;
      totalTaskPending = 0;
      for (var element in listTotal!) {
        dailyTasks.add(element['taskCount']);
        totalTasksPlant += int.parse(element['totalTaskOfPlant'].toString());
        totalTasksOther += int.parse(element['totalTaskOfOther'].toString());
        totalTasksLiveStock +=
            int.parse(element['totalTaskOfLivestock'].toString());
        totalTaskToDo += int.parse(element['totalTaskToDo'].toString());
        totalTaskDoing += int.parse(element['totalTaskDoing'].toString());
        totalTaskClose += int.parse(element['totalTaskClose'].toString());
        totalTaskPending += int.parse(element['totalTaskPending'].toString());
      }
      totalTasks = [totalTasksLiveStock, totalTasksPlant, totalTasksOther];
    });
  }

  Future<void> getReport() async {
    await TaskService().getTotalTaskOfWeekByMember(memberId!).then((value) {
      setState(() {
        listTotal = value;
        for (var element in value) {
          dailyTasks.add(element['taskCount']);
          totalTasksPlant += int.parse(element['totalTaskOfPlant'].toString());
          totalTasksOther += int.parse(element['totalTaskOfOther'].toString());
          totalTasksLiveStock +=
              int.parse(element['totalTaskOfLivestock'].toString());
          totalTaskToDo += int.parse(element['totalTaskToDo'].toString());
          totalTaskDoing += int.parse(element['totalTaskDoing'].toString());
          totalTaskClose += int.parse(element['totalTaskClose'].toString());
          totalTaskPending += int.parse(element['totalTaskPending'].toString());
        }
        maxTask = dailyTasks
            .reduce((value, element) => value > element ? value : element);
        isLoading = false;
        totalTasks = [totalTasksLiveStock, totalTasksPlant, totalTasksOther];
      });
    });
  }

  void initData() {
    setState(() {
      isLoading = true;
    });
    getRole().then((_) async {
      await MemberService().getMemberById(memberId!).then((value) {
        setState(() {
          member = value;
        });
      });
      getReport();
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  void onBarTapped(
      FlTouchEvent touchEvent, BarTouchResponse? barTouchResponse) {
    if (barTouchResponse?.spot != null &&
        touchEvent is! PointerUpEvent &&
        touchEvent is! PointerExitEvent) {
      setState(() {
        selectedColumnIndex = barTouchResponse!.spot!.touchedBarGroupIndex;
        getTotalTaskByDay(selectedColumnIndex);
        rotateEffect = true;
      });
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          rotateEffect = false;
        });
      });
    } else {
      setState(() {
        selectedColumnIndex = -1;
        getTotalTaskByWeek();
        rotateEffect = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: isLoading
          ? null
          : AppBar(
              toolbarHeight: 70,
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Trang chủ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(left: 50),
                        child: Icon(
                          Icons.menu,
                          color: Colors.black,
                          size: 35,
                        ),
                      ),
                      onTap: () {
                        HamburgerMenu.showReusableBottomSheet(context);
                      }),
                ],
              ),
            ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tổng số công việc: ',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        TextSpan(
                          text:
                              '${totalTasksLiveStock + totalTasksPlant + totalTasksOther} công việc ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        TextSpan(
                          text: selectedColumnIndex == -1
                              ? "/ tuần"
                              : selectedColumnIndex == 0
                                  ? "/ CN"
                                  : "/ T${selectedColumnIndex + 1}",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.brown[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          margin: EdgeInsets.fromLTRB(10, 10, 5, 5),
                          height: 100,
                          // Thay đổi màu sắc tùy ý
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                totalTaskToDo.toString(),
                                style: TextStyle(
                                    color: Colors.brown[900],
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Chuẩn bị",
                                style: TextStyle(color: Colors.brown[900]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(5, 10, 10, 5),
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.all(Radius.circular(
                                  15))), // Thay đổi màu sắc tùy ý
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  totalTaskDoing.toString(),
                                  style: TextStyle(
                                      color: Colors.blue[900],
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Đang thực hiện",
                                  style: TextStyle(color: Colors.blue[900]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 5, 10),
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.amber[200],
                              borderRadius: BorderRadius.all(Radius.circular(
                                  15))), // Thay đổi màu sắc tùy ý
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                totalTaskPending.toString(),
                                style: TextStyle(
                                    color: Colors.yellow[900],
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Tạm hoãn",
                                style: TextStyle(color: Colors.yellow[900]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(5, 5, 10, 10),
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.green[300],
                              borderRadius: BorderRadius.all(Radius.circular(
                                  15))), // Thay đổi màu sắc tùy ý
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                totalTaskClose.toString(),
                                style: TextStyle(
                                    color: Colors.green[900],
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Đã đóng",
                                style: TextStyle(color: Colors.green[900]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: PieChart(
                                      PieChartData(
                                        startDegreeOffset:
                                            rotateEffect ? 360.0 : null,
                                        sections: generatePieChartSections(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildLegendItem(
                                            0, 'Vật nuôi', getColor(0)),
                                        SizedBox(height: 10),
                                        buildLegendItem(
                                            1, 'Cây trồng', getColor(1)),
                                        SizedBox(height: 10),
                                        buildLegendItem(2, 'Khác', getColor(2)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              "Biểu đồ công việc trong tuần:",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: BarChart(BarChartData(
                                maxY: double.parse(maxTask.toString()),
                                minY: 0,
                                gridData: FlGridData(show: true),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                    show: true,
                                    topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: getBottomTitles),
                                    )),
                                barGroups: generateBarGroups(),
                                barTouchData: BarTouchData(
                                  touchCallback: onBarTapped,
                                ),
                              )),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  List<PieChartSectionData> generatePieChartSections() {
    return List.generate(
      3,
      (index) {
        return PieChartSectionData(
          color: getColor(index),
          value: totalTasks[index].toDouble(),
          title: '${totalTasks[index]}',
          radius: 120,
          titleStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> generateBarGroups() {
    return List.generate(
      7,
      (index) {
        bool isSelected = selectedColumnIndex == index;
        Color columnColor = isSelected ? Colors.orange : Colors.blue;
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: dailyTasks[index].toDouble(),
              color: columnColor,
              width: 25,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      },
    );
  }

  Color getColor(int index) {
    switch (index) {
      case 0:
        return kPrimaryColor;
      case 1:
        return kSecondColor;
      case 2:
        return kTextGreyColor;
      default:
        return const Color(0xff0293ee);
    }
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  late Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('CN', style: style);
      break;
    case 1:
      text = const Text('T2', style: style);
      break;
    case 2:
      text = const Text('T3', style: style);
      break;
    case 3:
      text = const Text('T4', style: style);
      break;
    case 4:
      text = const Text('T5', style: style);
      break;
    case 5:
      text = const Text('T6', style: style);
      break;
    case 6:
      text = const Text('T7', style: style);
      break;
  }
  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}

Widget buildLegendItem(int index, String label, Color color) {
  return Row(
    children: [
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(fontSize: 16),
      ),
    ],
  );
}
