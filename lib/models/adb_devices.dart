// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AdbDevices {
  final String? name;
  final String id;
  final String modelName;
  final String serialNo;
  final bool status;

  AdbDevices({
    this.name,
    required this.serialNo,
    required this.id,
    required this.modelName,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'modelName': modelName,
      'serialNo': serialNo,
      'status': status,
    };
  }

  factory AdbDevices.fromMap(Map<String, dynamic> map) {
    return AdbDevices(
      name: map['name'] != null ? map['name'] as String : null,
      id: map['id'] as String,
      modelName: map['modelName'] as String,
      serialNo: map['serialNo'] as String,
      status: map['status'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdbDevices.fromJson(String source) =>
      AdbDevices.fromMap(json.decode(source) as Map<String, dynamic>);

  AdbDevices copyWith({
    String? name,
    String? id,
    String? modelName,
    String? serialNo,
    bool? status,
  }) {
    return AdbDevices(
      name: name ?? this.name,
      id: id ?? this.id,
      modelName: modelName ?? this.modelName,
      serialNo: serialNo ?? this.serialNo,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(covariant AdbDevices other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.id == id &&
        other.modelName == modelName &&
        other.serialNo == serialNo &&
        other.status == status;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        modelName.hashCode ^
        serialNo.hashCode ^
        status.hashCode;
  }

  @override
  String toString() {
    return 'AdbDevices(name: $name, id: $id, modelName: $modelName, serialNo: $serialNo, status: $status)';
  }
}
