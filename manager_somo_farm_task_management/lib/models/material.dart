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
