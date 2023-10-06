class LiveStock {
  final String id;
  final String name;
  final String type;
  final int quantity;
  final DateTime createDate;

  LiveStock(
      {required this.id,
      required this.name,
      required this.type,
      required this.quantity,
      required this.createDate});
}

List<LiveStock> plantList = [
  LiveStock(
      id: "SE150222",
      name: "Heo Thái Lan",
      type: "Heo",
      quantity: 100,
      createDate: DateTime(2023, 9, 26)),
  LiveStock(
      id: "SE150333",
      name: "Bò Mỹ",
      type: "Bò",
      quantity: 100,
      createDate: DateTime(2023, 9, 26)),
  LiveStock(
      id: "SE150444",
      name: "Gà rừng",
      type: "Gà",
      quantity: 100,
      createDate: DateTime(2023, 9, 26)),
  LiveStock(
      id: "SE150555",
      name: "Bò Thái",
      type: "Bò",
      quantity: 100,
      createDate: DateTime(2023, 9, 26)),
  LiveStock(
      id: "SE150666",
      name: "Trâu Thái",
      type: "Trâu",
      quantity: 100,
      createDate: DateTime(2023, 9, 26)),
];
