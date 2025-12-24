import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ShortcutExtra {
  final String? deviceId;
  final String? configId;

  ShortcutExtra({this.deviceId, this.configId});

  ShortcutExtra copyWith({
    String? deviceId,
    String? configId,
  }) {
    return ShortcutExtra(
      deviceId: deviceId ?? this.deviceId,
      configId: configId ?? this.configId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deviceId': deviceId,
      'configId': configId,
    };
  }

  factory ShortcutExtra.fromMap(Map<String, dynamic> map) {
    return ShortcutExtra(
      deviceId: map['deviceId'] != null ? map['deviceId'] as String : null,
      configId: map['configId'] != null ? map['configId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShortcutExtra.fromJson(String source) =>
      ShortcutExtra.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant ShortcutExtra other) {
    if (identical(this, other)) return true;

    return other.deviceId == deviceId && other.configId == configId;
  }

  @override
  int get hashCode => deviceId.hashCode ^ configId.hashCode;
}
