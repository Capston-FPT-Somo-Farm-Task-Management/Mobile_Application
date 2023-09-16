class EmployeeTaskType {
  int employeeId;
  int taskTypeId;

  EmployeeTaskType({
    required this.employeeId,
    required this.taskTypeId,
  });
}

List<EmployeeTaskType> listEmployeeTaskTypes = [
  EmployeeTaskType(employeeId: 1, taskTypeId: 1),
  EmployeeTaskType(employeeId: 1, taskTypeId: 2),
  EmployeeTaskType(employeeId: 2, taskTypeId: 2),
  EmployeeTaskType(employeeId: 2, taskTypeId: 3),
  EmployeeTaskType(employeeId: 3, taskTypeId: 1),
  EmployeeTaskType(employeeId: 3, taskTypeId: 3),
  EmployeeTaskType(employeeId: 4, taskTypeId: 4),
  EmployeeTaskType(employeeId: 5, taskTypeId: 4),
  EmployeeTaskType(employeeId: 6, taskTypeId: 5),
  EmployeeTaskType(employeeId: 7, taskTypeId: 5),
];
