// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../scrcpy_enum.dart';

class SControlOptions {
  final MouseMode mouseMode;
  final bool mouseNoHover;
  final KeyboardMode keyboardMode;
  final bool keyboardDisableRepeat;
  final GamepadMode gamepadMode;

  SControlOptions({
    required this.mouseMode,
    required this.mouseNoHover,
    required this.keyboardMode,
    required this.keyboardDisableRepeat,
    required this.gamepadMode,
  });

  SControlOptions copyWith({
    MouseMode? mouseMode,
    bool? mouseNoHover,
    KeyboardMode? keyboardMode,
    bool? keyboardDisableRepeat,
    GamepadMode? gamepadMode,
  }) {
    return SControlOptions(
      mouseMode: mouseMode ?? this.mouseMode,
      mouseNoHover: mouseNoHover ?? this.mouseNoHover,
      keyboardMode: keyboardMode ?? this.keyboardMode,
      keyboardDisableRepeat:
          keyboardDisableRepeat ?? this.keyboardDisableRepeat,
      gamepadMode: gamepadMode ?? this.gamepadMode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mouseMode': MouseMode.values.indexOf(mouseMode),
      'mouseNoHover': mouseNoHover,
      'keyboardMode': KeyboardMode.values.indexOf(keyboardMode),
      'keyboardDisableRepeat': keyboardDisableRepeat,
      'gamepadMode': GamepadMode.values.indexOf(gamepadMode),
    };
  }

  factory SControlOptions.fromMap(Map<String, dynamic> map) {
    return SControlOptions(
      mouseMode: MouseMode.values[map['mouseMode']],
      mouseNoHover: map['mouseNoHover'] as bool,
      keyboardMode: KeyboardMode.values[map['keyboardMode']],
      keyboardDisableRepeat: map['keyboardDisableRepeat'] as bool,
      gamepadMode: GamepadMode.values[map['gamepadMode']],
    );
  }

  String toJson() => json.encode(toMap());

  factory SControlOptions.fromJson(String source) =>
      SControlOptions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SControlOptions(mouseMode: $mouseMode, mouseNoHover: $mouseNoHover, keyboardMode: $keyboardMode, gamepadMode: $gamepadMode)';
  }

  @override
  bool operator ==(covariant SControlOptions other) {
    if (identical(this, other)) return true;

    return other.mouseMode == mouseMode &&
        other.mouseNoHover == mouseNoHover &&
        other.keyboardMode == keyboardMode &&
        other.gamepadMode == gamepadMode;
  }

  @override
  int get hashCode {
    return mouseMode.hashCode ^
        mouseNoHover.hashCode ^
        keyboardMode.hashCode ^
        gamepadMode.hashCode;
  }
}

final defaultControlOptions = SControlOptions(
  mouseMode: MouseMode.sdk,
  mouseNoHover: false,
  keyboardMode: KeyboardMode.sdk,
  keyboardDisableRepeat: false,
  gamepadMode: GamepadMode.disabled,
);
