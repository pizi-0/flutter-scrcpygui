// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';

class ConfigPayload {
  final String name;
  final String id;

  ConfigPayload({required this.name, required this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
    };
  }

  factory ConfigPayload.fromMap(Map<String, dynamic> map) {
    return ConfigPayload(
      name: map['name'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigPayload.fromJson(String source) =>
      ConfigPayload.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension ConfigPayloader on ScrcpyConfig {
  ConfigPayload toPayload() {
    return ConfigPayload(name: configName, id: id);
  }
}
