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
