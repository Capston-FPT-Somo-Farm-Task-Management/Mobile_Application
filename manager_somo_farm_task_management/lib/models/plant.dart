class Plant {
  final String id;
  final String name;
  final DateTime startDate;
  final int quantity;

  Plant({
    required this.id,
    required this.name,
    required this.startDate,
    required this.quantity,
  });
}

List<Plant> plants = [
  Plant(
      id: "SE150111",
      name: "Cây sầu riêng",
      startDate: DateTime(2023, 9, 14),
      quantity: 125),
  Plant(
      id: "SE150222",
      name: "Cây ổi",
      startDate: DateTime(2023, 9, 15),
      quantity: 127),
  Plant(
      id: "SE150333",
      name: "Cây táo tào",
      startDate: DateTime(2023, 9, 16),
      quantity: 123),
  Plant(
      id: "SE150444",
      name: "Cây bơ Đà Lạt",
      startDate: DateTime(2023, 9, 16),
      quantity: 123),
  Plant(
      id: "SE150555",
      name: "Cây bưởi",
      startDate: DateTime(2023, 9, 16),
      quantity: 123)
];
