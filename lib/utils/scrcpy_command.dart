import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_info.dart';
import 'package:scrcpygui/utils/extension.dart';
import 'package:string_extensions/string_extensions.dart';

class ScrcpyCommand {
  static List<String> buildCommand(
      WidgetRef ref, ScrcpyConfig config, AdbDevices device,
      {String? customName}) {
    String command = '';

    command = command
            .append('-s ${device.id}')
            .append(config.scrcpyMode.command) // Both / video / audio
            .append(_displayId(config)) // display id
            .append(_videoCodec(config)) // video codec
            .append(_videoEncoder(config)) // video encoder
            .append(_videoBitrate(config)) // video bitrate
            .append(_maxFps(config)) // fps limit
            .append(_maxSize(config, device.info!)) // resolution scale
            .append(_audioCodec(config)) // audio codec
            .append(_audioSourceAndDup(config)) // Audio source + audio dup
            .append(_audioBitrate(config)) // audio bitrate
            .append(_stayAwake(config)) // stay awake
            .append(_showTouches(config)) // show touches
            .append(_noScreenSaver(config)) // disable screensaver
            .append(_screenOffOnStart(config)) // turn off display on start
            .append(_screenOffOnExit(config)) // turn off display on start
            .append(_noWindow(config)) // hide window
            .append(_noBorder(config)) // no border
            .append(_alwaysOnTop(config)) // always ontop
            .append(_timeLimit(config)) // time limit
            .append(_startApp(config)) // start app
        ;

    // recording, savepath, video/audio format
    var comm = command.split(' ') +
        [
          "--window-title=\"${customName ?? config.configName}\"",
          _recordingFormat(config, customName ?? config.configName),
          ...config.additionalFlags.trim().split(' '),
        ];

    comm.removeWhere((e) => e.trim().isEmpty);

    return comm;
  }

  static String _recordingFormat(ScrcpyConfig config, String filename) {
    final sep = Platform.pathSeparator;
    if (config.isRecording) {
      switch (config.scrcpyMode) {
        case ScrcpyMode.audioOnly:
          return "--record=${config.savePath}$sep${_nameAfterDuplicateCheck(config.savePath!, '$filename${config.audioOptions.audioFormat.command}')}";

        default:
          return "--record=${config.savePath}$sep${_nameAfterDuplicateCheck(config.savePath!, '$filename${config.videoOptions.videoFormat.command}')}";
      }
    } else {
      return '';
    }
  }

  static String _nameAfterDuplicateCheck(String savePath, String oldname) {
    String newname = oldname;
    final sep = Platform.pathSeparator;
    File toSave = File('$savePath$sep$oldname');
    DateTime now = DateTime.timestamp().toLocal();

    if (toSave.existsSync()) {
      newname = oldname.insertAt(
          oldname.lastIndexOf('.'), '-${now.millisecondsSinceEpoch}');
    }

    return newname;
  }

  //video options

  static String _videoBitrate(ScrcpyConfig config) {
    if (config.videoOptions.videoBitrate != 8) {
      return ' --video-bit-rate=${config.videoOptions.videoBitrate}M';
    } else {
      return '';
    }
  }

  static String _videoCodec(ScrcpyConfig config) {
    if (config.videoOptions.videoCodec != 'h264') {
      return ' --video-codec=${config.videoOptions.videoCodec}';
    } else {
      return '';
    }
  }

  static String _videoEncoder(ScrcpyConfig config) {
    if (config.videoOptions.videoEncoder != 'default') {
      return ' --video-encoder=${config.videoOptions.videoEncoder}';
    } else {
      return '';
    }
  }

  static String _displayId(ScrcpyConfig config) {
    if (config.videoOptions.displayId == 'new') {
      var newVd = ' --new-display';
      var res = config.videoOptions.vdResolution != null &&
              config.videoOptions.vdResolution!.isValidResolution
          ? config.videoOptions.vdResolution
          : '';

      var dpi =
          config.videoOptions.vdDPI != null && config.videoOptions.vdDPI != ''
              ? '/${config.videoOptions.vdDPI}'
              : '';

      return '$newVd${res!.isNotEmpty || dpi.isNotEmpty ? '=' : ''}$res$dpi';
    }

    if (config.videoOptions.displayId != '0') {
      return ' --display-id=${config.videoOptions.displayId}';
    }
    return '';
  }

  static String _maxFps(ScrcpyConfig config) {
    if (config.videoOptions.maxFPS != 0) {
      return ' --max-fps=${config.videoOptions.maxFPS}';
    }
    return '';
  }

  static String _maxSize(ScrcpyConfig config, ScrcpyInfo info) {
    if (config.videoOptions.displayId == 'new') {
      return '';
    } else if (config.videoOptions.displayId != 'new') {
      final maxRes = info.displays
          .firstWhere((d) => d.id == config.videoOptions.displayId.toString())
          .resolution
          .split('x');

      final max = maxRes.map((e) => int.parse(e.removeLetters!)).toList();
      max.sort((a, b) => b.compareTo(a));

      if (config.videoOptions.resolutionScale != 100) {
        return ' --max-size=${((config.videoOptions.resolutionScale / 100) * max.first).toInt()}';
      }
    }

    return '';
  }

  //audio options

  static String _audioSourceAndDup(ScrcpyConfig config) {
    if (config.audioOptions.duplicateAudio) {
      return ' --audio-dup';
    } else {
      return config.audioOptions.audioSource.command;
    }
  }

  static String _audioCodec(ScrcpyConfig config) {
    if (config.audioOptions.audioCodec != 'opus') {
      return ' --audio-codec=${config.audioOptions.audioCodec}';
    } else {
      return '';
    }
  }

  static String _audioBitrate(ScrcpyConfig config) {
    if (config.audioOptions.audioBitrate != 128) {
      return ' --audio-bit-rate=${config.audioOptions.audioBitrate}K';
    } else {
      return '';
    }
  }

  //device options

  static String _stayAwake(ScrcpyConfig config) {
    return config.deviceOptions.stayAwake ? ' --stay-awake' : '';
  }

  static String _showTouches(ScrcpyConfig config) {
    return config.deviceOptions.showTouches ? ' --show-touches' : '';
  }

  static String _noScreenSaver(ScrcpyConfig config) {
    return config.deviceOptions.noScreensaver ? ' --disable-screensaver' : '';
  }

  static String _screenOffOnStart(ScrcpyConfig config) {
    return config.deviceOptions.turnOffDisplay ? ' --turn-screen-off' : '';
  }

  static String _screenOffOnExit(ScrcpyConfig config) {
    return config.deviceOptions.offScreenOnClose ? ' --power-off-on-close' : '';
  }

  //window options

  static String _noWindow(ScrcpyConfig config) {
    return config.windowOptions.noWindow ? ' --no-window' : '';
  }

  static String _noBorder(ScrcpyConfig config) {
    return config.windowOptions.noBorder ? ' --window-borderless' : '';
  }

  static String _alwaysOnTop(ScrcpyConfig config) {
    return config.windowOptions.alwaysOntop ? ' --always-on-top' : '';
  }

  static String _timeLimit(ScrcpyConfig config) {
    if (config.windowOptions.timeLimit != 0) {
      return ' --time-limit=${config.windowOptions.timeLimit}';
    }

    return '';
  }

  static String _startApp(ScrcpyConfig config) {
    if (config.appOptions?.selectedApp != null) {
      final forceClose = config.appOptions?.forceClose ?? false;
      final packageName = config.appOptions?.selectedApp?.packageName;
      return ' --start-app=${forceClose ? '+' : ''}$packageName';
    }

    return '';
  }
}
