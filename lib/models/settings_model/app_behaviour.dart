// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppBehaviour {
  final bool killNoWindowInstance;
  final bool traySupport;

  AppBehaviour({
    required this.killNoWindowInstance,
    required this.traySupport,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'killNoWindowInstance': killNoWindowInstance,
      'traySupport': traySupport,
    };
  }

  factory AppBehaviour.fromMap(Map<String, dynamic> map) {
    return AppBehaviour(
      killNoWindowInstance: map['killNoWindowInstance'] as bool,
      traySupport: map['traySupport'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppBehaviour.fromJson(String source) =>
      AppBehaviour.fromMap(json.decode(source) as Map<String, dynamic>);

  AppBehaviour copyWith({
    bool? killNoWindowInstance,
    bool? traySupport,
  }) {
    return AppBehaviour(
      killNoWindowInstance: killNoWindowInstance ?? this.killNoWindowInstance,
      traySupport: traySupport ?? this.traySupport,
    );
  }

  @override
  String toString() =>
      'AppBehaviour(killNoWindowInstance: $killNoWindowInstance, traySupport: $traySupport)';

  @override
  bool operator ==(covariant AppBehaviour other) {
    if (identical(this, other)) return true;

    return other.killNoWindowInstance == killNoWindowInstance &&
        other.traySupport == traySupport;
  }

  @override
  int get hashCode => killNoWindowInstance.hashCode ^ traySupport.hashCode;
}
