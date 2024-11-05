import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class VideoEncoder {
  final String codec;
  final List<String> encoder;

  VideoEncoder({required this.codec, required this.encoder});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codec': codec,
      'encoder': encoder,
    };
  }

  factory VideoEncoder.fromMap(Map<String, dynamic> map) {
    return VideoEncoder(
      codec: map['codec'] as String,
      encoder: List<String>.from(
        (map['encoder']),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoEncoder.fromJson(String source) =>
      VideoEncoder.fromMap(json.decode(source) as Map<String, dynamic>);

  VideoEncoder copyWith({
    String? codec,
    List<String>? encoder,
  }) {
    return VideoEncoder(
      codec: codec ?? this.codec,
      encoder: encoder ?? this.encoder,
    );
  }

  @override
  String toString() => 'codec: $codec, encoder: $encoder';
}

class AudioEncoder {
  final String codec;
  final List<String> encoder;

  AudioEncoder({required this.codec, required this.encoder});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codec': codec,
      'encoder': encoder,
    };
  }

  factory AudioEncoder.fromMap(Map<String, dynamic> map) {
    return AudioEncoder(
      codec: map['codec'] as String,
      encoder: List<String>.from(
        (map['encoder']),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AudioEncoder.fromJson(String source) =>
      AudioEncoder.fromMap(json.decode(source) as Map<String, dynamic>);

  AudioEncoder copyWith({
    String? codec,
    List<String>? encoder,
  }) {
    return AudioEncoder(
      codec: codec ?? this.codec,
      encoder: encoder ?? this.encoder,
    );
  }

  @override
  String toString() => 'codec: $codec, encoder: $encoder';
}
