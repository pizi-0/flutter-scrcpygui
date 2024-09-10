// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../scrcpy_enum.dart';

class SVideoOptions {
  final VideoFormat videoFormat;
  final String videoCodec;
  final String videoEncoder;
  final double resolutionScale;
  final int videoBitrate;
  final int maxFPS;
  final int displayId;

  SVideoOptions({
    required this.videoFormat,
    required this.videoCodec,
    required this.videoEncoder,
    required this.resolutionScale,
    required this.videoBitrate,
    required this.maxFPS,
    required this.displayId,
  });

  SVideoOptions copyWith({
    VideoFormat? videoFormat,
    String? videoCodec,
    String? videoEncoder,
    double? resolutionScale,
    int? videoBitrate,
    int? maxFPS,
    int? displayId,
  }) {
    return SVideoOptions(
      videoFormat: videoFormat ?? this.videoFormat,
      videoCodec: videoCodec ?? this.videoCodec,
      videoEncoder: videoEncoder ?? this.videoEncoder,
      resolutionScale: resolutionScale ?? this.resolutionScale,
      videoBitrate: videoBitrate ?? this.videoBitrate,
      maxFPS: maxFPS ?? this.maxFPS,
      displayId: displayId ?? this.displayId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'videoFormat': VideoFormat.values.indexOf(videoFormat),
      'videoCodec': videoCodec,
      'videoEncoder': videoEncoder,
      'resolutionScale': resolutionScale,
      'videoBitrate': videoBitrate,
      'maxFPS': maxFPS,
      'displayId': displayId,
    };
  }

  factory SVideoOptions.fromMap(Map<String, dynamic> map) {
    return SVideoOptions(
      videoFormat: VideoFormat.values[map['videoFormat']],
      videoCodec: map['videoCodec'] as String,
      videoEncoder: map['videoEncoder'] as String,
      resolutionScale: map['resolutionScale'] as double,
      videoBitrate: map['videoBitrate'] as int,
      maxFPS: map['maxFPS'] as int,
      displayId: map['displayId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SVideoOptions.fromJson(String source) =>
      SVideoOptions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '[Video format: ${videoFormat.value}, Video codec: $videoCodec, Video encoder: $videoEncoder, Resolution scale: $resolutionScale, Video bitrate: ${videoBitrate}M,${maxFPS == 0 ? '' : ' Max FPS: ${maxFPS}fps,'} Display id: $displayId]';
  }

  @override
  bool operator ==(covariant SVideoOptions other) {
    if (identical(this, other)) return true;

    return other.videoFormat == videoFormat &&
        other.videoCodec == videoCodec &&
        other.videoEncoder == videoEncoder &&
        other.resolutionScale == resolutionScale &&
        other.videoBitrate == videoBitrate &&
        other.maxFPS == maxFPS &&
        other.displayId == displayId;
  }

  @override
  int get hashCode {
    return videoFormat.hashCode ^
        videoCodec.hashCode ^
        videoEncoder.hashCode ^
        resolutionScale.hashCode ^
        videoBitrate.hashCode ^
        maxFPS.hashCode ^
        displayId.hashCode;
  }
}
