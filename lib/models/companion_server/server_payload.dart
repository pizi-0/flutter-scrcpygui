// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ServerPayload {
  final ServerPayloadType type;
  final String payload;

  ServerPayload({required this.type, required this.payload});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': ServerPayloadType.values.indexOf(type).toString(),
      'payload': payload,
    };
  }

  factory ServerPayload.fromMap(Map<String, dynamic> map) {
    return ServerPayload(
      type: ServerPayloadType.values[int.parse(map['type'] as String)],
      payload: map['payload'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServerPayload.fromJson(String source) =>
      ServerPayload.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum ServerPayloadType {
  devices,
  configs,
  runnings,
  pairs,
  initialData,
  error,
}
