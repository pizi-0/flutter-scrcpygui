import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pg_scrcpy/models/scrcpy_related/scrcpy_config/audio_options.dart';
import 'package:pg_scrcpy/models/scrcpy_related/scrcpy_config/device_options.dart';
import 'package:pg_scrcpy/models/scrcpy_related/scrcpy_config/video_options.dart';
import 'package:pg_scrcpy/models/scrcpy_related/scrcpy_config/window_options.dart';

import '../models/scrcpy_related/scrcpy_config.dart';
import '../models/scrcpy_related/scrcpy_enum.dart';

final List<ScrcpyConfig> defaultConfigs = [
  newConfig,
  defaultMirror,
  defaultRecord,
];

final BorderRadius innerRadiusAll = BorderRadius.circular(5);
final BorderRadius outerRadiusAll = BorderRadius.circular(10);

const double appWidth = 450;

const List<DropdownMenuItem> yesno = [
  DropdownMenuItem(
    value: true,
    child: Text('Yes'),
  ),
  DropdownMenuItem(
    value: false,
    child: Text('No'),
  ),
];

final ScrcpyConfig defaultMirror = ScrcpyConfig(
  configName: 'Default (Mirror)',
  scrcpyMode: ScrcpyMode.both,
  isRecording: false,
  videoOptions: SVideoOptions(
    videoFormat: VideoFormat.mp4,
    videoCodec: 'h264',
    videoEncoder: 'default',
    resolutionScale: 1.0,
    videoBitrate: 8,
    maxFPS: 0,
    displayId: 0,
  ),
  audioOptions: SAudioOptions(
    audioFormat: AudioFormat.opus,
    audioCodec: 'opus',
    audioEncoder: 'default',
    audioSource: AudioSource.output,
    audioBitrate: 128,
    duplicateAudio: false,
  ),
  deviceOptions: SDeviceOptions(
    turnOffDisplay: false,
    stayAwake: false,
    showTouches: false,
    noScreensaver: false,
    offScreenOnClose: false,
  ),
  windowOptions: SWindowOptions(
    noWindow: false,
    noBorder: false,
    alwaysOntop: false,
    timeLimit: 0,
  ),
  additionalFlags: '',
);

final ScrcpyConfig newConfig = ScrcpyConfig(
  configName: 'New config',
  scrcpyMode: ScrcpyMode.both,
  isRecording: false,
  videoOptions: SVideoOptions(
    videoFormat: VideoFormat.mp4,
    videoCodec: 'h264',
    videoEncoder: 'default',
    resolutionScale: 1.0,
    videoBitrate: 8,
    maxFPS: 0,
    displayId: 0,
  ),
  audioOptions: SAudioOptions(
    audioFormat: AudioFormat.opus,
    audioCodec: 'opus',
    audioEncoder: 'default',
    audioSource: AudioSource.output,
    audioBitrate: 128,
    duplicateAudio: false,
  ),
  deviceOptions: SDeviceOptions(
    turnOffDisplay: false,
    stayAwake: false,
    showTouches: false,
    noScreensaver: false,
    offScreenOnClose: false,
  ),
  windowOptions: SWindowOptions(
    noWindow: false,
    noBorder: false,
    alwaysOntop: false,
    timeLimit: 0,
  ),
  additionalFlags: '',
  savePath: Platform.environment['HOME'],
);

final ScrcpyConfig defaultRecord = ScrcpyConfig(
  configName: 'Default (Record)',
  scrcpyMode: ScrcpyMode.both,
  isRecording: true,
  videoOptions: SVideoOptions(
    videoFormat: VideoFormat.mp4,
    videoCodec: 'h264',
    videoEncoder: 'default',
    resolutionScale: 1.0,
    videoBitrate: 8,
    maxFPS: 0,
    displayId: 0,
  ),
  audioOptions: SAudioOptions(
    audioFormat: AudioFormat.opus,
    audioCodec: 'opus',
    audioEncoder: 'default',
    audioSource: AudioSource.output,
    audioBitrate: 128,
    duplicateAudio: false,
  ),
  deviceOptions: SDeviceOptions(
    turnOffDisplay: false,
    stayAwake: false,
    showTouches: false,
    noScreensaver: false,
    offScreenOnClose: false,
  ),
  windowOptions: SWindowOptions(
    noWindow: false,
    noBorder: false,
    alwaysOntop: false,
    timeLimit: 0,
  ),
  additionalFlags: '',
  savePath: Platform.environment['HOME'],
);
