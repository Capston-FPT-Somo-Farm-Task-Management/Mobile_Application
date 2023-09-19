class Area {
  int areaId;
  int farmId;
  String areaName;
  double area;

  Area({
    required this.areaId,
    required this.farmId,
    required this.areaName,
    required this.area,
  });

  // Tạo một phương thức toJson để chuyển đổi đối tượng Area thành định dạng JSON
  Map<String, dynamic> toJson() {
    return {
      'AreaId': areaId,
      'FarmId': farmId,
      'AreaName': areaName,
      'Area': area,
    };
  }

  // Tạo một phương thức từ JSON để tạo đối tượng Area từ dữ liệu JSON
  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      areaId: json['AreaId'] as int,
      farmId: json['FarmId'] as int,
      areaName: json['AreaName'] as String,
      area: json['Area'] as double,
    );
  }
}

List<Area> areas = [
  Area(
    areaId: 1,
    farmId: 1,
    areaName: "Khu ăn uống",
    area: 50.0,
  ),
  Area(
    areaId: 2,
    farmId: 1,
    areaName: "Khu bán vé",
    area: 60.0,
  ),
  Area(
    areaId: 3,
    farmId: 1,
    areaName: "Khu quan sát",
    area: 70.0,
  ),
  Area(
    areaId: 4,
    farmId: 1,
    areaName: "Khu trang trại",
    area: 80.0,
  ),
  Area(
    areaId: 5,
    farmId: 4,
    areaName: "Khu ăn uống",
    area: 50.0,
  ),
  Area(
    areaId: 6,
    farmId: 4,
    areaName: "Khu bán vé",
    area: 60.0,
  ),
  Area(
    areaId: 7,
    farmId: 4,
    areaName: "Khu quan sát",
    area: 70.0,
  ),
  Area(
    areaId: 8,
    farmId: 4,
    areaName: "Khu trang trại",
    area: 80.0,
  ),
  Area(
    areaId: 9,
    farmId: 9,
    areaName: "Khu ăn uống",
    area: 50.0,
  ),
  Area(
    areaId: 10,
    farmId: 9,
    areaName: "Khu bán vé",
    area: 60.0,
  ),
  Area(
    areaId: 11,
    farmId: 9,
    areaName: "Khu quan sát",
    area: 70.0,
  ),
  Area(
    areaId: 12,
    farmId: 9,
    areaName: "Khu trang trại",
    area: 80.0,
  ),
];
