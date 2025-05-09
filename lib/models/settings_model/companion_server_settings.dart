// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CompanionServerSettings {
  final String name;
  final String endpoint;
  final String secret;
  final String port;
  final bool startOnLaunch;

  CompanionServerSettings({
    required this.name,
    required this.endpoint,
    required this.secret,
    required this.port,
    required this.startOnLaunch,
  });

  CompanionServerSettings copyWith({
    String? name,
    String? endpoint,
    String? secret,
    String? port,
    bool? startOnLaunch,
  }) {
    return CompanionServerSettings(
      name: name ?? this.name,
      endpoint: endpoint ?? this.endpoint,
      secret: secret ?? this.secret,
      port: port ?? this.port,
      startOnLaunch: startOnLaunch ?? this.startOnLaunch,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'endpoint': endpoint,
      'secret': secret,
      'port': port,
      'startOnLaunch': startOnLaunch,
    };
  }

  Map<String, dynamic> toQrMap() {
    return <String, dynamic>{
      'name': name,
      'ip': endpoint,
      'secret': secret,
      'port': int.parse(port),
    };
  }

  factory CompanionServerSettings.fromMap(Map<String, dynamic> map) {
    return CompanionServerSettings(
      name: map['name'] as String,
      endpoint: map['endpoint'] as String,
      secret: map['secret'] as String,
      port: map['port'] as String,
      startOnLaunch: map['startOnLaunch'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  String toQrJson() => json.encode(toQrMap());

  factory CompanionServerSettings.fromJson(String source) =>
      CompanionServerSettings.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CompanionServerSettings(name: $name, endpoint: $endpoint, secret: $secret, port: $port, startOnLaunch: $startOnLaunch)';
  }

  @override
  bool operator ==(covariant CompanionServerSettings other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.endpoint == endpoint &&
        other.secret == secret &&
        other.port == port &&
        other.startOnLaunch == startOnLaunch;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        endpoint.hashCode ^
        secret.hashCode ^
        port.hashCode ^
        startOnLaunch.hashCode;
  }
}
