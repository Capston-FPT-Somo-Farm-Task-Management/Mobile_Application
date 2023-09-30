class Employee {
  int employeeId;
  String fullName;
  String phoneNumber;
  String address;
  bool status;

  Employee({
    required this.employeeId,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.status,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeId: json['EmployeeId'] as int,
      fullName: json['FullName'] as String,
      phoneNumber: json['PhoneNumber'] as String,
      address: json['Address'] as String,
      status: json['Status'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeId': employeeId,
      'FullName': fullName,
      'PhoneNumber': phoneNumber,
      'Address': address,
      'Status': status,
    };
  }
}
