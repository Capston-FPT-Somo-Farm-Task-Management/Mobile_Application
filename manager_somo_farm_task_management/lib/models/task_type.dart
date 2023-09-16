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
    taskTypeName: "Type 1",
    description: "Description for Type 1",
    status: true,
  ),
  TaskType(
    taskTypeId: 2,
    taskTypeName: "Type 2",
    description: "Description for Type 2",
    status: false,
  ),
  TaskType(
    taskTypeId: 3,
    taskTypeName: "Type 3",
    description: "Description for Type 3",
    status: true,
  ),
  TaskType(
    taskTypeId: 4,
    taskTypeName: "Type 4",
    description: "Description for Type 4",
    status: false,
  ),
  TaskType(
    taskTypeId: 5,
    taskTypeName: "Type 5",
    description: "Description for Type 5",
    status: true,
  ),
];
