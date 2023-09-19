class TaskType {
  int taskTypeId;
  String taskTypeName;
  String description;
  bool status;

  TaskType({
    required this.taskTypeId,
    required this.taskTypeName,
    required this.description,
    required this.status,
  });

  factory TaskType.fromJson(Map<String, dynamic> json) {
    return TaskType(
      taskTypeId: json['TaskTypeId'] as int,
      taskTypeName: json['TaskTypeName'] as String,
      description: json['Description'] as String,
      status: json['Status'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TaskTypeId': taskTypeId,
      'TaskTypeName': taskTypeName,
      'Description': description,
      'Status': status,
    };
  }
}

List<TaskType> listTaskTypes = [
  TaskType(
    taskTypeId: 1,
    taskTypeName: "Trồng trọt",
    description: "Description for Trồng trọt",
    status: true,
  ),
  TaskType(
    taskTypeId: 2,
    taskTypeName: "Chăn nuôi",
    description: "Description for Chăn nuôi",
    status: false,
  ),
  TaskType(
    taskTypeId: 3,
    taskTypeName: "Thú y",
    description: "Description for Thú y",
    status: true,
  ),
  TaskType(
    taskTypeId: 4,
    taskTypeName: "Đất đai",
    description: "Description for Đất đai",
    status: false,
  ),
  TaskType(
    taskTypeId: 5,
    taskTypeName: "Thủy sản",
    description: "Description for Thủy sản",
    status: true,
  ),
];
