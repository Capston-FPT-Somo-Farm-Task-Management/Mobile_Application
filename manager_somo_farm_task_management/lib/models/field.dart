class Field {
  int fieldId;
  int zoneId;
  String fieldName;
  double area;

  Field({
    required this.fieldId,
    required this.zoneId,
    required this.fieldName,
    required this.area,
  });

  Map<String, dynamic> toJson() {
    return {
      'FieldId': fieldId,
      'ZoneId': zoneId,
      'FieldName': fieldName,
      'Area': area,
    };
  }

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      fieldId: json['FieldId'] as int,
      zoneId: json['ZoneId'] as int,
      fieldName: json['FieldName'] as String,
      area: json['Area'] as double,
    );
  }
}

List<Field> fields = [
  Field(fieldId: 1, zoneId: 1, fieldName: "Khu CN 1", area: 50.0),
  Field(fieldId: 2, zoneId: 2, fieldName: "Khu CN 2", area: 60.0),
  Field(fieldId: 3, zoneId: 3, fieldName: "Khu CN  3", area: 70.0),
  Field(fieldId: 4, zoneId: 4, fieldName: "Khu CN  4", area: 80.0),
  Field(fieldId: 5, zoneId: 5, fieldName: "Khu CN  5", area: 90.0),
  Field(fieldId: 6, zoneId: 6, fieldName: "Khu CN  6", area: 50.0),
  Field(fieldId: 7, zoneId: 7, fieldName: "Khu CN  7", area: 60.0),
  Field(fieldId: 8, zoneId: 8, fieldName: "Khu CN  8", area: 70.0),
  Field(fieldId: 9, zoneId: 9, fieldName: "Khu CN  9", area: 80.0),
  Field(fieldId: 10, zoneId: 10, fieldName: "Khu CN  10", area: 90.0),
  Field(fieldId: 11, zoneId: 1, fieldName: "Khu TT 11", area: 50.0),
  Field(fieldId: 12, zoneId: 2, fieldName: "Khu TT 12", area: 60.0),
  Field(fieldId: 13, zoneId: 3, fieldName: "Khu TT 13", area: 70.0),
  Field(fieldId: 14, zoneId: 4, fieldName: "Khu TT 14", area: 80.0),
  Field(fieldId: 15, zoneId: 5, fieldName: "Khu TT 15", area: 90.0),
  Field(fieldId: 16, zoneId: 6, fieldName: "Khu TT 16", area: 50.0),
  Field(fieldId: 17, zoneId: 7, fieldName: "Khu TT 17", area: 60.0),
  Field(fieldId: 18, zoneId: 8, fieldName: "Khu TT 18", area: 70.0),
  Field(fieldId: 19, zoneId: 9, fieldName: "Khu TT 19", area: 80.0),
  Field(fieldId: 20, zoneId: 10, fieldName: "Khu TT 20", area: 90.0),
];
