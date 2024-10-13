// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:scrcpygui/models/settings_model/app_theme.dart';

import 'app_behaviour.dart';

class AppSettings {
  final AppBehaviour behaviour;
  final AppTheme looks;

  AppSettings({
    required this.behaviour,
    required this.looks,
  });

  AppSettings copyWith({
    AppBehaviour? behaviour,
    AppTheme? looks,
  }) {
    return AppSettings(
      behaviour: behaviour ?? this.behaviour,
      looks: looks ?? this.looks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'behaviour': behaviour.toMap(),
      'looks': looks.toMap(),
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      behaviour: AppBehaviour.fromMap(map['behaviour'] as Map<String, dynamic>),
      looks: AppTheme.fromMap(map['looks'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppSettings.fromJson(String source) =>
      AppSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AppSettings(behaviour: $behaviour, looks: $looks)';

  @override
  bool operator ==(covariant AppSettings other) {
    if (identical(this, other)) return true;

    return other.behaviour == behaviour && other.looks == looks;
  }

  @override
  int get hashCode => behaviour.hashCode ^ looks.hashCode;
}
