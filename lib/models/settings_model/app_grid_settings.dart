// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppGridSettings {
  final double gridExtent;
  final bool hideName;
  final String? lastUsedConfig;

  AppGridSettings(
      {required this.gridExtent, required this.hideName, this.lastUsedConfig});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gridExtent': gridExtent,
      'hideName': hideName,
      'lastUsedConfig': lastUsedConfig,
    };
  }

  factory AppGridSettings.fromMap(Map<String, dynamic> map) {
    return AppGridSettings(
      gridExtent: map['gridExtent'] as double,
      hideName: map['hideName'] as bool,
      lastUsedConfig: map['lastUsedConfig'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppGridSettings.fromJson(String source) =>
      AppGridSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  AppGridSettings copyWith({
    double? gridExtent,
    bool? hideName,
    String? lastUsedConfig,
  }) {
    return AppGridSettings(
      gridExtent: gridExtent ?? this.gridExtent,
      hideName: hideName ?? this.hideName,
      lastUsedConfig: lastUsedConfig ?? this.lastUsedConfig,
    );
  }
}
