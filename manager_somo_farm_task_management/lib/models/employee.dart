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

List<Employee> listEmployees = [
  Employee(
    employeeId: 1,
    fullName: "Nguyễn Văn A",
    phoneNumber: "0123456789",
    address: "123 Đường ABC, Quận XYZ",
    status: true,
  ),
  Employee(
    employeeId: 2,
    fullName: "Trần Thị B",
    phoneNumber: "0987654321",
    address: "456 Đường DEF, Quận UVW",
    status: true,
  ),
  Employee(
    employeeId: 3,
    fullName: "Lê Văn C",
    phoneNumber: "0123456780",
    address: "789 Đường GHI, Quận MNO",
    status: true,
  ),
  Employee(
    employeeId: 4,
    fullName: "Phạm Thị D",
    phoneNumber: "0987654322",
    address: "101 Đường JKL, Quận PQR",
    status: true,
  ),
  Employee(
    employeeId: 5,
    fullName: "Trần Văn E",
    phoneNumber: "0123456781",
    address: "112 Đường STU, Quận YZA",
    status: true,
  ),
  Employee(
    employeeId: 6,
    fullName: "Nguyễn Thị F",
    phoneNumber: "0987654323",
    address: "234 Đường VWX, Quận CDE",
    status: false,
  ),
  Employee(
    employeeId: 7,
    fullName: "Lê Văn G",
    phoneNumber: "0123456782",
    address: "567 Đường XYZ, Quận ABC",
    status: true,
  ),
  Employee(
    employeeId: 8,
    fullName: "Phạm Thị H",
    phoneNumber: "0987654324",
    address: "890 Đường MNO, Quận GHI",
    status: true,
  ),
  Employee(
    employeeId: 9,
    fullName: "Nguyễn Văn I",
    phoneNumber: "0123456783",
    address: "123 Đường PQR, Quận JKL",
    status: true,
  ),
  Employee(
    employeeId: 10,
    fullName: "Trần Thị K",
    phoneNumber: "0987654325",
    address: "456 Đường YZA, Quận UVW",
    status: true,
  ),
];
