// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:scrcpygui/models/companion_server/authenticated_client.dart';

class CompanionServerSettings {
  final String id;
  final String name;
  final String endpoint;
  final String adapter;
  final String secret;
  final String port;
  final bool startOnLaunch;
  final List<BlockedClient> blocklist;

  CompanionServerSettings({
    required this.id,
    required this.name,
    required this.endpoint,
    required this.adapter,
    required this.secret,
    required this.port,
    required this.startOnLaunch,
    required this.blocklist,
  });

  CompanionServerSettings copyWith({
    String? name,
    String? endpoint,
    String? adapter,
    String? secret,
    String? port,
    bool? startOnLaunch,
    List<BlockedClient>? blocklist,
    String? id,
  }) {
    return CompanionServerSettings(
      id: id ?? this.id,
      name: name ?? this.name,
      endpoint: endpoint ?? this.endpoint,
      adapter: adapter ?? this.adapter,
      secret: secret ?? this.secret,
      port: port ?? this.port,
      startOnLaunch: startOnLaunch ?? this.startOnLaunch,
      blocklist: blocklist ?? this.blocklist,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'adapter': adapter,
      'endpoint': endpoint,
      'secret': secret,
      'port': port,
      'startOnLaunch': startOnLaunch,
      'blocklist': blocklist.map((x) => x.toMap()).toList(),
    };
  }

  Map<String, dynamic> toQrMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'ip': endpoint,
      'secret': secret,
      'port': int.parse(port),
    };
  }

  factory CompanionServerSettings.fromMap(Map<String, dynamic> map) {
    return CompanionServerSettings(
      id: map['id'] as String,
      name: map['name'] as String,
      endpoint: map['endpoint'] as String,
      adapter: map['adapter'] ?? '',
      secret: map['secret'] as String,
      port: map['port'] as String,
      startOnLaunch: map['startOnLaunch'] as bool,
      blocklist: List<BlockedClient>.from(
        (map['blocklist'] as List<dynamic>).map<BlockedClient>(
          (x) => BlockedClient.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  String toQrJson() => json.encode(toQrMap());

  factory CompanionServerSettings.fromJson(String source) =>
      CompanionServerSettings.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CompanionServerSettings(name: $name, endpoint: $endpoint, secret: $secret, port: $port, startOnLaunch: $startOnLaunch, blocklist: $blocklist)';
  }

  @override
  bool operator ==(covariant CompanionServerSettings other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.endpoint == endpoint &&
        other.secret == secret &&
        other.port == port &&
        other.startOnLaunch == startOnLaunch &&
        listEquals(other.blocklist, blocklist);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        endpoint.hashCode ^
        secret.hashCode ^
        port.hashCode ^
        startOnLaunch.hashCode ^
        blocklist.hashCode;
  }
}
