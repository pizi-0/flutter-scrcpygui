import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ScrcpyCamera {
  final String id;
  final String desc;
  final List<String> sizes;
  final List<String> fps;

  ScrcpyCamera({
    required this.id,
    required this.desc,
    required this.sizes,
    required this.fps,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'desc': desc,
      'sizes': sizes,
      'fps': fps,
    };
  }

  factory ScrcpyCamera.fromMap(Map<String, dynamic> map) {
    return ScrcpyCamera(
      id: map['id'] as String,
      desc: map['desc'] as String,
      sizes: List<String>.from((map['sizes'])),
      fps: List<String>.from(
        (map['fps']),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScrcpyCamera.fromJson(String source) =>
      ScrcpyCamera.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'id: $id, desc: $desc, sizes: $sizes, fps: $fps';
  }

  @override
  bool operator ==(covariant ScrcpyCamera other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.desc == desc &&
        listEquals(other.sizes, sizes) &&
        listEquals(other.fps, fps);
  }

  @override
  int get hashCode {
    return id.hashCode ^ desc.hashCode ^ sizes.hashCode ^ fps.hashCode;
  }
}
