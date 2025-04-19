// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';

import 'scrcpy_camera.dart';
import 'scrcpy_display.dart';
import 'scrcpy_encoder.dart';

class ScrcpyInfo {
  final AdbDevices device;
  final String buildVersion;
  final List<ScrcpyCamera> cameras;
  final List<ScrcpyDisplay> displays;
  final List<VideoEncoder> videoEncoders;
  final List<AudioEncoder> audioEncoder;
  List<ScrcpyApp>? appList;

  ScrcpyInfo({
    required this.device,
    required this.buildVersion,
    required this.cameras,
    required this.displays,
    required this.videoEncoders,
    required this.audioEncoder,
    this.appList,
  }) {
    appList = appList ?? [];
  }

  ScrcpyInfo copyWith({
    AdbDevices? device,
    String? buildVersion,
    List<ScrcpyCamera>? cameras,
    List<ScrcpyDisplay>? displays,
    List<VideoEncoder>? videoEncoders,
    List<AudioEncoder>? audioEncoder,
    List<ScrcpyApp>? appList,
  }) {
    return ScrcpyInfo(
      device: device ?? this.device,
      buildVersion: buildVersion ?? this.buildVersion,
      cameras: cameras ?? this.cameras,
      displays: displays ?? this.displays,
      videoEncoders: videoEncoders ?? this.videoEncoders,
      audioEncoder: audioEncoder ?? this.audioEncoder,
      appList: appList ?? this.appList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'device': device.toMap(),
      'buildVersion': buildVersion,
      'cameras': cameras.map((x) => x.toMap()).toList(),
      'displays': displays.map((x) => x.toMap()).toList(),
      'videoEncoders': videoEncoders.map((x) => x.toMap()).toList(),
      'audioEncoder': audioEncoder.map((x) => x.toMap()).toList(),
      'appList': (appList ?? []).map((x) => x.toMap()).toList(),
    };
  }

  factory ScrcpyInfo.fromMap(Map<String, dynamic> map) {
    return ScrcpyInfo(
      device: AdbDevices.fromMap(map['device'] as Map<String, dynamic>),
      buildVersion: map['buildVersion'] as String,
      cameras: List<ScrcpyCamera>.from(
        (map['cameras']).map<ScrcpyCamera>(
          (x) => ScrcpyCamera.fromMap(x as Map<String, dynamic>),
        ),
      ),
      displays: List<ScrcpyDisplay>.from(
        (map['displays']).map<ScrcpyDisplay>(
          (x) => ScrcpyDisplay.fromMap(x as Map<String, dynamic>),
        ),
      ),
      videoEncoders: List<VideoEncoder>.from(
        (map['videoEncoders']).map<VideoEncoder>(
          (x) => VideoEncoder.fromMap(x as Map<String, dynamic>),
        ),
      ),
      audioEncoder: List<AudioEncoder>.from(
        (map['audioEncoder']).map<AudioEncoder>(
          (x) => AudioEncoder.fromMap(x as Map<String, dynamic>),
        ),
      ),
      appList: List<ScrcpyApp>.from(
        (map['appList']).map<ScrcpyApp>(
          (x) => ScrcpyApp.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScrcpyInfo.fromJson(String source) =>
      ScrcpyInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ScrcpyInfo(device: $device, buildVersion: $buildVersion, cameras: $cameras, displays: $displays, videoEncoders: $videoEncoders, audioEncoder: $audioEncoder)';
  }

  @override
  bool operator ==(covariant ScrcpyInfo other) {
    if (identical(this, other)) return true;

    return other.device == device &&
        other.buildVersion == buildVersion &&
        listEquals(other.cameras, cameras) &&
        listEquals(other.displays, displays) &&
        listEquals(other.videoEncoders, videoEncoders) &&
        listEquals(other.audioEncoder, audioEncoder) &&
        listEquals(other.appList, appList);
  }

  @override
  int get hashCode {
    return device.hashCode ^
        buildVersion.hashCode ^
        cameras.hashCode ^
        displays.hashCode ^
        videoEncoders.hashCode ^
        audioEncoder.hashCode ^
        appList.hashCode;
  }
}
