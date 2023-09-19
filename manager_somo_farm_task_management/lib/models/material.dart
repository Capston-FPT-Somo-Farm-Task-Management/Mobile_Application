class MaterialFarm {
  final int materialId;
  final String materialName;

  MaterialFarm({
    required this.materialId,
    required this.materialName,
  });

  Map<String, dynamic> toJson() {
    return {
      'MaterialId': materialId,
      'MaterialName': materialName,
    };
  }

  factory MaterialFarm.fromJson(Map<String, dynamic> json) {
    return MaterialFarm(
      materialId: json['MaterialId'] as int,
      materialName: json['MaterialName'] as String,
    );
  }
}

List<MaterialFarm> materials = [
  MaterialFarm(materialId: 1, materialName: 'Cái cuốc'),
  MaterialFarm(materialId: 2, materialName: 'Xe cày'),
  MaterialFarm(materialId: 3, materialName: 'Xe trồng cây'),
  MaterialFarm(materialId: 4, materialName: 'Kéo'),
  MaterialFarm(materialId: 5, materialName: 'Bao tải'),
  MaterialFarm(materialId: 6, materialName: 'Hạt giống'),
  MaterialFarm(materialId: 7, materialName: 'Thức ăn cho gia súc'),
  MaterialFarm(materialId: 8, materialName: 'Nước tưới cây'),
  MaterialFarm(materialId: 9, materialName: 'Khoai cắt'),
  MaterialFarm(materialId: 10, materialName: 'Xà lách'),
];
