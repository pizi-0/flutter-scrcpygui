// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ScrcpyPosition {
  final int? x;
  final int? y;
  ScrcpyPosition({
    this.x,
    this.y,
  });

  ScrcpyPosition copyWith({
    int? x,
    int? y,
  }) {
    return ScrcpyPosition(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'x': x,
      'y': y,
    };
  }

  factory ScrcpyPosition.fromMap(Map<String, dynamic> map) {
    return ScrcpyPosition(
      x: map['x'] != null ? map['x'] as int : null,
      y: map['y'] != null ? map['y'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScrcpyPosition.fromJson(String source) =>
      ScrcpyPosition.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ScrcpyPosition(x: $x, y: $y)';

  @override
  bool operator ==(covariant ScrcpyPosition other) {
    if (identical(this, other)) return true;

    return other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class ScrcpySize {
  final int? width;
  final int? height;
  ScrcpySize({
    this.width,
    this.height,
  });

  ScrcpySize copyWith({
    int? width,
    int? height,
  }) {
    return ScrcpySize(
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'width': width,
      'height': height,
    };
  }

  factory ScrcpySize.fromMap(Map<String, dynamic> map) {
    return ScrcpySize(
      width: map['width'] != null ? map['width'] as int : null,
      height: map['height'] != null ? map['height'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScrcpySize.fromJson(String source) =>
      ScrcpySize.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ScrcpySize(width: $width, height: $height)';

  @override
  bool operator ==(covariant ScrcpySize other) {
    if (identical(this, other)) return true;

    return other.width == width && other.height == height;
  }

  @override
  int get hashCode => width.hashCode ^ height.hashCode;
}
