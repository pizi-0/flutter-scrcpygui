// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:scrcpygui/utils/const.dart';

import '../scrcpy_enum.dart';

class SVideoOptions {
  final VideoFormat videoFormat;
  final String videoCodec;
  final String videoEncoder;
  final double resolutionScale;
  final int videoBitrate;
  final double maxFPS;
  final String displayId;
  final SVirtualDisplayOptions virtualDisplayOptions;

  SVideoOptions({
    required this.videoFormat,
    required this.videoCodec,
    required this.videoEncoder,
    required this.resolutionScale,
    required this.videoBitrate,
    required this.maxFPS,
    required this.displayId,
    required this.virtualDisplayOptions,
  });

  SVideoOptions copyWith({
    VideoFormat? videoFormat,
    String? videoCodec,
    String? videoEncoder,
    double? resolutionScale,
    int? videoBitrate,
    double? maxFPS,
    String? displayId,
    SVirtualDisplayOptions? virtualDisplayOptions,
  }) {
    return SVideoOptions(
      videoFormat: videoFormat ?? this.videoFormat,
      videoCodec: videoCodec ?? this.videoCodec,
      videoEncoder: videoEncoder ?? this.videoEncoder,
      resolutionScale: resolutionScale ?? this.resolutionScale,
      videoBitrate: videoBitrate ?? this.videoBitrate,
      maxFPS: maxFPS ?? this.maxFPS,
      displayId: displayId ?? this.displayId,
      virtualDisplayOptions:
          virtualDisplayOptions ?? this.virtualDisplayOptions,
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
      'virtualDisplayOptions': virtualDisplayOptions.toMap()
    };
  }

  factory SVideoOptions.fromMap(Map<String, dynamic> map) {
    return SVideoOptions(
      videoFormat: VideoFormat.values[map['videoFormat']],
      videoCodec: map['videoCodec'] as String,
      videoEncoder: map['videoEncoder'] as String,
      resolutionScale: map['resolutionScale'] as double,
      videoBitrate: map['videoBitrate'] as int,
      maxFPS: map['maxFPS'].toDouble(),
      displayId: map['displayId'] as String,
      virtualDisplayOptions: map['virtualDisplayOptions'] != null
          ? SVirtualDisplayOptions.fromMap(
              map['virtualDisplayOptions'] as Map<String, dynamic>)
          : defaultVdOptions,
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
        other.displayId == displayId &&
        other.virtualDisplayOptions == virtualDisplayOptions;
  }

  @override
  int get hashCode {
    return videoFormat.hashCode ^
        videoCodec.hashCode ^
        videoEncoder.hashCode ^
        resolutionScale.hashCode ^
        videoBitrate.hashCode ^
        maxFPS.hashCode ^
        displayId.hashCode ^
        virtualDisplayOptions.hashCode;
  }
}

class SVirtualDisplayOptions {
  final String resolution;
  final String dpi;
  final bool disableDecorations;
  final bool preseveContent;

  SVirtualDisplayOptions({
    required this.resolution,
    required this.dpi,
    required this.disableDecorations,
    required this.preseveContent,
  });

  SVirtualDisplayOptions copyWith({
    String? resolution,
    String? dpi,
    bool? disableDecorations,
    bool? preseveContent,
  }) {
    return SVirtualDisplayOptions(
      resolution: resolution ?? this.resolution,
      dpi: dpi ?? this.dpi,
      disableDecorations: disableDecorations ?? this.disableDecorations,
      preseveContent: preseveContent ?? this.preseveContent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'resolution': resolution,
      'dpi': dpi,
      'disableDecorations': disableDecorations,
      'preseveContent': preseveContent,
    };
  }

  factory SVirtualDisplayOptions.fromMap(Map<String, dynamic> map) {
    return SVirtualDisplayOptions(
      resolution:
          map['resolution'] != null ? map['resolution'] as String : DEFAULT,
      dpi: map['dpi'] != null ? map['dpi'] as String : DEFAULT,
      disableDecorations: map['disableDecorations'] as bool,
      preseveContent: map['preseveContent'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SVirtualDisplayOptions.fromJson(String source) =>
      SVirtualDisplayOptions.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SVirtualDisplayOptions(resolution: $resolution, dpi: $dpi, disableDecorations: $disableDecorations, preseveContent: $preseveContent)';
  }

  @override
  bool operator ==(covariant SVirtualDisplayOptions other) {
    if (identical(this, other)) return true;

    return other.resolution == resolution &&
        other.dpi == dpi &&
        other.disableDecorations == disableDecorations &&
        other.preseveContent == preseveContent;
  }

  @override
  int get hashCode {
    return resolution.hashCode ^
        dpi.hashCode ^
        disableDecorations.hashCode ^
        preseveContent.hashCode;
  }
}
