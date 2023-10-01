class Plant {
  final String id;
  final String name;
  final String typeName;
  final String fieldName;
  final DateTime startDate;

  Plant({
    required this.id,
    required this.name,
    required this.typeName,
    required this.fieldName,
    required this.startDate,
  });
}

List<Plant> plant = [
  Plant(
      id: "SE150111",
      name: "Cây sầu riêng",
      typeName: "Mít",
      fieldName: "Khu đất 1",
      startDate: DateTime(2023, 9, 29)),
  Plant(
      id: "SE150222",
      name: "Cây ổi",
      typeName: "Ổi",
      fieldName: "Khu đất 2",
      startDate: DateTime(2023, 9, 29)),
  Plant(
      id: "SE150333",
      name: "Cây táo tào",
      typeName: "Táo",
      fieldName: "Khu đất 3",
      startDate: DateTime(2023, 9, 29)),
  Plant(
      id: "SE150444",
      name: "Cây bơ Đà Lạt",
      typeName: "Bơ",
      fieldName: "Khu đất 4",
      startDate: DateTime(2023, 9, 29)),
  Plant(
      id: "SE150555",
      name: "Cây bưởi",
      typeName: "Mít",
      fieldName: "Khu đất 5",
      startDate: DateTime(2023, 9, 29)),
];
