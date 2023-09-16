class Plant {
  final String name;
  final DateTime startDate;
  final int quantity;

  Plant({required this.name, required this.startDate, required this.quantity});
}

List<Plant> plants = [
  Plant(
      name: "Cây sầu riêng 1", startDate: DateTime(2023, 9, 14), quantity: 125),
  Plant(
      name: "Cây sầu riêng 2", startDate: DateTime(2023, 9, 15), quantity: 127),
  Plant(
      name: "Cây sầu riêng 4", startDate: DateTime(2023, 9, 16), quantity: 123),
  Plant(
      name: "Cây sầu riêng 5", startDate: DateTime(2023, 9, 16), quantity: 123),
  Plant(
      name: "Cây sầu riêng 6", startDate: DateTime(2023, 9, 16), quantity: 123),
  Plant(
      name: "Cây sầu riêng 7", startDate: DateTime(2023, 9, 16), quantity: 123),
  Plant(
      name: "Cây sầu riêng 8", startDate: DateTime(2023, 9, 16), quantity: 123),
  Plant(
      name: "Cây sầu riêng 9", startDate: DateTime(2023, 9, 16), quantity: 123),
];
