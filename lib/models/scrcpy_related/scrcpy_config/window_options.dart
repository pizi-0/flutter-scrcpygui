// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SWindowOptions {
  final bool noWindow;
  final bool noBorder;
  final bool alwaysOntop;
  final int timeLimit;

  SWindowOptions({
    required this.noWindow,
    required this.noBorder,
    required this.alwaysOntop,
    required this.timeLimit,
  });

  SWindowOptions copyWith({
    bool? noWindow,
    bool? noBorder,
    bool? alwaysOntop,
    int? timeLimit,
  }) {
    return SWindowOptions(
      noWindow: noWindow ?? this.noWindow,
      noBorder: noBorder ?? this.noBorder,
      alwaysOntop: alwaysOntop ?? this.alwaysOntop,
      timeLimit: timeLimit ?? this.timeLimit,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'noWindow': noWindow,
      'noBorder': noBorder,
      'alwaysOntop': alwaysOntop,
      'timeLimit': timeLimit,
    };
  }

  factory SWindowOptions.fromMap(Map<String, dynamic> map) {
    return SWindowOptions(
      noWindow: map['noWindow'] as bool,
      noBorder: map['noBorder'] as bool,
      alwaysOntop: map['alwaysOntop'] as bool,
      timeLimit: map['timeLimit'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SWindowOptions.fromJson(String source) =>
      SWindowOptions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '[${noWindow ? 'No window: $noWindow, ' : ''}${noBorder ? 'No border: $noBorder, ' : ''}${alwaysOntop ? 'Always on top: $alwaysOntop, ' : ''}${timeLimit == 0 ? '' : 'Time limit: $timeLimit'}]';
  }

  @override
  bool operator ==(covariant SWindowOptions other) {
    if (identical(this, other)) return true;

    return other.noWindow == noWindow &&
        other.noBorder == noBorder &&
        other.alwaysOntop == alwaysOntop &&
        other.timeLimit == timeLimit;
  }

  @override
  int get hashCode {
    return noWindow.hashCode ^
        noBorder.hashCode ^
        alwaysOntop.hashCode ^
        timeLimit.hashCode;
  }
}
