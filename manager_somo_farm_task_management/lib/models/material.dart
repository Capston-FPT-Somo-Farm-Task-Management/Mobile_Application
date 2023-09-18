class Material {
  final int materialId;
  final String materialName;

  Material({
    required this.materialId,
    required this.materialName,
  });

  Map<String, dynamic> toJson() {
    return {
      'MaterialId': materialId,
      'MaterialName': materialName,
    };
  }

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      materialId: json['MaterialId'] as int,
      materialName: json['MaterialName'] as String,
    );
  }
}

List<Material> materials = [
  Material(materialId: 1, materialName: 'Cái cuốc'),
  Material(materialId: 2, materialName: 'Xe cày'),
  Material(materialId: 3, materialName: 'Xe trồng cây'),
  Material(materialId: 4, materialName: 'Kéo'),
  Material(materialId: 5, materialName: 'Bao tải'),
  Material(materialId: 6, materialName: 'Hạt giống'),
  Material(materialId: 7, materialName: 'Thức ăn cho gia súc'),
  Material(materialId: 8, materialName: 'Nước tưới cây'),
  Material(materialId: 9, materialName: 'Khoai cắt'),
  Material(materialId: 10, materialName: 'Xà lách'),
];
