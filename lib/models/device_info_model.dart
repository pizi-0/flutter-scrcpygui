// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';

import 'scrcpy_related/scrcpy_info/scrcpy_camera.dart';
import 'scrcpy_related/scrcpy_info/scrcpy_display.dart';
import 'scrcpy_related/scrcpy_info/scrcpy_encoder.dart';

class DeviceInfo {
  final String serialNo; //device serial no
  final String deviceName;
  final String buildVersion;
  final List<ScrcpyCamera> cameras;
  final List<ScrcpyDisplay> displays;
  final List<VideoEncoder> videoEncoders;
  final List<AudioEncoder> audioEncoder;
  final List<ScrcpyApp> appList;

  DeviceInfo({
    required this.serialNo,
    required this.deviceName,
    required this.buildVersion,
    required this.cameras,
    required this.displays,
    required this.videoEncoders,
    required this.audioEncoder,
    required this.appList,
  });

  DeviceInfo copyWith({
    String? serialNo,
    String? deviceName,
    String? buildVersion,
    List<ScrcpyCamera>? cameras,
    List<ScrcpyDisplay>? displays,
    List<VideoEncoder>? videoEncoders,
    List<AudioEncoder>? audioEncoder,
    List<ScrcpyApp>? appList,
  }) {
    return DeviceInfo(
      serialNo: serialNo ?? this.serialNo,
      deviceName: deviceName ?? this.deviceName,
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
      'serialNo': serialNo,
      'deviceName': deviceName,
      'buildVersion': buildVersion,
      'cameras': cameras.map((x) => x.toMap()).toList(),
      'displays': displays.map((x) => x.toMap()).toList(),
      'videoEncoders': videoEncoders.map((x) => x.toMap()).toList(),
      'audioEncoder': audioEncoder.map((x) => x.toMap()).toList(),
      'appList': (appList).map((x) => x.toMap()).toList(),
    };
  }

  factory DeviceInfo.fromMap(Map<String, dynamic> map) {
    return DeviceInfo(
      serialNo: map['serialNo'] as String,
      deviceName: map['deviceName'] as String,
      buildVersion: map['buildVersion'] as String,
      cameras: List<ScrcpyCamera>.from(
        (map['cameras'] ?? []).map<ScrcpyCamera>(
          (x) => ScrcpyCamera.fromMap(x as Map<String, dynamic>),
        ),
      ),
      displays: List<ScrcpyDisplay>.from(
        (map['displays'] ?? []).map<ScrcpyDisplay>(
          (x) => ScrcpyDisplay.fromMap(x as Map<String, dynamic>),
        ),
      ),
      videoEncoders: List<VideoEncoder>.from(
        (map['videoEncoders'] ?? []).map<VideoEncoder>(
          (x) => VideoEncoder.fromMap(x as Map<String, dynamic>),
        ),
      ),
      audioEncoder: List<AudioEncoder>.from(
        (map['audioEncoder'] ?? []).map<AudioEncoder>(
          (x) => AudioEncoder.fromMap(x as Map<String, dynamic>),
        ),
      ),
      appList: List<ScrcpyApp>.from(
        (map['appList'] ?? []).map<ScrcpyApp?>(
          (x) => ScrcpyApp.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceInfo.fromJson(String source) =>
      DeviceInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeviceInfo(serialNo: $serialNo, deviceName: $deviceName, buildVersion: $buildVersion, cameras: $cameras, displays: $displays, videoEncoders: $videoEncoders, audioEncoder: $audioEncoder, appList: $appList)';
  }

  @override
  bool operator ==(covariant DeviceInfo other) {
    if (identical(this, other)) return true;

    return other.serialNo == serialNo &&
        other.deviceName == deviceName &&
        other.buildVersion == buildVersion &&
        listEquals(other.cameras, cameras) &&
        listEquals(other.displays, displays) &&
        listEquals(other.videoEncoders, videoEncoders) &&
        listEquals(other.audioEncoder, audioEncoder) &&
        listEquals(other.appList, appList);
  }

  @override
  int get hashCode {
    return serialNo.hashCode ^
        deviceName.hashCode ^
        buildVersion.hashCode ^
        cameras.hashCode ^
        displays.hashCode ^
        videoEncoders.hashCode ^
        audioEncoder.hashCode ^
        appList.hashCode;
  }
}
