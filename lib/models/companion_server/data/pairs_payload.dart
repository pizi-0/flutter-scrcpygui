// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:scrcpygui/models/app_config_pair.dart';
import 'package:scrcpygui/models/companion_server/data/config_payload.dart';

class PairsPayload {
  final String name;
  final ConfigPayload config;
  final String deviceId;
  final String hash;

  PairsPayload({
    required this.name,
    required this.config,
    required this.deviceId,
    required this.hash,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'config': config.toMap(),
      'deviceId': deviceId,
      'hash': hash,
    };
  }

  factory PairsPayload.fromMap(Map<String, dynamic> map) {
    return PairsPayload(
      name: map['name'] as String,
      config: ConfigPayload.fromMap(map['config'] as Map<String, dynamic>),
      deviceId: map['deviceId'] as String,
      hash: map['hash'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PairsPayload.fromJson(String source) =>
      PairsPayload.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension PairsPayloader on AppConfigPair {
  PairsPayload toPayload() {
    return PairsPayload(
      name: app.name,
      deviceId: deviceId,
      hash: hashCode.toString(),
      config: config.toPayload(),
    );
  }
}
