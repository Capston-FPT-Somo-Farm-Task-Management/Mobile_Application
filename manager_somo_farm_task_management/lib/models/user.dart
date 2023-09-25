class User {
  final int userId;
  final int roleId;
  final int farmId;
  final String userName;
  final String password;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String birthday;
  final String address;
  final bool status;

  User({
    required this.userId,
    required this.roleId,
    required this.farmId,
    required this.userName,
    required this.password,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.birthday,
    required this.address,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['UserId'],
      roleId: json['RoleId'],
      farmId: json['FarmId'],
      userName: json['UserName'],
      password: json['Password'],
      email: json['Email'],
      fullName: json['FullName'],
      phoneNumber: json['PhoneNumber'],
      birthday: json['Birthday'],
      address: json['Address'],
      status: json['Status'] == 1, // Chuyển đổi từ bit (1 hoặc 0) thành bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'RoleId': roleId,
      'FarmId': farmId,
      'UserName': userName,
      'Password': password,
      'Email': email,
      'FullName': fullName,
      'PhoneNumber': phoneNumber,
      'Birthday': birthday,
      'Address': address,
      'Status': status ? 1 : 0, // Chuyển đổi từ bool thành bit (1 hoặc 0)
    };
  }
}
