class Task {
  int id;
  DateTime startDate;
  DateTime endDate;
  String name;
  String description;
  int priority;
  int supervisorId;
  int fieldId;
  int taskTypeId;
  int managerId;
  int? otherId;
  int? habitantId;
  int status;
  DateTime createDate;
  int iterations;
  int remind;
  int repeat;

  Task({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.name,
    required this.description,
    required this.priority,
    required this.supervisorId,
    required this.fieldId,
    required this.taskTypeId,
    required this.managerId,
    this.otherId,
    this.habitantId,
    required this.status,
    required this.createDate,
    required this.iterations,
    required this.remind,
    required this.repeat,
  });

  static String getStatus(int no) {
    switch (no) {
      case 1:
        return "Không hoàn thành";
      case 2:
        return "Đang làm";
      case 3:
        return "Hoàn thành";
      default:
        return "Trạng thái không xác định";
    }
  }
}

List<Task> taskList = [
  Task(
    id: 1,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 7)),
    name: "Làm bài tập toán",
    description: "Hoàn thành bài tập toán đại số",
    priority: 2,
    supervisorId: 101,
    fieldId: 1,
    taskTypeId: 1,
    managerId: 1,
    otherId: 0,
    habitantId: 1,
    status: 2,
    createDate: DateTime.now(),
    iterations: 3,
    remind: 3,
    repeat: 0,
  ),
  Task(
    id: 2,
    startDate: DateTime.now().add(Duration(days: 1)),
    endDate: DateTime.now().add(Duration(days: 5)),
    name: "Đọc sách",
    description: "Đọc sách tiểu thuyết mới",
    priority: 1,
    supervisorId: 102,
    fieldId: 202,
    taskTypeId: 302,
    managerId: 402,
    otherId: 502,
    habitantId: 602,
    status: 1,
    createDate: DateTime.now(),
    iterations: 2,
    remind: 0,
    repeat: 0,
  ),
  Task(
    id: 3,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 10)),
    name: "Lập kế hoạch cuối tuần",
    description: "Lên kế hoạch cho cuối tuần tới",
    priority: 3,
    supervisorId: 103,
    fieldId: 203,
    taskTypeId: 303,
    managerId: 1,
    otherId: 0,
    habitantId: 1,
    status: 1,
    createDate: DateTime.now(),
    iterations: 1,
    remind: 0,
    repeat: 0,
  ),
  Task(
    id: 4,
    startDate: DateTime.now().add(Duration(days: 2)),
    endDate: DateTime.now().add(Duration(days: 3)),
    name: "Thực hiện bài tập thể dục",
    description: "Tập luyện thể dục hàng ngày",
    priority: 2,
    supervisorId: 104,
    fieldId: 204,
    taskTypeId: 304,
    managerId: 404,
    otherId: 504,
    habitantId: 604,
    status: 2,
    createDate: DateTime.now(),
    iterations: 4,
    remind: 0,
    repeat: 0,
  ),
  Task(
    id: 5,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 7)),
    name: "Học lập trình",
    description: "Học và thực hành lập trình",
    priority: 3,
    supervisorId: 105,
    fieldId: 205,
    taskTypeId: 305,
    managerId: 405,
    otherId: 505,
    habitantId: 605,
    status: 3,
    createDate: DateTime.now(),
    iterations: 2,
    remind: 5,
    repeat: 0,
  ),
];
