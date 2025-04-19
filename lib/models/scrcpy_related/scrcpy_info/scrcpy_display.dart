// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ScrcpyDisplay {
  final String id;
  final String resolution;

  ScrcpyDisplay({required this.id, required this.resolution});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'resolution': resolution,
    };
  }

  factory ScrcpyDisplay.fromMap(Map<String, dynamic> map) {
    return ScrcpyDisplay(
      id: map['id'] as String,
      resolution: map['resolution'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScrcpyDisplay.fromJson(String source) =>
      ScrcpyDisplay.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'id: $id, resolution: $resolution';

  @override
  bool operator ==(covariant ScrcpyDisplay other) {
    if (identical(this, other)) return true;

    return other.id == id && other.resolution == resolution;
  }

  @override
  int get hashCode => id.hashCode ^ resolution.hashCode;
}
