// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AuthPayload {
  final String deviceName;
  final String deviceModel;
  final String apikey;

  AuthPayload({
    required this.deviceName,
    required this.apikey,
    required this.deviceModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deviceName': deviceName,
      'deviceModel': deviceModel,
      'apikey': apikey,
    };
  }

  factory AuthPayload.fromMap(Map<String, dynamic> map) {
    return AuthPayload(
      deviceName: map['deviceName'] as String,
      deviceModel: map['deviceModel'] as String,
      apikey: map['apikey'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthPayload.fromJson(String source) =>
      AuthPayload.fromMap(json.decode(source) as Map<String, dynamic>);
}
