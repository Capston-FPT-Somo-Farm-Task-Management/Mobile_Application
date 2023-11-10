import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<int> dailyTasks = [10, 5, 8, 12, 6, 9, 7]; // Replace with your data
  int maxTask = 0;
  List<int> totalTasks = [65, 45, 30]; // Replace with your data
  int selectedDay = 0; // Default to show the total tasks
  int selectedColumnIndex = -1;
  bool rotateEffect = false;
  @override
  void initState() {
    super.initState();
    maxTask = dailyTasks
        .reduce((value, element) => value > element ? value : element);
  }

  void onBarTapped(
      FlTouchEvent touchEvent, BarTouchResponse? barTouchResponse) {
    if (barTouchResponse?.spot != null &&
        touchEvent is! PointerUpEvent &&
        touchEvent is! PointerExitEvent) {
      setState(() {
        selectedColumnIndex = barTouchResponse!.spot!.touchedBarGroupIndex;
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
        rotateEffect = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      text: 'Xin chào, ',
                      style: TextStyle(fontSize: 25, color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Huỳnh Ngô Gia Bảo',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 100),
                Icon(
                  Icons.account_circle_rounded,
                  size: 50,
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Text(
                    "Tổng số công việc:",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.29,
                    child: Row(
                      children: [
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              startDegreeOffset: rotateEffect ? 360.0 : null,
                              sections: generatePieChartSections(),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildLegendItem(0, 'Động vật', getColor(0)),
                              SizedBox(height: 10),
                              buildLegendItem(1, 'Thực vật', getColor(1)),
                              SizedBox(height: 10),
                              buildLegendItem(2, 'Khác', getColor(2)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Biểu đồ công việc trong tuần:",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.29,
                    child: BarChart(BarChartData(
                      maxY: double.parse(maxTask.toString()),
                      minY: 0,
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                          show: true,
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
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
                  SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
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
        Color columnColor = isSelected ? Colors.red : Colors.blue;
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
        return const Color(0xff0293ee);
      case 1:
        return const Color(0xfff8b250);
      case 2:
        return const Color(0xff845bef);
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
      text = const Text('T2', style: style);
      break;
    case 1:
      text = const Text('T3', style: style);
      break;
    case 2:
      text = const Text('T4', style: style);
      break;
    case 3:
      text = const Text('T5', style: style);
      break;
    case 4:
      text = const Text('T6', style: style);
      break;
    case 5:
      text = const Text('T7', style: style);
      break;
    case 6:
      text = const Text('CN', style: style);
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
