// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hotkey_manager/hotkey_manager.dart';

import 'package:scrcpygui/models/settings_model/shortcut_extra.dart';

class Shortcut {
  final String id;
  final HotKey hotKey;
  final ShortcutExtra? extra;

  Shortcut({required this.id, required this.hotKey, this.extra});
  Shortcut copyWith({
    HotKey? hotKey,
    ShortcutExtra? extra,
  }) {
    return Shortcut(
      id: id,
      hotKey: hotKey ?? this.hotKey,
      extra: extra ?? this.extra,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'hotKey': hotKey.toJson(),
      'extra': extra?.toMap(),
    };
  }

  factory Shortcut.fromMap(Map<String, dynamic> map) {
    return Shortcut(
      id: map['id'] as String,
      hotKey: HotKey.fromJson(map['hotKey'] as Map<String, dynamic>),
      extra: map['extra'] != null
          ? ShortcutExtra.fromMap(map['extra'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Shortcut.fromJson(String source) =>
      Shortcut.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Shortcut other) {
    if (identical(this, other)) return true;

    return other.id == id && other.hotKey == hotKey && other.extra == extra;
  }

  @override
  int get hashCode => id.hashCode ^ hotKey.hashCode ^ extra.hashCode;
}
