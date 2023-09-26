class Plant {
  final String name;
  final DateTime startDate;
  final int quantity;

  Plant({
    required this.name,
    required this.startDate,
    required this.quantity,
  });
}

List<Plant> plants = [
  Plant(name: "Cây sầu riêng", startDate: DateTime(2023, 9, 14), quantity: 125),
  Plant(name: "Cây ổi", startDate: DateTime(2023, 9, 15), quantity: 127),
  Plant(name: "Cây táo tào", startDate: DateTime(2023, 9, 16), quantity: 123),
  Plant(name: "Cây bơ Đà Lạt", startDate: DateTime(2023, 9, 16), quantity: 123),
  Plant(name: "Cây bưởi", startDate: DateTime(2023, 9, 16), quantity: 123)
];
