class ZoneType {
  int zoneTypeId;
  String zoneTypeName;

  ZoneType({
    required this.zoneTypeId,
    required this.zoneTypeName,
  });

  Map<String, dynamic> toJson() {
    return {
      'ZoneTypeId': zoneTypeId,
      'ZoneTypeName': zoneTypeName,
    };
  }

  factory ZoneType.fromJson(Map<String, dynamic> json) {
    return ZoneType(
      zoneTypeId: json['ZoneTypeId'] as int,
      zoneTypeName: json['ZoneTypeName'] as String,
    );
  }
}

List<ZoneType> zoneTypes = [
  ZoneType(zoneTypeId: 1, zoneTypeName: "Type 1"),
  ZoneType(zoneTypeId: 2, zoneTypeName: "Type 2"),
  ZoneType(zoneTypeId: 3, zoneTypeName: "Type 3"),
  ZoneType(zoneTypeId: 4, zoneTypeName: "Type 4"),
  ZoneType(zoneTypeId: 5, zoneTypeName: "Type 5"),
];
