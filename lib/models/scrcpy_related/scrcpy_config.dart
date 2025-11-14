// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/app_options.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/audio_options.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/control_options.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/device_options.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/video_options.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config_tags.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';

import 'scrcpy_config/window_options.dart';

class ScrcpyConfig {
  final String id;
  final String configName;

  final ScrcpyMode scrcpyMode;
  final bool isRecording;

  final SVideoOptions videoOptions;
  final SAudioOptions audioOptions;
  final SAppOptions appOptions;
  final SDeviceOptions deviceOptions;
  final SWindowOptions windowOptions;
  final SControlOptions controlOptions;
  final String additionalFlags;

  //tags are auto generated
  List<ConfigTag> tags;

  final String? savePath;
  ScrcpyConfig({
    required this.id,
    required this.configName,
    required this.scrcpyMode,
    required this.isRecording,
    required this.videoOptions,
    required this.audioOptions,
    required this.appOptions,
    required this.deviceOptions,
    required this.windowOptions,
    required this.controlOptions,
    required this.additionalFlags,
    this.savePath,
    this.tags = const [],
  }) {
    tags = getTags();
  }

  List<ConfigTag> getTags() {
    List<ConfigTag> tags = [];
    if (isRecording) {
      tags.add(ConfigTag.recording);
    } else {
      tags.add(ConfigTag.mirror);
    }

    if (scrcpyMode == ScrcpyMode.videoOnly) {
      tags.add(ConfigTag.videoOnly);
    }

    if (scrcpyMode == ScrcpyMode.audioOnly) {
      tags.add(ConfigTag.audioOnly);
    }

    if (videoOptions.displayId == 'new') {
      tags.add(ConfigTag.virtualDisplay);
    }

    if (appOptions.selectedApp != null) {
      tags.add(ConfigTag.withApp);
    }

    if (id == 'default-mirror' || id == 'default-record') {
      tags.add(ConfigTag.defaultConfig);
    } else {
      tags.add(ConfigTag.customConfig);
    }

    return tags;
  }

  ScrcpyConfig copyWith({
    String? id,
    String? configName,
    ScrcpyMode? scrcpyMode,
    bool? isRecording,
    SVideoOptions? videoOptions,
    SAudioOptions? audioOptions,
    SAppOptions? appOptions,
    SDeviceOptions? deviceOptions,
    SWindowOptions? windowOptions,
    SControlOptions? controlOptions,
    String? additionalFlags,
    String? savePath,
  }) {
    return ScrcpyConfig(
      id: id ?? this.id,
      configName: configName ?? this.configName,
      scrcpyMode: scrcpyMode ?? this.scrcpyMode,
      isRecording: isRecording ?? this.isRecording,
      videoOptions: videoOptions ?? this.videoOptions,
      audioOptions: audioOptions ?? this.audioOptions,
      appOptions: appOptions ?? this.appOptions,
      deviceOptions: deviceOptions ?? this.deviceOptions,
      windowOptions: windowOptions ?? this.windowOptions,
      controlOptions: controlOptions ?? this.controlOptions,
      additionalFlags: additionalFlags ?? this.additionalFlags,
      savePath: savePath ?? this.savePath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'configName': configName,
      'scrcpyMode': ScrcpyMode.values.indexOf(scrcpyMode),
      'isRecording': isRecording,
      'videoOptions': videoOptions.toMap(),
      'audioOptions': audioOptions.toMap(),
      'appOptions': appOptions.toMap(),
      'deviceOptions': deviceOptions.toMap(),
      'windowOptions': windowOptions.toMap(),
      'controlOptions': controlOptions.toMap(),
      'additionalFlags': additionalFlags,
      'savePath': savePath,
    };
  }

  factory ScrcpyConfig.fromMap(Map<String, dynamic> map) {
    return ScrcpyConfig(
      id: map['id'],
      configName: map['configName'] as String,
      scrcpyMode: ScrcpyMode.values[map['scrcpyMode']],
      isRecording: map['isRecording'] as bool,
      videoOptions:
          SVideoOptions.fromMap(map['videoOptions'] as Map<String, dynamic>),
      audioOptions:
          SAudioOptions.fromMap(map['audioOptions'] as Map<String, dynamic>),
      appOptions: map['appOptions'] != null
          ? SAppOptions.fromMap(map['appOptions'] as Map<String, dynamic>)
          : SAppOptions(forceClose: false),
      deviceOptions:
          SDeviceOptions.fromMap(map['deviceOptions'] as Map<String, dynamic>),
      windowOptions:
          SWindowOptions.fromMap(map['windowOptions'] as Map<String, dynamic>),
      controlOptions: map['controlOptions'] != null
          ? SControlOptions.fromMap(
              map['controlOptions'] as Map<String, dynamic>)
          : defaultControlOptions,
      additionalFlags: map['additionalFlags'],
      savePath: map['savePath'] != null ? map['savePath'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScrcpyConfig.fromJson(String source) =>
      ScrcpyConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Name: $configName, Mode: $scrcpyMode,${isRecording ? ' Recording: $isRecording,' : ''} Video options: $videoOptions, Audio options: $audioOptions, Device options: $deviceOptions, Window options: $windowOptions,${savePath == null ? '' : ' Save path: $savePath,'} Additional flags: [ $additionalFlags ]';
  }

  @override
  bool operator ==(covariant ScrcpyConfig other) {
    if (identical(this, other)) return true;

    return other.configName == configName &&
        other.scrcpyMode == scrcpyMode &&
        other.isRecording == isRecording &&
        other.videoOptions == videoOptions &&
        other.audioOptions == audioOptions &&
        other.appOptions == appOptions &&
        other.deviceOptions == deviceOptions &&
        other.windowOptions == windowOptions &&
        other.additionalFlags == additionalFlags &&
        other.savePath == savePath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        scrcpyMode.hashCode ^
        isRecording.hashCode ^
        videoOptions.hashCode ^
        audioOptions.hashCode ^
        appOptions.hashCode ^
        deviceOptions.hashCode ^
        windowOptions.hashCode ^
        additionalFlags.hashCode ^
        savePath.hashCode;
  }

  bool isSimilarTo(ScrcpyConfig other) {
    return other.scrcpyMode == scrcpyMode &&
        other.isRecording == isRecording &&
        other.videoOptions == videoOptions &&
        other.audioOptions == audioOptions &&
        other.appOptions == appOptions &&
        other.deviceOptions == deviceOptions &&
        other.windowOptions == windowOptions &&
        other.additionalFlags == additionalFlags &&
        other.savePath == savePath;
  }
}
