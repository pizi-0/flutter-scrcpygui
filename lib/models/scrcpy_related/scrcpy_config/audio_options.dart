// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../scrcpy_enum.dart';

class SAudioOptions {
  final AudioFormat audioFormat;
  final String audioCodec;
  final String audioEncoder;
  final AudioSource audioSource;
  final bool duplicateAudio;
  final int audioBitrate;

  SAudioOptions({
    required this.audioFormat,
    required this.audioCodec,
    required this.audioEncoder,
    required this.audioSource,
    required this.duplicateAudio,
    required this.audioBitrate,
  });

  SAudioOptions copyWith({
    AudioFormat? audioFormat,
    String? audioCodec,
    String? audioEncoder,
    AudioSource? audioSource,
    bool? duplicateAudio,
    int? audioBitrate,
  }) {
    return SAudioOptions(
      audioFormat: audioFormat ?? this.audioFormat,
      audioCodec: audioCodec ?? this.audioCodec,
      audioEncoder: audioEncoder ?? this.audioEncoder,
      audioSource: audioSource ?? this.audioSource,
      duplicateAudio: duplicateAudio ?? this.duplicateAudio,
      audioBitrate: audioBitrate ?? this.audioBitrate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'audioFormat': AudioFormat.values.indexOf(audioFormat),
      'audioCodec': audioCodec,
      'audioEncoder': audioEncoder,
      'audioSource': AudioSource.values.indexOf(audioSource),
      'duplicateAudio': duplicateAudio,
      'audioBitrate': audioBitrate,
    };
  }

  factory SAudioOptions.fromMap(Map<String, dynamic> map) {
    return SAudioOptions(
      audioFormat: AudioFormat.values[map['audioFormat']],
      audioCodec: map['audioCodec'] as String,
      audioEncoder: map['audioEncoder'] as String,
      audioSource: AudioSource.values[map['audioSource']],
      duplicateAudio: map['duplicateAudio'] as bool,
      audioBitrate: map['audioBitrate'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SAudioOptions.fromJson(String source) =>
      SAudioOptions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '[Audio format: ${audioFormat.value}, Audio codec: $audioCodec, Audio encoder: $audioEncoder, Audio source: ${audioSource.value},${duplicateAudio ? ' Duplicate audio: $duplicateAudio,' : ''} Audio bitrate: ${audioBitrate}K]';
  }

  @override
  bool operator ==(covariant SAudioOptions other) {
    if (identical(this, other)) return true;

    return other.audioFormat == audioFormat &&
        other.audioCodec == audioCodec &&
        other.audioEncoder == audioEncoder &&
        other.audioSource == audioSource &&
        other.duplicateAudio == duplicateAudio &&
        other.audioBitrate == audioBitrate;
  }

  @override
  int get hashCode {
    return audioFormat.hashCode ^
        audioCodec.hashCode ^
        audioEncoder.hashCode ^
        audioSource.hashCode ^
        duplicateAudio.hashCode ^
        audioBitrate.hashCode;
  }
}
