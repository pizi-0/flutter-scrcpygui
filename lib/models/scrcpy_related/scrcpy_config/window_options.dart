// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/position_and_size.dart';

class SWindowOptions {
  final bool noWindow;
  final bool noBorder;
  final bool alwaysOntop;
  final int timeLimit;
  final ScrcpyPosition? position;
  final ScrcpySize? size;

  SWindowOptions({
    required this.noWindow,
    required this.noBorder,
    required this.alwaysOntop,
    required this.timeLimit,
    this.position,
    this.size,
  });

  SWindowOptions copyWith({
    bool? noWindow,
    bool? noBorder,
    bool? alwaysOntop,
    int? timeLimit,
    ScrcpyPosition? position,
    ScrcpySize? size,
  }) {
    return SWindowOptions(
      noWindow: noWindow ?? this.noWindow,
      noBorder: noBorder ?? this.noBorder,
      alwaysOntop: alwaysOntop ?? this.alwaysOntop,
      timeLimit: timeLimit ?? this.timeLimit,
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'noWindow': noWindow,
      'noBorder': noBorder,
      'alwaysOntop': alwaysOntop,
      'timeLimit': timeLimit,
      'position': position?.toMap(),
      'size': size?.toMap(),
    };
  }

  factory SWindowOptions.fromMap(Map<String, dynamic> map) {
    return SWindowOptions(
      noWindow: map['noWindow'] as bool,
      noBorder: map['noBorder'] as bool,
      alwaysOntop: map['alwaysOntop'] as bool,
      timeLimit: map['timeLimit'] as int,
      position: map['position'] == null
          ? ScrcpyPosition()
          : ScrcpyPosition.fromMap(map['position'] as Map<String, dynamic>),
      size: map['size'] == null
          ? ScrcpySize()
          : ScrcpySize.fromMap(map['size'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SWindowOptions.fromJson(String source) =>
      SWindowOptions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SWindowOptions(noWindow: $noWindow, noBorder: $noBorder, alwaysOntop: $alwaysOntop, timeLimit: $timeLimit, position: $position, size: $size)';
  }

  @override
  bool operator ==(covariant SWindowOptions other) {
    if (identical(this, other)) return true;

    return other.noWindow == noWindow &&
        other.noBorder == noBorder &&
        other.alwaysOntop == alwaysOntop &&
        other.timeLimit == timeLimit &&
        other.position == position &&
        other.size == size;
  }

  @override
  int get hashCode {
    return noWindow.hashCode ^
        noBorder.hashCode ^
        alwaysOntop.hashCode ^
        timeLimit.hashCode ^
        position.hashCode ^
        size.hashCode;
  }
}
