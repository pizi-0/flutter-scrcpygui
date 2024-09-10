// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SDeviceOptions {
  final bool turnOffDisplay;
  final bool stayAwake;
  final bool showTouches;
  final bool noScreensaver;
  final bool offScreenOnClose;

  SDeviceOptions({
    required this.turnOffDisplay,
    required this.stayAwake,
    required this.showTouches,
    required this.noScreensaver,
    required this.offScreenOnClose,
  });

  SDeviceOptions copyWith({
    bool? turnOffDisplay,
    bool? stayAwake,
    bool? showTouches,
    bool? noScreensaver,
    bool? offScreenOnClose,
  }) {
    return SDeviceOptions(
      turnOffDisplay: turnOffDisplay ?? this.turnOffDisplay,
      stayAwake: stayAwake ?? this.stayAwake,
      showTouches: showTouches ?? this.showTouches,
      noScreensaver: noScreensaver ?? this.noScreensaver,
      offScreenOnClose: offScreenOnClose ?? this.offScreenOnClose,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'turnOffDisplay': turnOffDisplay,
      'stayAwake': stayAwake,
      'showTouches': showTouches,
      'noScreensaver': noScreensaver,
      'offScreenOnClose': offScreenOnClose,
    };
  }

  factory SDeviceOptions.fromMap(Map<String, dynamic> map) {
    return SDeviceOptions(
      turnOffDisplay: map['turnOffDisplay'] as bool,
      stayAwake: map['stayAwake'] as bool,
      showTouches: map['showTouches'] as bool,
      noScreensaver: map['noScreensaver'] as bool,
      offScreenOnClose: map['offScreenOnClose'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SDeviceOptions.fromJson(String source) =>
      SDeviceOptions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '[${turnOffDisplay ? 'Turn off display: $turnOffDisplay, ' : ''}${stayAwake ? 'StayAwake: $stayAwake, ' : ''}${showTouches ? 'Show touches: $showTouches, ' : ''}${noScreensaver ? 'No screensaver: $noScreensaver, ' : ''}${offScreenOnClose ? 'Off screen on close: $offScreenOnClose' : ''}]';
  }

  @override
  bool operator ==(covariant SDeviceOptions other) {
    if (identical(this, other)) return true;

    return other.turnOffDisplay == turnOffDisplay &&
        other.stayAwake == stayAwake &&
        other.showTouches == showTouches &&
        other.noScreensaver == noScreensaver &&
        other.offScreenOnClose == offScreenOnClose;
  }

  @override
  int get hashCode {
    return turnOffDisplay.hashCode ^
        stayAwake.hashCode ^
        showTouches.hashCode ^
        noScreensaver.hashCode ^
        offScreenOnClose.hashCode;
  }
}
