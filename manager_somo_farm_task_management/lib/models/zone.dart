class Zone {
  int zoneId;
  int zoneTypeId;
  int areaId;
  String zoneName;
  double zoneArea;

  Zone({
    required this.zoneId,
    required this.zoneTypeId,
    required this.areaId,
    required this.zoneName,
    required this.zoneArea,
  });

  Map<String, dynamic> toJson() {
    return {
      'ZoneId': zoneId,
      'ZoneTypeId': zoneTypeId,
      'AreaId': areaId,
      'ZoneName': zoneName,
      'ZoneArea': zoneArea,
    };
  }

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      zoneId: json['ZoneId'] as int,
      zoneTypeId: json['ZoneTypeId'] as int,
      areaId: json['AreaId'] as int,
      zoneName: json['ZoneName'] as String,
      zoneArea: json['ZoneArea'] as double,
    );
  }
}

List<Zone> zones = [
  Zone(zoneId: 1, zoneTypeId: 1, areaId: 4, zoneName: "Zone 1", zoneArea: 50.0),
  Zone(zoneId: 2, zoneTypeId: 2, areaId: 4, zoneName: "Zone 2", zoneArea: 60.0),
  Zone(zoneId: 3, zoneTypeId: 1, areaId: 4, zoneName: "Zone 3", zoneArea: 70.0),
  Zone(zoneId: 4, zoneTypeId: 3, areaId: 4, zoneName: "Zone 4", zoneArea: 80.0),
  Zone(zoneId: 5, zoneTypeId: 2, areaId: 4, zoneName: "Zone 5", zoneArea: 90.0),
  Zone(zoneId: 6, zoneTypeId: 1, areaId: 8, zoneName: "Zone 1", zoneArea: 50.0),
  Zone(zoneId: 7, zoneTypeId: 2, areaId: 8, zoneName: "Zone 2", zoneArea: 60.0),
  Zone(zoneId: 8, zoneTypeId: 1, areaId: 8, zoneName: "Zone 3", zoneArea: 70.0),
  Zone(
      zoneId: 9, zoneTypeId: 3, areaId: 12, zoneName: "Zone 4", zoneArea: 80.0),
  Zone(
      zoneId: 10,
      zoneTypeId: 2,
      areaId: 12,
      zoneName: "Zone 5",
      zoneArea: 90.0),
];
