// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppBehaviour {
  final bool killNoWindowInstance;
  final bool traySupport;
  final bool toastEnabled;

  AppBehaviour({
    required this.killNoWindowInstance,
    required this.traySupport,
    required this.toastEnabled,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'killNoWindowInstance': killNoWindowInstance,
      'traySupport': traySupport,
      'toastEnabled': toastEnabled,
    };
  }

  factory AppBehaviour.fromMap(Map<String, dynamic> map) {
    return AppBehaviour(
      killNoWindowInstance: map['killNoWindowInstance'] ?? true,
      traySupport: map['traySupport'] ?? true,
      toastEnabled: map['toastEnabled'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppBehaviour.fromJson(String source) =>
      AppBehaviour.fromMap(json.decode(source) as Map<String, dynamic>);

  AppBehaviour copyWith({
    bool? killNoWindowInstance,
    bool? traySupport,
    bool? toastEnabled,
  }) {
    return AppBehaviour(
      killNoWindowInstance: killNoWindowInstance ?? this.killNoWindowInstance,
      traySupport: traySupport ?? this.traySupport,
      toastEnabled: toastEnabled ?? this.toastEnabled,
    );
  }

  @override
  String toString() =>
      'AppBehaviour(killNoWindowInstance: $killNoWindowInstance, traySupport: $traySupport, toastEnabled: $toastEnabled)';

  @override
  bool operator ==(covariant AppBehaviour other) {
    if (identical(this, other)) return true;

    return other.killNoWindowInstance == killNoWindowInstance &&
        other.traySupport == traySupport &&
        other.toastEnabled == toastEnabled;
  }

  @override
  int get hashCode =>
      killNoWindowInstance.hashCode ^
      traySupport.hashCode ^
      toastEnabled.hashCode;
}
