import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:scrcpygui/models/automation.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/audio_options.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/device_options.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/video_options.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/window_options.dart';
import 'package:scrcpygui/models/settings_model/app_behaviour.dart';
import 'package:scrcpygui/models/settings_model/app_settings.dart';

import '../models/scrcpy_related/scrcpy_config.dart';
import '../models/scrcpy_related/scrcpy_enum.dart';
import '../models/settings_model/app_theme.dart';

final List<ScrcpyConfig> defaultConfigs = [
  newConfig,
  defaultMirror,
  defaultRecord,
];

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
  id: 'default-mirror',
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
  id: 'new-config',
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
  id: 'default-record',
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

final defaultTheme = AppTheme(
  widgetRadius: 10,
  color: const Color(0xff00b8d4),
  brightness: Brightness.dark,
  fromWall: false,
  tintLevel: ColorTintLevel(),
);

final defaultAppBehaviour = AppBehaviour(
  killNoWindowInstance: true,
  traySupport: true,
  toastEnabled: true,
);

final defaultSettings = AppSettings(
  looks: defaultTheme,
  behaviour: defaultAppBehaviour,
);

final defaultAutomationData = AutomationData(actions: []);

const scrcpyLatestUrl =
    'https://api.github.com/repos/Genymobile/scrcpy/releases/latest';

const eadb = './adb';
const escrcpy = './scrcpy_bin';

final logger = Logger(
  filter: ProductionFilter(),
  printer: PrettyPrinter(methodCount: 0, errorMethodCount: 0),
  output: null,
);

final shellEnv = {
  'ADB': './adb',
  'SCRCPY_SERVER_PATH': './scrcpy-server',
  'SCRCPY_ICON_PATH': './icon.png'
};
