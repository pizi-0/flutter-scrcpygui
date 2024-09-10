// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pg_scrcpy/models/adb_devices.dart';

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

  ScrcpyInfo({
    required this.device,
    required this.buildVersion,
    required this.cameras,
    required this.displays,
    required this.videoEncoders,
    required this.audioEncoder,
  });

  ScrcpyInfo copyWith({
    AdbDevices? device,
    String? buildVersion,
    List<ScrcpyCamera>? cameras,
    List<ScrcpyDisplay>? displays,
    List<VideoEncoder>? videoEncoders,
    List<AudioEncoder>? audioEncoder,
  }) {
    return ScrcpyInfo(
      device: device ?? this.device,
      buildVersion: buildVersion ?? this.buildVersion,
      cameras: cameras ?? this.cameras,
      displays: displays ?? this.displays,
      videoEncoders: videoEncoders ?? this.videoEncoders,
      audioEncoder: audioEncoder ?? this.audioEncoder,
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
    };
  }

  factory ScrcpyInfo.fromMap(Map<String, dynamic> map) {
    return ScrcpyInfo(
      device: AdbDevices.fromMap(map['device'] as Map<String, dynamic>),
      buildVersion: map['buildVersion'] as String,
      cameras: List<ScrcpyCamera>.from(
        (map['cameras'] as List<int>).map<ScrcpyCamera>(
          (x) => ScrcpyCamera.fromMap(x as Map<String, dynamic>),
        ),
      ),
      displays: List<ScrcpyDisplay>.from(
        (map['displays'] as List<int>).map<ScrcpyDisplay>(
          (x) => ScrcpyDisplay.fromMap(x as Map<String, dynamic>),
        ),
      ),
      videoEncoders: List<VideoEncoder>.from(
        (map['videoEncoders'] as List<int>).map<VideoEncoder>(
          (x) => VideoEncoder.fromMap(x as Map<String, dynamic>),
        ),
      ),
      audioEncoder: List<AudioEncoder>.from(
        (map['audioEncoder'] as List<int>).map<AudioEncoder>(
          (x) => AudioEncoder.fromMap(x as Map<String, dynamic>),
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
}
