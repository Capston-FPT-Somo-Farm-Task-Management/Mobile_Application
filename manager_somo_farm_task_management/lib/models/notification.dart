class Notifications {
  int id;
  String sender;
  String receiver;
  String content;
  bool isRead;
  DateTime createDate;
  Notifications({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.isRead,
    required this.createDate,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'],
      sender: json['sender'],
      receiver: json['receiver'],
      content: json['content'],
      isRead: json['isRead'],
      createDate: DateTime.parse(
          json['createDate']), // Chuyển đổi từ chuỗi thành DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'content': content,
      'isRead': isRead,
      'createDate':
          createDate.toIso8601String(), // Chuyển đổi thành chuỗi ISO 8601
    };
  }
}

List<Notifications> notificationList = [
  Notifications(
      id: 1,
      sender: "Manager A",
      receiver: "User 1",
      content: "đã tạo một công việc mới",
      isRead: false,
      createDate: DateTime.now()),
  Notifications(
      id: 2,
      sender: "Nguyen Daaa",
      receiver: "User 2",
      content: "Nội dung thông báo 2",
      isRead: true,
      createDate: DateTime.now()),
  Notifications(
      id: 3,
      sender: "Tran FcA",
      receiver: "User 1",
      content: "Nội dung thông báo 3",
      isRead: false,
      createDate: DateTime.now()),
  // Thêm các thông báo khác ở đây
];
