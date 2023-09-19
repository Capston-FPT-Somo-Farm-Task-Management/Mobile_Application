import 'package:intl/intl.dart';

class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
  });
}

List<Task> taskList = [
  Task(
    id: 1,
    title: "Mua thực phẩm",
    note: "Mua thực phẩm cho tuần này",
    isCompleted: 0,
    date: DateFormat.yMd()
        .format(DateTime.now().add(const Duration(days: 1)))
        .toString(),
    startTime: "09:00 AM",
    endTime: "10:00 AM",
    color: 1, // Màu xanh
    remind: 1,
    repeat: "Hàng ngày",
  ),
  Task(
    id: 2,
    title: "Làm bài tập",
    note: "Hoàn thành bài tập lập trình",
    isCompleted: 1,
    date: DateFormat.yMd().format(DateTime.now()).toString(),
    startTime: "02:00 PM",
    endTime: "03:30 PM",
    color: 0, // Màu cam
    remind: 1,
    repeat: "Hàng ngày",
  ),
  Task(
    id: 3,
    title: "Họp trực tuyến",
    note: "Tham gia cuộc họp trực tuyến với nhóm dự án",
    isCompleted: 0,
    date: DateFormat.yMd().format(DateTime.now()).toString(),
    startTime: "10:30 AM",
    endTime: "11:30 AM",
    color: 2, // Màu hồng
    remind: 1,
    repeat: "Hàng ngày",
  ),
  Task(
    id: 4,
    title: "Đọc sách",
    note: "Đọc một chương mới của cuốn sách yêu thích",
    isCompleted: 0,
    date: DateFormat.yMd()
        .format(DateTime.now().add(const Duration(days: 2)))
        .toString(),
    startTime: "08:00 PM",
    endTime: "09:00 PM",
    color: 1, // Màu xanh lá cây
    remind: 1,
    repeat: "Hàng ngày",
  ),
  Task(
    id: 5,
    title: "Làm việc với email",
    note: "Kiểm tra và trả lời email công việc",
    isCompleted: 1,
    date: DateFormat.yMd()
        .format(DateTime.now().add(const Duration(days: 1)))
        .toString(),
    startTime: "11:00 AM",
    endTime: "12:00 PM",
    color: 2, // Màu cam nhạt
    remind: 1,
    repeat: "Hàng ngày",
  ),
  Task(
    id: 6,
    title: "flutter",
    note: "code flutter do an",
    isCompleted: 1,
    date: DateFormat.yMd().format(DateTime.now()).toString(),
    startTime: "3:05 PM",
    endTime: "9:00 PM",
    color: 0, // Màu cam nhạt
    remind: 1,
    repeat: "Daily",
  ),
];
