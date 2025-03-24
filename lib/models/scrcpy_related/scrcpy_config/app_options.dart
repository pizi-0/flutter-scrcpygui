// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';

class SAppOptions {
  final ScrcpyApp? selectedApp;
  final bool forceClose;

  SAppOptions({
    this.selectedApp,
    required this.forceClose,
  });

  SAppOptions copyWith({
    ScrcpyApp? selectedApp,
    bool? forceClose,
  }) {
    return SAppOptions(
      selectedApp: selectedApp ?? this.selectedApp,
      forceClose: forceClose ?? this.forceClose,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'selectedApp': selectedApp?.toMap(),
      'forceClose': forceClose,
    };
  }

  factory SAppOptions.fromMap(Map<String, dynamic> map) {
    return SAppOptions(
      selectedApp: map['selectedApp'] != null
          ? ScrcpyApp.fromMap(map['selectedApp'] as Map<String, dynamic>)
          : null,
      forceClose: map['forceClose'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SAppOptions.fromJson(String source) =>
      SAppOptions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SAppOptions(selectedApp: $selectedApp, forceClose: $forceClose)';

  @override
  bool operator ==(covariant SAppOptions other) {
    if (identical(this, other)) return true;

    return other.selectedApp == selectedApp && other.forceClose == forceClose;
  }

  @override
  int get hashCode => selectedApp.hashCode ^ forceClose.hashCode;
}
