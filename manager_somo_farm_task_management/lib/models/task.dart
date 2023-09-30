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
