/// This is generated content. There is no point to change it by hands.

// ignore_for_file: type=lint

import 'dart:developer' show log;

import 'package:easiest_localization/easiest_localization.dart'
    show LocalizationProvider;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/widgets.dart'
    show BuildContext, Locale, Localizations, LocalizationsDelegate;
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalMaterialLocalizations;
import 'package:intl/intl.dart' show Intl;

final RegExp _variableRegExp = RegExp(r'\$\{[^}]+\} ?');

typedef Checker<T> = bool Function(T value);

const String localizationPackageVersion = r'1.0.0';

const String? localizationVersion = null;

enum Gender {
  male,
  female,
  other,
}

class HomeLoc {
  const HomeLoc({
    required this.title,
    required this.devices,
    required this.deviceTile,
    required this.config,
  });
  factory HomeLoc.fromJson(Map<String, dynamic> json) {
    return HomeLoc(
      title: (json['title'] ?? '').toString(),
      devices: HomeLocDevices.fromJson(
          (json['devices'] as Map).cast<String, dynamic>()),
      deviceTile: HomeLocDeviceTile.fromJson(
          (json['device_tile'] as Map).cast<String, dynamic>()),
      config: HomeLocConfig.fromJson(
          (json['config'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final HomeLocDevices devices;

  final HomeLocDeviceTile deviceTile;

  final HomeLocConfig config;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''devices''': devices,
        r'''device_tile''': deviceTile,
        r'''config''': config,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class HomeLocDevices {
  const HomeLocDevices({
    required this.label,
  });
  factory HomeLocDevices.fromJson(Map<String, dynamic> json) {
    return HomeLocDevices(
      label: ({required String count}) => (json['label'] ?? '')
          .toString()
          .replaceAll(r'${count}', count)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String Function({required String count}) label;

  Map<String, Object> get _content => {
        r'''label''': label,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class HomeLocDeviceTile {
  const HomeLocDeviceTile({
    required this.runningInstances,
    required this.context,
  });
  factory HomeLocDeviceTile.fromJson(Map<String, dynamic> json) {
    return HomeLocDeviceTile(
      runningInstances: ({required String count}) =>
          (json['running_instances'] ?? '')
              .toString()
              .replaceAll(r'${count}', count)
              .replaceAll(_variableRegExp, ''),
      context: HomeLocDeviceTileContext.fromJson(
          (json['context'] as Map).cast<String, dynamic>()),
    );
  }
  final String Function({required String count}) runningInstances;

  final HomeLocDeviceTileContext context;

  Map<String, Object> get _content => {
        r'''running_instances''': runningInstances,
        r'''context''': context,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class HomeLocDeviceTileContext {
  const HomeLocDeviceTileContext({
    required this.disconnect,
    required this.toWireless,
    required this.killRunning,
  });
  factory HomeLocDeviceTileContext.fromJson(Map<String, dynamic> json) {
    return HomeLocDeviceTileContext(
      disconnect: (json['disconnect'] ?? '').toString(),
      toWireless: (json['to_wireless'] ?? '').toString(),
      killRunning: (json['kill_running'] ?? '').toString(),
    );
  }
  final String disconnect;
  final String toWireless;
  final String killRunning;
  Map<String, Object> get _content => {
        r'''disconnect''': disconnect,
        r'''to_wireless''': toWireless,
        r'''kill_running''': killRunning,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class HomeLocConfig {
  const HomeLocConfig({
    required this.label,
    required this.new$,
    required this.select,
    required this.details,
    required this.start,
  });
  factory HomeLocConfig.fromJson(Map<String, dynamic> json) {
    return HomeLocConfig(
      label: (json['label'] ?? '').toString(),
      new$: (json['new'] ?? '').toString(),
      select: (json['select'] ?? '').toString(),
      details: (json['details'] ?? '').toString(),
      start: (json['start'] ?? '').toString(),
    );
  }
  final String label;
  final String new$;
  final String select;
  final String details;
  final String start;
  Map<String, Object> get _content => {
        r'''label''': label,
        r'''new''': new$,
        r'''select''': select,
        r'''details''': details,
        r'''start''': start,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class NoDeviceDialogLoc {
  const NoDeviceDialogLoc({
    required this.title,
    required this.contents,
  });
  factory NoDeviceDialogLoc.fromJson(Map<String, dynamic> json) {
    return NoDeviceDialogLoc(
      title: (json['title'] ?? '').toString(),
      contents: (json['contents'] ?? '').toString(),
    );
  }
  final String title;
  final String contents;
  Map<String, Object> get _content => {
        r'''title''': title,
        r'''contents''': contents,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class NoConfigDialogLoc {
  const NoConfigDialogLoc({
    required this.title,
    required this.contents,
  });
  factory NoConfigDialogLoc.fromJson(Map<String, dynamic> json) {
    return NoConfigDialogLoc(
      title: (json['title'] ?? '').toString(),
      contents: (json['contents'] ?? '').toString(),
    );
  }
  final String title;
  final String contents;
  Map<String, Object> get _content => {
        r'''title''': title,
        r'''contents''': contents,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSettingsLoc {
  const DeviceSettingsLoc({
    required this.title,
    required this.info,
    required this.refresh,
    required this.rename,
    required this.autoConnect,
    required this.onConnected,
    required this.doNothing,
    required this.scrcpyInfo,
  });
  factory DeviceSettingsLoc.fromJson(Map<String, dynamic> json) {
    return DeviceSettingsLoc(
      title: (json['title'] ?? '').toString(),
      info: (json['info'] ?? '').toString(),
      refresh: (json['refresh'] ?? '').toString(),
      rename: DeviceSettingsLocRename.fromJson(
          (json['rename'] as Map).cast<String, dynamic>()),
      autoConnect: DeviceSettingsLocAutoConnect.fromJson(
          (json['auto_connect'] as Map).cast<String, dynamic>()),
      onConnected: DeviceSettingsLocOnConnected.fromJson(
          (json['on_connected'] as Map).cast<String, dynamic>()),
      doNothing: (json['do_nothing'] ?? '').toString(),
      scrcpyInfo: DeviceSettingsLocScrcpyInfo.fromJson(
          (json['scrcpy_info'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final String info;
  final String refresh;
  final DeviceSettingsLocRename rename;

  final DeviceSettingsLocAutoConnect autoConnect;

  final DeviceSettingsLocOnConnected onConnected;

  final String doNothing;
  final DeviceSettingsLocScrcpyInfo scrcpyInfo;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''info''': info,
        r'''refresh''': refresh,
        r'''rename''': rename,
        r'''auto_connect''': autoConnect,
        r'''on_connected''': onConnected,
        r'''do_nothing''': doNothing,
        r'''scrcpy_info''': scrcpyInfo,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSettingsLocRename {
  const DeviceSettingsLocRename({
    required this.label,
    required this.info,
  });
  factory DeviceSettingsLocRename.fromJson(Map<String, dynamic> json) {
    return DeviceSettingsLocRename(
      label: (json['label'] ?? '').toString(),
      info: (json['info'] ?? '').toString(),
    );
  }
  final String label;
  final String info;
  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSettingsLocAutoConnect {
  const DeviceSettingsLocAutoConnect({
    required this.label,
    required this.info,
  });
  factory DeviceSettingsLocAutoConnect.fromJson(Map<String, dynamic> json) {
    return DeviceSettingsLocAutoConnect(
      label: (json['label'] ?? '').toString(),
      info: (json['info'] ?? '').toString(),
    );
  }
  final String label;
  final String info;
  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSettingsLocOnConnected {
  const DeviceSettingsLocOnConnected({
    required this.label,
    required this.info,
  });
  factory DeviceSettingsLocOnConnected.fromJson(Map<String, dynamic> json) {
    return DeviceSettingsLocOnConnected(
      label: (json['label'] ?? '').toString(),
      info: (json['info'] ?? '').toString(),
    );
  }
  final String label;
  final String info;
  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSettingsLocScrcpyInfo {
  const DeviceSettingsLocScrcpyInfo({
    required this.fetching,
    required this.label,
    required this.name,
    required this.id,
    required this.model,
    required this.version,
    required this.displays,
    required this.cameras,
    required this.videoEnc,
    required this.audioEnc,
  });
  factory DeviceSettingsLocScrcpyInfo.fromJson(Map<String, dynamic> json) {
    return DeviceSettingsLocScrcpyInfo(
      fetching: (json['fetching'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      id: (json['id'] ?? '').toString(),
      model: (json['model'] ?? '').toString(),
      version: (json['version'] ?? '').toString(),
      displays: (json['displays'] ?? '').toString(),
      cameras: (json['cameras'] ?? '').toString(),
      videoEnc: (json['video_enc'] ?? '').toString(),
      audioEnc: (json['audio_enc'] ?? '').toString(),
    );
  }
  final String fetching;
  final String label;
  final String name;
  final String id;
  final String model;
  final String version;
  final String displays;
  final String cameras;
  final String videoEnc;
  final String audioEnc;
  Map<String, Object> get _content => {
        r'''fetching''': fetching,
        r'''label''': label,
        r'''name''': name,
        r'''id''': id,
        r'''model''': model,
        r'''version''': version,
        r'''displays''': displays,
        r'''cameras''': cameras,
        r'''video_enc''': videoEnc,
        r'''audio_enc''': audioEnc,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class ConfigScreenLoc {
  const ConfigScreenLoc({
    required this.connectionLost,
  });
  factory ConfigScreenLoc.fromJson(Map<String, dynamic> json) {
    return ConfigScreenLoc(
      connectionLost: (json['connection_lost'] ?? '').toString(),
    );
  }
  final String connectionLost;
  Map<String, Object> get _content => {
        r'''connection_lost''': connectionLost,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class LogScreenLoc {
  const LogScreenLoc({
    required this.title,
    required this.dialog,
  });
  factory LogScreenLoc.fromJson(Map<String, dynamic> json) {
    return LogScreenLoc(
      title: (json['title'] ?? '').toString(),
      dialog: LogScreenLocDialog.fromJson(
          (json['dialog'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final LogScreenLocDialog dialog;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''dialog''': dialog,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class LogScreenLocDialog {
  const LogScreenLocDialog({
    required this.title,
  });
  factory LogScreenLocDialog.fromJson(Map<String, dynamic> json) {
    return LogScreenLocDialog(
      title: (json['title'] ?? '').toString(),
    );
  }
  final String title;
  Map<String, Object> get _content => {
        r'''title''': title,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class ModeSection {
  const ModeSection({
    required this.title,
    required this.saveFolder,
    required this.mainMode,
    required this.scrcpyMode,
  });
  factory ModeSection.fromJson(Map<String, dynamic> json) {
    return ModeSection(
      title: (json['title'] ?? '').toString(),
      saveFolder: ModeSectionSaveFolder.fromJson(
          (json['save_folder'] as Map).cast<String, dynamic>()),
      mainMode: ModeSectionMainMode.fromJson(
          (json['main_mode'] as Map).cast<String, dynamic>()),
      scrcpyMode: ModeSectionScrcpyMode.fromJson(
          (json['scrcpy_mode'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final ModeSectionSaveFolder saveFolder;

  final ModeSectionMainMode mainMode;

  final ModeSectionScrcpyMode scrcpyMode;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''save_folder''': saveFolder,
        r'''main_mode''': mainMode,
        r'''scrcpy_mode''': scrcpyMode,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class ModeSectionSaveFolder {
  const ModeSectionSaveFolder({
    required this.label,
    required this.info,
  });
  factory ModeSectionSaveFolder.fromJson(Map<String, dynamic> json) {
    return ModeSectionSaveFolder(
      label: (json['label'] ?? '').toString(),
      info: (json['info'] ?? '').toString(),
    );
  }
  final String label;
  final String info;
  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class ModeSectionMainMode {
  const ModeSectionMainMode({
    required this.label,
    required this.mirror,
    required this.record,
    required this.info,
  });
  factory ModeSectionMainMode.fromJson(Map<String, dynamic> json) {
    return ModeSectionMainMode(
      label: (json['label'] ?? '').toString(),
      mirror: (json['mirror'] ?? '').toString(),
      record: (json['record'] ?? '').toString(),
      info: ModeSectionMainModeInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final String mirror;
  final String record;
  final ModeSectionMainModeInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''mirror''': mirror,
        r'''record''': record,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class ModeSectionMainModeInfo {
  const ModeSectionMainModeInfo({
    required this.default$,
    required this.alt,
  });
  factory ModeSectionMainModeInfo.fromJson(Map<String, dynamic> json) {
    return ModeSectionMainModeInfo(
      default$: (json['default'] ?? '').toString(),
      alt: (json['alt'] ?? '').toString(),
    );
  }
  final String default$;
  final String alt;
  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class ModeSectionScrcpyMode {
  const ModeSectionScrcpyMode({
    required this.both,
    required this.audioOnly,
    required this.videoOnly,
    required this.info,
  });
  factory ModeSectionScrcpyMode.fromJson(Map<String, dynamic> json) {
    return ModeSectionScrcpyMode(
      both: (json['both'] ?? '').toString(),
      audioOnly: (json['audio_only'] ?? '').toString(),
      videoOnly: (json['video_only'] ?? '').toString(),
      info: ModeSectionScrcpyModeInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String both;
  final String audioOnly;
  final String videoOnly;
  final ModeSectionScrcpyModeInfo info;

  Map<String, Object> get _content => {
        r'''both''': both,
        r'''audio_only''': audioOnly,
        r'''video_only''': videoOnly,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class ModeSectionScrcpyModeInfo {
  const ModeSectionScrcpyModeInfo({
    required this.default$,
    required this.alt,
  });
  factory ModeSectionScrcpyModeInfo.fromJson(Map<String, dynamic> json) {
    return ModeSectionScrcpyModeInfo(
      default$: (json['default'] ?? '').toString(),
      alt: ({required String command}) => (json['alt'] ?? '')
          .toString()
          .replaceAll(r'${command}', command)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String default$;
  final String Function({required String command}) alt;

  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSection {
  const VideoSection({
    required this.title,
    required this.displays,
    required this.codec,
    required this.encoder,
    required this.format,
    required this.bitrate,
    required this.fpsLimit,
    required this.resolutionScale,
  });
  factory VideoSection.fromJson(Map<String, dynamic> json) {
    return VideoSection(
      title: (json['title'] ?? '').toString(),
      displays: VideoSectionDisplays.fromJson(
          (json['displays'] as Map).cast<String, dynamic>()),
      codec: VideoSectionCodec.fromJson(
          (json['codec'] as Map).cast<String, dynamic>()),
      encoder: VideoSectionEncoder.fromJson(
          (json['encoder'] as Map).cast<String, dynamic>()),
      format: VideoSectionFormat.fromJson(
          (json['format'] as Map).cast<String, dynamic>()),
      bitrate: VideoSectionBitrate.fromJson(
          (json['bitrate'] as Map).cast<String, dynamic>()),
      fpsLimit: VideoSectionFpsLimit.fromJson(
          (json['fps_limit'] as Map).cast<String, dynamic>()),
      resolutionScale: VideoSectionResolutionScale.fromJson(
          (json['resolution_scale'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final VideoSectionDisplays displays;

  final VideoSectionCodec codec;

  final VideoSectionEncoder encoder;

  final VideoSectionFormat format;

  final VideoSectionBitrate bitrate;

  final VideoSectionFpsLimit fpsLimit;

  final VideoSectionResolutionScale resolutionScale;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''displays''': displays,
        r'''codec''': codec,
        r'''encoder''': encoder,
        r'''format''': format,
        r'''bitrate''': bitrate,
        r'''fps_limit''': fpsLimit,
        r'''resolution_scale''': resolutionScale,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSectionDisplays {
  const VideoSectionDisplays({
    required this.label,
    required this.info,
  });
  factory VideoSectionDisplays.fromJson(Map<String, dynamic> json) {
    return VideoSectionDisplays(
      label: (json['label'] ?? '').toString(),
      info: VideoSectionDisplaysInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final VideoSectionDisplaysInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSectionDisplaysInfo {
  const VideoSectionDisplaysInfo({
    required this.default$,
    required this.alt,
  });
  factory VideoSectionDisplaysInfo.fromJson(Map<String, dynamic> json) {
    return VideoSectionDisplaysInfo(
      default$: (json['default'] ?? '').toString(),
      alt: (json['alt'] ?? '').toString(),
    );
  }
  final String default$;
  final String alt;
  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSectionCodec {
  const VideoSectionCodec({
    required this.label,
    required this.info,
  });
  factory VideoSectionCodec.fromJson(Map<String, dynamic> json) {
    return VideoSectionCodec(
      label: (json['label'] ?? '').toString(),
      info: VideoSectionCodecInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final VideoSectionCodecInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSectionCodecInfo {
  const VideoSectionCodecInfo({
    required this.default$,
    required this.alt,
  });
  factory VideoSectionCodecInfo.fromJson(Map<String, dynamic> json) {
    return VideoSectionCodecInfo(
      default$: (json['default'] ?? '').toString(),
      alt: ({required String codec}) => (json['alt'] ?? '')
          .toString()
          .replaceAll(r'${codec}', codec)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String default$;
  final String Function({required String codec}) alt;

  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSectionEncoder {
  const VideoSectionEncoder({
    required this.label,
    required this.info,
  });
  factory VideoSectionEncoder.fromJson(Map<String, dynamic> json) {
    return VideoSectionEncoder(
      label: (json['label'] ?? '').toString(),
      info: VideoSectionEncoderInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final VideoSectionEncoderInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSectionEncoderInfo {
  const VideoSectionEncoderInfo({
    required this.default$,
    required this.alt,
  });
  factory VideoSectionEncoderInfo.fromJson(Map<String, dynamic> json) {
    return VideoSectionEncoderInfo(
      default$: (json['default'] ?? '').toString(),
      alt: ({required String encoder}) => (json['alt'] ?? '')
          .toString()
          .replaceAll(r'${encoder}', encoder)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String default$;
  final String Function({required String encoder}) alt;

  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSectionFormat {
  const VideoSectionFormat({
    required this.label,
    required this.info,
  });
  factory VideoSectionFormat.fromJson(Map<String, dynamic> json) {
    return VideoSectionFormat(
      label: (json['label'] ?? '').toString(),
      info: VideoSectionFormatInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final VideoSectionFormatInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSectionFormatInfo {
  const VideoSectionFormatInfo({
    required this.default$,
  });
  factory VideoSectionFormatInfo.fromJson(Map<String, dynamic> json) {
    return VideoSectionFormatInfo(
      default$: ({required String format}) => (json['default'] ?? '')
          .toString()
          .replaceAll(r'${format}', format)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String Function({required String format}) default$;

  Map<String, Object> get _content => {
        r'''default''': default$,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSectionBitrate {
  const VideoSectionBitrate({
    required this.label,
    required this.info,
  });
  factory VideoSectionBitrate.fromJson(Map<String, dynamic> json) {
    return VideoSectionBitrate(
      label: (json['label'] ?? '').toString(),
      info: VideoSectionBitrateInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final VideoSectionBitrateInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSectionBitrateInfo {
  const VideoSectionBitrateInfo({
    required this.default$,
    required this.alt,
  });
  factory VideoSectionBitrateInfo.fromJson(Map<String, dynamic> json) {
    return VideoSectionBitrateInfo(
      default$: (json['default'] ?? '').toString(),
      alt: ({required String bitrate}) => (json['alt'] ?? '')
          .toString()
          .replaceAll(r'${bitrate}', bitrate)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String default$;
  final String Function({required String bitrate}) alt;

  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSectionFpsLimit {
  const VideoSectionFpsLimit({
    required this.label,
    required this.info,
  });
  factory VideoSectionFpsLimit.fromJson(Map<String, dynamic> json) {
    return VideoSectionFpsLimit(
      label: (json['label'] ?? '').toString(),
      info: VideoSectionFpsLimitInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final VideoSectionFpsLimitInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSectionFpsLimitInfo {
  const VideoSectionFpsLimitInfo({
    required this.default$,
    required this.alt,
  });
  factory VideoSectionFpsLimitInfo.fromJson(Map<String, dynamic> json) {
    return VideoSectionFpsLimitInfo(
      default$: (json['default'] ?? '').toString(),
      alt: ({required String fps}) => (json['alt'] ?? '')
          .toString()
          .replaceAll(r'${fps}', fps)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String default$;
  final String Function({required String fps}) alt;

  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSectionResolutionScale {
  const VideoSectionResolutionScale({
    required this.label,
    required this.info,
  });
  factory VideoSectionResolutionScale.fromJson(Map<String, dynamic> json) {
    return VideoSectionResolutionScale(
      label: (json['label'] ?? '').toString(),
      info: VideoSectionResolutionScaleInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final VideoSectionResolutionScaleInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class VideoSectionResolutionScaleInfo {
  const VideoSectionResolutionScaleInfo({
    required this.default$,
    required this.alt,
  });
  factory VideoSectionResolutionScaleInfo.fromJson(Map<String, dynamic> json) {
    return VideoSectionResolutionScaleInfo(
      default$: (json['default'] ?? '').toString(),
      alt: ({required String size}) => (json['alt'] ?? '')
          .toString()
          .replaceAll(r'${size}', size)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String default$;
  final String Function({required String size}) alt;

  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class AudioSection {
  const AudioSection({
    required this.title,
    required this.duplicate,
    required this.source,
    required this.codec,
    required this.encoder,
    required this.format,
    required this.bitrate,
  });
  factory AudioSection.fromJson(Map<String, dynamic> json) {
    return AudioSection(
      title: (json['title'] ?? '').toString(),
      duplicate: AudioSectionDuplicate.fromJson(
          (json['duplicate'] as Map).cast<String, dynamic>()),
      source: AudioSectionSource.fromJson(
          (json['source'] as Map).cast<String, dynamic>()),
      codec: AudioSectionCodec.fromJson(
          (json['codec'] as Map).cast<String, dynamic>()),
      encoder: AudioSectionEncoder.fromJson(
          (json['encoder'] as Map).cast<String, dynamic>()),
      format: AudioSectionFormat.fromJson(
          (json['format'] as Map).cast<String, dynamic>()),
      bitrate: AudioSectionBitrate.fromJson(
          (json['bitrate'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final AudioSectionDuplicate duplicate;

  final AudioSectionSource source;

  final AudioSectionCodec codec;

  final AudioSectionEncoder encoder;

  final AudioSectionFormat format;

  final AudioSectionBitrate bitrate;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''duplicate''': duplicate,
        r'''source''': source,
        r'''codec''': codec,
        r'''encoder''': encoder,
        r'''format''': format,
        r'''bitrate''': bitrate,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class AudioSectionDuplicate {
  const AudioSectionDuplicate({
    required this.label,
    required this.info,
  });
  factory AudioSectionDuplicate.fromJson(Map<String, dynamic> json) {
    return AudioSectionDuplicate(
      label: (json['label'] ?? '').toString(),
      info: AudioSectionDuplicateInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final AudioSectionDuplicateInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class AudioSectionDuplicateInfo {
  const AudioSectionDuplicateInfo({
    required this.default$,
    required this.alt,
  });
  factory AudioSectionDuplicateInfo.fromJson(Map<String, dynamic> json) {
    return AudioSectionDuplicateInfo(
      default$: (json['default'] ?? '').toString(),
      alt: (json['alt'] ?? '').toString(),
    );
  }
  final String default$;
  final String alt;
  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class AudioSectionSource {
  const AudioSectionSource({
    required this.label,
    required this.info,
  });
  factory AudioSectionSource.fromJson(Map<String, dynamic> json) {
    return AudioSectionSource(
      label: (json['label'] ?? '').toString(),
      info: AudioSectionSourceInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final AudioSectionSourceInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class AudioSectionSourceInfo {
  const AudioSectionSourceInfo({
    required this.default$,
    required this.alt,
    required this.inCaseOfDup,
  });
  factory AudioSectionSourceInfo.fromJson(Map<String, dynamic> json) {
    return AudioSectionSourceInfo(
      default$: (json['default'] ?? '').toString(),
      alt: ({required String source}) => (json['alt'] ?? '')
          .toString()
          .replaceAll(r'${source}', source)
          .replaceAll(_variableRegExp, ''),
      inCaseOfDup: (json['inCaseOfDup'] ?? '').toString(),
    );
  }
  final String default$;
  final String Function({required String source}) alt;

  final String inCaseOfDup;
  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
        r'''inCaseOfDup''': inCaseOfDup,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class AudioSectionCodec {
  const AudioSectionCodec({
    required this.label,
    required this.info,
  });
  factory AudioSectionCodec.fromJson(Map<String, dynamic> json) {
    return AudioSectionCodec(
      label: (json['label'] ?? '').toString(),
      info: AudioSectionCodecInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final AudioSectionCodecInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class AudioSectionCodecInfo {
  const AudioSectionCodecInfo({
    required this.default$,
    required this.alt,
    required this.isAudioOnly,
  });
  factory AudioSectionCodecInfo.fromJson(Map<String, dynamic> json) {
    return AudioSectionCodecInfo(
      default$: (json['default'] ?? '').toString(),
      alt: ({required String codec}) => (json['alt'] ?? '')
          .toString()
          .replaceAll(r'${codec}', codec)
          .replaceAll(_variableRegExp, ''),
      isAudioOnly: ({required String format, required String codec}) =>
          (json['isAudioOnly'] ?? '')
              .toString()
              .replaceAll(r'${format}', format)
              .replaceAll(r'${codec}', codec)
              .replaceAll(_variableRegExp, ''),
    );
  }
  final String default$;
  final String Function({required String codec}) alt;

  final String Function({required String format, required String codec})
      isAudioOnly;

  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
        r'''isAudioOnly''': isAudioOnly,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class AudioSectionEncoder {
  const AudioSectionEncoder({
    required this.label,
    required this.info,
  });
  factory AudioSectionEncoder.fromJson(Map<String, dynamic> json) {
    return AudioSectionEncoder(
      label: (json['label'] ?? '').toString(),
      info: AudioSectionEncoderInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final AudioSectionEncoderInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class AudioSectionEncoderInfo {
  const AudioSectionEncoderInfo({
    required this.default$,
    required this.alt,
  });
  factory AudioSectionEncoderInfo.fromJson(Map<String, dynamic> json) {
    return AudioSectionEncoderInfo(
      default$: (json['default'] ?? '').toString(),
      alt: ({required String encoder}) => (json['alt'] ?? '')
          .toString()
          .replaceAll(r'${encoder}', encoder)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String default$;
  final String Function({required String encoder}) alt;

  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class AudioSectionFormat {
  const AudioSectionFormat({
    required this.label,
    required this.info,
  });
  factory AudioSectionFormat.fromJson(Map<String, dynamic> json) {
    return AudioSectionFormat(
      label: (json['label'] ?? '').toString(),
      info: AudioSectionFormatInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final AudioSectionFormatInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class AudioSectionFormatInfo {
  const AudioSectionFormatInfo({
    required this.default$,
  });
  factory AudioSectionFormatInfo.fromJson(Map<String, dynamic> json) {
    return AudioSectionFormatInfo(
      default$: ({required String format}) => (json['default'] ?? '')
          .toString()
          .replaceAll(r'${format}', format)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String Function({required String format}) default$;

  Map<String, Object> get _content => {
        r'''default''': default$,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class AudioSectionBitrate {
  const AudioSectionBitrate({
    required this.label,
    required this.info,
  });
  factory AudioSectionBitrate.fromJson(Map<String, dynamic> json) {
    return AudioSectionBitrate(
      label: (json['label'] ?? '').toString(),
      info: AudioSectionBitrateInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final AudioSectionBitrateInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class AudioSectionBitrateInfo {
  const AudioSectionBitrateInfo({
    required this.default$,
    required this.alt,
  });
  factory AudioSectionBitrateInfo.fromJson(Map<String, dynamic> json) {
    return AudioSectionBitrateInfo(
      default$: (json['default'] ?? '').toString(),
      alt: ({required String bitrate}) => (json['alt'] ?? '')
          .toString()
          .replaceAll(r'${bitrate}', bitrate)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String default$;
  final String Function({required String bitrate}) alt;

  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSection {
  const DeviceSection({
    required this.title,
    required this.stayAwake,
    required this.showTouches,
    required this.offDisplayStart,
    required this.offDisplayExit,
    required this.screensaver,
  });
  factory DeviceSection.fromJson(Map<String, dynamic> json) {
    return DeviceSection(
      title: (json['title'] ?? '').toString(),
      stayAwake: DeviceSectionStayAwake.fromJson(
          (json['stay_awake'] as Map).cast<String, dynamic>()),
      showTouches: DeviceSectionShowTouches.fromJson(
          (json['show_touches'] as Map).cast<String, dynamic>()),
      offDisplayStart: DeviceSectionOffDisplayStart.fromJson(
          (json['off_display_start'] as Map).cast<String, dynamic>()),
      offDisplayExit: DeviceSectionOffDisplayExit.fromJson(
          (json['off_display_exit'] as Map).cast<String, dynamic>()),
      screensaver: DeviceSectionScreensaver.fromJson(
          (json['screensaver'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final DeviceSectionStayAwake stayAwake;

  final DeviceSectionShowTouches showTouches;

  final DeviceSectionOffDisplayStart offDisplayStart;

  final DeviceSectionOffDisplayExit offDisplayExit;

  final DeviceSectionScreensaver screensaver;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''stay_awake''': stayAwake,
        r'''show_touches''': showTouches,
        r'''off_display_start''': offDisplayStart,
        r'''off_display_exit''': offDisplayExit,
        r'''screensaver''': screensaver,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSectionStayAwake {
  const DeviceSectionStayAwake({
    required this.label,
    required this.info,
  });
  factory DeviceSectionStayAwake.fromJson(Map<String, dynamic> json) {
    return DeviceSectionStayAwake(
      label: (json['label'] ?? '').toString(),
      info: DeviceSectionStayAwakeInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final DeviceSectionStayAwakeInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSectionStayAwakeInfo {
  const DeviceSectionStayAwakeInfo({
    required this.default$,
    required this.alt,
  });
  factory DeviceSectionStayAwakeInfo.fromJson(Map<String, dynamic> json) {
    return DeviceSectionStayAwakeInfo(
      default$: (json['default'] ?? '').toString(),
      alt: (json['alt'] ?? '').toString(),
    );
  }
  final String default$;
  final String alt;
  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSectionShowTouches {
  const DeviceSectionShowTouches({
    required this.label,
    required this.info,
  });
  factory DeviceSectionShowTouches.fromJson(Map<String, dynamic> json) {
    return DeviceSectionShowTouches(
      label: (json['label'] ?? '').toString(),
      info: DeviceSectionShowTouchesInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final DeviceSectionShowTouchesInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSectionShowTouchesInfo {
  const DeviceSectionShowTouchesInfo({
    required this.default$,
    required this.alt,
  });
  factory DeviceSectionShowTouchesInfo.fromJson(Map<String, dynamic> json) {
    return DeviceSectionShowTouchesInfo(
      default$: (json['default'] ?? '').toString(),
      alt: (json['alt'] ?? '').toString(),
    );
  }
  final String default$;
  final String alt;
  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSectionOffDisplayStart {
  const DeviceSectionOffDisplayStart({
    required this.label,
    required this.info,
  });
  factory DeviceSectionOffDisplayStart.fromJson(Map<String, dynamic> json) {
    return DeviceSectionOffDisplayStart(
      label: (json['label'] ?? '').toString(),
      info: DeviceSectionOffDisplayStartInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final DeviceSectionOffDisplayStartInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSectionOffDisplayStartInfo {
  const DeviceSectionOffDisplayStartInfo({
    required this.default$,
    required this.alt,
  });
  factory DeviceSectionOffDisplayStartInfo.fromJson(Map<String, dynamic> json) {
    return DeviceSectionOffDisplayStartInfo(
      default$: (json['default'] ?? '').toString(),
      alt: (json['alt'] ?? '').toString(),
    );
  }
  final String default$;
  final String alt;
  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSectionOffDisplayExit {
  const DeviceSectionOffDisplayExit({
    required this.label,
    required this.info,
  });
  factory DeviceSectionOffDisplayExit.fromJson(Map<String, dynamic> json) {
    return DeviceSectionOffDisplayExit(
      label: (json['label'] ?? '').toString(),
      info: DeviceSectionOffDisplayExitInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final DeviceSectionOffDisplayExitInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSectionOffDisplayExitInfo {
  const DeviceSectionOffDisplayExitInfo({
    required this.default$,
    required this.alt,
  });
  factory DeviceSectionOffDisplayExitInfo.fromJson(Map<String, dynamic> json) {
    return DeviceSectionOffDisplayExitInfo(
      default$: (json['default'] ?? '').toString(),
      alt: (json['alt'] ?? '').toString(),
    );
  }
  final String default$;
  final String alt;
  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSectionScreensaver {
  const DeviceSectionScreensaver({
    required this.label,
    required this.info,
  });
  factory DeviceSectionScreensaver.fromJson(Map<String, dynamic> json) {
    return DeviceSectionScreensaver(
      label: (json['label'] ?? '').toString(),
      info: DeviceSectionScreensaverInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final DeviceSectionScreensaverInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class DeviceSectionScreensaverInfo {
  const DeviceSectionScreensaverInfo({
    required this.default$,
    required this.alt,
  });
  factory DeviceSectionScreensaverInfo.fromJson(Map<String, dynamic> json) {
    return DeviceSectionScreensaverInfo(
      default$: (json['default'] ?? '').toString(),
      alt: (json['alt'] ?? '').toString(),
    );
  }
  final String default$;
  final String alt;
  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class WindowSection {
  const WindowSection({
    required this.title,
    required this.hideWindow,
    required this.borderless,
    required this.alwaysOnTop,
    required this.timeLimit,
  });
  factory WindowSection.fromJson(Map<String, dynamic> json) {
    return WindowSection(
      title: (json['title'] ?? '').toString(),
      hideWindow: WindowSectionHideWindow.fromJson(
          (json['hide_window'] as Map).cast<String, dynamic>()),
      borderless: WindowSectionBorderless.fromJson(
          (json['borderless'] as Map).cast<String, dynamic>()),
      alwaysOnTop: WindowSectionAlwaysOnTop.fromJson(
          (json['always_on_top'] as Map).cast<String, dynamic>()),
      timeLimit: WindowSectionTimeLimit.fromJson(
          (json['time_limit'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final WindowSectionHideWindow hideWindow;

  final WindowSectionBorderless borderless;

  final WindowSectionAlwaysOnTop alwaysOnTop;

  final WindowSectionTimeLimit timeLimit;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''hide_window''': hideWindow,
        r'''borderless''': borderless,
        r'''always_on_top''': alwaysOnTop,
        r'''time_limit''': timeLimit,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class WindowSectionHideWindow {
  const WindowSectionHideWindow({
    required this.label,
    required this.info,
  });
  factory WindowSectionHideWindow.fromJson(Map<String, dynamic> json) {
    return WindowSectionHideWindow(
      label: (json['label'] ?? '').toString(),
      info: WindowSectionHideWindowInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final WindowSectionHideWindowInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class WindowSectionHideWindowInfo {
  const WindowSectionHideWindowInfo({
    required this.default$,
    required this.alt,
  });
  factory WindowSectionHideWindowInfo.fromJson(Map<String, dynamic> json) {
    return WindowSectionHideWindowInfo(
      default$: (json['default'] ?? '').toString(),
      alt: (json['alt'] ?? '').toString(),
    );
  }
  final String default$;
  final String alt;
  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class WindowSectionBorderless {
  const WindowSectionBorderless({
    required this.label,
    required this.info,
  });
  factory WindowSectionBorderless.fromJson(Map<String, dynamic> json) {
    return WindowSectionBorderless(
      label: (json['label'] ?? '').toString(),
      info: WindowSectionBorderlessInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final WindowSectionBorderlessInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class WindowSectionBorderlessInfo {
  const WindowSectionBorderlessInfo({
    required this.default$,
    required this.alt,
  });
  factory WindowSectionBorderlessInfo.fromJson(Map<String, dynamic> json) {
    return WindowSectionBorderlessInfo(
      default$: (json['default'] ?? '').toString(),
      alt: (json['alt'] ?? '').toString(),
    );
  }
  final String default$;
  final String alt;
  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class WindowSectionAlwaysOnTop {
  const WindowSectionAlwaysOnTop({
    required this.label,
    required this.info,
  });
  factory WindowSectionAlwaysOnTop.fromJson(Map<String, dynamic> json) {
    return WindowSectionAlwaysOnTop(
      label: (json['label'] ?? '').toString(),
      info: WindowSectionAlwaysOnTopInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final WindowSectionAlwaysOnTopInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class WindowSectionAlwaysOnTopInfo {
  const WindowSectionAlwaysOnTopInfo({
    required this.default$,
    required this.alt,
  });
  factory WindowSectionAlwaysOnTopInfo.fromJson(Map<String, dynamic> json) {
    return WindowSectionAlwaysOnTopInfo(
      default$: (json['default'] ?? '').toString(),
      alt: (json['alt'] ?? '').toString(),
    );
  }
  final String default$;
  final String alt;
  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class WindowSectionTimeLimit {
  const WindowSectionTimeLimit({
    required this.label,
    required this.info,
  });
  factory WindowSectionTimeLimit.fromJson(Map<String, dynamic> json) {
    return WindowSectionTimeLimit(
      label: (json['label'] ?? '').toString(),
      info: WindowSectionTimeLimitInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final WindowSectionTimeLimitInfo info;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class WindowSectionTimeLimitInfo {
  const WindowSectionTimeLimitInfo({
    required this.default$,
    required this.alt,
  });
  factory WindowSectionTimeLimitInfo.fromJson(Map<String, dynamic> json) {
    return WindowSectionTimeLimitInfo(
      default$: (json['default'] ?? '').toString(),
      alt: ({required String time}) => (json['alt'] ?? '')
          .toString()
          .replaceAll(r'${time}', time)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String default$;
  final String Function({required String time}) alt;

  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''alt''': alt,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class AddFlags {
  const AddFlags({
    required this.title,
    required this.add,
    required this.info,
  });
  factory AddFlags.fromJson(Map<String, dynamic> json) {
    return AddFlags(
      title: (json['title'] ?? '').toString(),
      add: (json['add'] ?? '').toString(),
      info: (json['info'] ?? '').toString(),
    );
  }
  final String title;
  final String add;
  final String info;
  Map<String, Object> get _content => {
        r'''title''': title,
        r'''add''': add,
        r'''info''': info,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class Connect {
  const Connect({
    required this.title,
    required this.withIp,
    required this.withMdns,
    required this.qrPair,
  });
  factory Connect.fromJson(Map<String, dynamic> json) {
    return Connect(
      title: (json['title'] ?? '').toString(),
      withIp: ConnectWithIp.fromJson(
          (json['with_ip'] as Map).cast<String, dynamic>()),
      withMdns: ConnectWithMdns.fromJson(
          (json['with_mdns'] as Map).cast<String, dynamic>()),
      qrPair: ConnectQrPair.fromJson(
          (json['qr_pair'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final ConnectWithIp withIp;

  final ConnectWithMdns withMdns;

  final ConnectQrPair qrPair;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''with_ip''': withIp,
        r'''with_mdns''': withMdns,
        r'''qr_pair''': qrPair,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class ConnectWithIp {
  const ConnectWithIp({
    required this.label,
    required this.connect,
  });
  factory ConnectWithIp.fromJson(Map<String, dynamic> json) {
    return ConnectWithIp(
      label: (json['label'] ?? '').toString(),
      connect: (json['connect'] ?? '').toString(),
    );
  }
  final String label;
  final String connect;
  Map<String, Object> get _content => {
        r'''label''': label,
        r'''connect''': connect,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class ConnectWithMdns {
  const ConnectWithMdns({
    required this.label,
  });
  factory ConnectWithMdns.fromJson(Map<String, dynamic> json) {
    return ConnectWithMdns(
      label: ({required String count}) => (json['label'] ?? '')
          .toString()
          .replaceAll(r'${count}', count)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String Function({required String count}) label;

  Map<String, Object> get _content => {
        r'''label''': label,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class ConnectQrPair {
  const ConnectQrPair({
    required this.label,
    required this.pair,
  });
  factory ConnectQrPair.fromJson(Map<String, dynamic> json) {
    return ConnectQrPair(
      label: (json['label'] ?? '').toString(),
      pair: (json['pair'] ?? '').toString(),
    );
  }
  final String label;
  final String pair;
  Map<String, Object> get _content => {
        r'''label''': label,
        r'''pair''': pair,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class TestConfigLoc {
  const TestConfigLoc({
    required this.title,
    required this.preview,
  });
  factory TestConfigLoc.fromJson(Map<String, dynamic> json) {
    return TestConfigLoc(
      title: (json['title'] ?? '').toString(),
      preview: (json['preview'] ?? '').toString(),
    );
  }
  final String title;
  final String preview;
  Map<String, Object> get _content => {
        r'''title''': title,
        r'''preview''': preview,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class ScrcpyManagerLoc {
  const ScrcpyManagerLoc({
    required this.title,
    required this.current,
  });
  factory ScrcpyManagerLoc.fromJson(Map<String, dynamic> json) {
    return ScrcpyManagerLoc(
      title: (json['title'] ?? '').toString(),
      current: ScrcpyManagerLocCurrent.fromJson(
          (json['current'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final ScrcpyManagerLocCurrent current;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''current''': current,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class ScrcpyManagerLocCurrent {
  const ScrcpyManagerLocCurrent({
    required this.label,
    required this.inUse,
    required this.latest,
    required this.exec,
  });
  factory ScrcpyManagerLocCurrent.fromJson(Map<String, dynamic> json) {
    return ScrcpyManagerLocCurrent(
      label: (json['label'] ?? '').toString(),
      inUse: (json['in_use'] ?? '').toString(),
      latest: (json['latest'] ?? '').toString(),
      exec: ScrcpyManagerLocCurrentExec.fromJson(
          (json['exec'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final String inUse;
  final String latest;
  final ScrcpyManagerLocCurrentExec exec;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''in_use''': inUse,
        r'''latest''': latest,
        r'''exec''': exec,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class ScrcpyManagerLocCurrentExec {
  const ScrcpyManagerLocCurrentExec({
    required this.open,
    required this.warning,
  });
  factory ScrcpyManagerLocCurrentExec.fromJson(Map<String, dynamic> json) {
    return ScrcpyManagerLocCurrentExec(
      open: (json['open'] ?? '').toString(),
      warning: (json['warning'] ?? '').toString(),
    );
  }
  final String open;
  final String warning;
  Map<String, Object> get _content => {
        r'''open''': open,
        r'''warning''': warning,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class SettingsLoc {
  const SettingsLoc({
    required this.title,
    required this.looks,
    required this.behaviour,
  });
  factory SettingsLoc.fromJson(Map<String, dynamic> json) {
    return SettingsLoc(
      title: (json['title'] ?? '').toString(),
      looks: SettingsLocLooks.fromJson(
          (json['looks'] as Map).cast<String, dynamic>()),
      behaviour: SettingsLocBehaviour.fromJson(
          (json['behaviour'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final SettingsLocLooks looks;

  final SettingsLocBehaviour behaviour;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''looks''': looks,
        r'''behaviour''': behaviour,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class SettingsLocLooks {
  const SettingsLocLooks({
    required this.label,
    required this.mode,
    required this.accentColor,
    required this.tintLevel,
  });
  factory SettingsLocLooks.fromJson(Map<String, dynamic> json) {
    return SettingsLocLooks(
      label: (json['label'] ?? '').toString(),
      mode: SettingsLocLooksMode.fromJson(
          (json['mode'] as Map).cast<String, dynamic>()),
      accentColor: SettingsLocLooksAccentColor.fromJson(
          (json['accent_color'] as Map).cast<String, dynamic>()),
      tintLevel: SettingsLocLooksTintLevel.fromJson(
          (json['tint_level'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final SettingsLocLooksMode mode;

  final SettingsLocLooksAccentColor accentColor;

  final SettingsLocLooksTintLevel tintLevel;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''mode''': mode,
        r'''accent_color''': accentColor,
        r'''tint_level''': tintLevel,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class SettingsLocLooksMode {
  const SettingsLocLooksMode({
    required this.label,
    required this.value,
  });
  factory SettingsLocLooksMode.fromJson(Map<String, dynamic> json) {
    return SettingsLocLooksMode(
      label: (json['label'] ?? '').toString(),
      value: SettingsLocLooksModeValue.fromJson(
          (json['value'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final SettingsLocLooksModeValue value;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''value''': value,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class SettingsLocLooksModeValue {
  const SettingsLocLooksModeValue({
    required this.dark,
    required this.light,
    required this.system,
  });
  factory SettingsLocLooksModeValue.fromJson(Map<String, dynamic> json) {
    return SettingsLocLooksModeValue(
      dark: (json['dark'] ?? '').toString(),
      light: (json['light'] ?? '').toString(),
      system: (json['system'] ?? '').toString(),
    );
  }
  final String dark;
  final String light;
  final String system;
  Map<String, Object> get _content => {
        r'''dark''': dark,
        r'''light''': light,
        r'''system''': system,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class SettingsLocLooksAccentColor {
  const SettingsLocLooksAccentColor({
    required this.label,
  });
  factory SettingsLocLooksAccentColor.fromJson(Map<String, dynamic> json) {
    return SettingsLocLooksAccentColor(
      label: (json['label'] ?? '').toString(),
    );
  }
  final String label;
  Map<String, Object> get _content => {
        r'''label''': label,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class SettingsLocLooksTintLevel {
  const SettingsLocLooksTintLevel({
    required this.label,
  });
  factory SettingsLocLooksTintLevel.fromJson(Map<String, dynamic> json) {
    return SettingsLocLooksTintLevel(
      label: (json['label'] ?? '').toString(),
    );
  }
  final String label;
  Map<String, Object> get _content => {
        r'''label''': label,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class SettingsLocBehaviour {
  const SettingsLocBehaviour({
    required this.label,
    required this.minimize,
  });
  factory SettingsLocBehaviour.fromJson(Map<String, dynamic> json) {
    return SettingsLocBehaviour(
      label: (json['label'] ?? '').toString(),
      minimize: SettingsLocBehaviourMinimize.fromJson(
          (json['minimize'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final SettingsLocBehaviourMinimize minimize;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''minimize''': minimize,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class SettingsLocBehaviourMinimize {
  const SettingsLocBehaviourMinimize({
    required this.label,
    required this.value,
  });
  factory SettingsLocBehaviourMinimize.fromJson(Map<String, dynamic> json) {
    return SettingsLocBehaviourMinimize(
      label: (json['label'] ?? '').toString(),
      value: SettingsLocBehaviourMinimizeValue.fromJson(
          (json['value'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final SettingsLocBehaviourMinimizeValue value;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''value''': value,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class SettingsLocBehaviourMinimizeValue {
  const SettingsLocBehaviourMinimizeValue({
    required this.tray,
    required this.taskbar,
  });
  factory SettingsLocBehaviourMinimizeValue.fromJson(
      Map<String, dynamic> json) {
    return SettingsLocBehaviourMinimizeValue(
      tray: (json['tray'] ?? '').toString(),
      taskbar: (json['taskbar'] ?? '').toString(),
    );
  }
  final String tray;
  final String taskbar;
  Map<String, Object> get _content => {
        r'''tray''': tray,
        r'''taskbar''': taskbar,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class ButtonLabelLoc {
  const ButtonLabelLoc({
    required this.ok,
    required this.close,
    required this.cancel,
    required this.stop,
    required this.testConfig,
  });
  factory ButtonLabelLoc.fromJson(Map<String, dynamic> json) {
    return ButtonLabelLoc(
      ok: (json['ok'] ?? '').toString(),
      close: (json['close'] ?? '').toString(),
      cancel: (json['cancel'] ?? '').toString(),
      stop: (json['stop'] ?? '').toString(),
      testConfig: (json['test_config'] ?? '').toString(),
    );
  }
  final String ok;
  final String close;
  final String cancel;
  final String stop;
  final String testConfig;
  Map<String, Object> get _content => {
        r'''ok''': ok,
        r'''close''': close,
        r'''cancel''': cancel,
        r'''stop''': stop,
        r'''test_config''': testConfig,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class StatusLoc {
  const StatusLoc({
    required this.failed,
  });
  factory StatusLoc.fromJson(Map<String, dynamic> json) {
    return StatusLoc(
      failed: (json['failed'] ?? '').toString(),
    );
  }
  final String failed;
  Map<String, Object> get _content => {
        r'''failed''': failed,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class CommonLoc {
  const CommonLoc({
    required this.default$,
    required this.yes,
    required this.no,
  });
  factory CommonLoc.fromJson(Map<String, dynamic> json) {
    return CommonLoc(
      default$: (json['default'] ?? '').toString(),
      yes: (json['yes'] ?? '').toString(),
      no: (json['no'] ?? '').toString(),
    );
  }
  final String default$;
  final String yes;
  final String no;
  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''yes''': yes,
        r'''no''': no,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

class LocalizationMessages {
  LocalizationMessages({
    required this.homeLoc,
    required this.noDeviceDialogLoc,
    required this.noConfigDialogLoc,
    required this.deviceSettingsLoc,
    required this.configScreenLoc,
    required this.logScreenLoc,
    required this.modeSection,
    required this.videoSection,
    required this.audioSection,
    required this.deviceSection,
    required this.windowSection,
    required this.addFlags,
    required this.connect,
    required this.testConfigLoc,
    required this.scrcpyManagerLoc,
    required this.settingsLoc,
    required this.buttonLabelLoc,
    required this.statusLoc,
    required this.commonLoc,
  });
  factory LocalizationMessages.fromJson(Map<String, dynamic> json) {
    return LocalizationMessages(
      homeLoc:
          HomeLoc.fromJson((json['home_loc'] as Map).cast<String, dynamic>()),
      noDeviceDialogLoc: NoDeviceDialogLoc.fromJson(
          (json['no_device_dialog_loc'] as Map).cast<String, dynamic>()),
      noConfigDialogLoc: NoConfigDialogLoc.fromJson(
          (json['no_config_dialog_loc'] as Map).cast<String, dynamic>()),
      deviceSettingsLoc: DeviceSettingsLoc.fromJson(
          (json['device_settings_loc'] as Map).cast<String, dynamic>()),
      configScreenLoc: ConfigScreenLoc.fromJson(
          (json['config_screen_loc'] as Map).cast<String, dynamic>()),
      logScreenLoc: LogScreenLoc.fromJson(
          (json['log_screen_loc'] as Map).cast<String, dynamic>()),
      modeSection: ModeSection.fromJson(
          (json['mode_section'] as Map).cast<String, dynamic>()),
      videoSection: VideoSection.fromJson(
          (json['video_section'] as Map).cast<String, dynamic>()),
      audioSection: AudioSection.fromJson(
          (json['audio_section'] as Map).cast<String, dynamic>()),
      deviceSection: DeviceSection.fromJson(
          (json['device_section'] as Map).cast<String, dynamic>()),
      windowSection: WindowSection.fromJson(
          (json['window_section'] as Map).cast<String, dynamic>()),
      addFlags:
          AddFlags.fromJson((json['add_flags'] as Map).cast<String, dynamic>()),
      connect:
          Connect.fromJson((json['connect'] as Map).cast<String, dynamic>()),
      testConfigLoc: TestConfigLoc.fromJson(
          (json['test_config_loc'] as Map).cast<String, dynamic>()),
      scrcpyManagerLoc: ScrcpyManagerLoc.fromJson(
          (json['scrcpy_manager_loc'] as Map).cast<String, dynamic>()),
      settingsLoc: SettingsLoc.fromJson(
          (json['settings_loc'] as Map).cast<String, dynamic>()),
      buttonLabelLoc: ButtonLabelLoc.fromJson(
          (json['button_label_loc'] as Map).cast<String, dynamic>()),
      statusLoc: StatusLoc.fromJson(
          (json['status_loc'] as Map).cast<String, dynamic>()),
      commonLoc: CommonLoc.fromJson(
          (json['common_loc'] as Map).cast<String, dynamic>()),
    );
  }
  final HomeLoc homeLoc;

  final NoDeviceDialogLoc noDeviceDialogLoc;

  final NoConfigDialogLoc noConfigDialogLoc;

  final DeviceSettingsLoc deviceSettingsLoc;

  final ConfigScreenLoc configScreenLoc;

  final LogScreenLoc logScreenLoc;

  final ModeSection modeSection;

  final VideoSection videoSection;

  final AudioSection audioSection;

  final DeviceSection deviceSection;

  final WindowSection windowSection;

  final AddFlags addFlags;

  final Connect connect;

  final TestConfigLoc testConfigLoc;

  final ScrcpyManagerLoc scrcpyManagerLoc;

  final SettingsLoc settingsLoc;

  final ButtonLabelLoc buttonLabelLoc;

  final StatusLoc statusLoc;

  final CommonLoc commonLoc;

  Map<String, Object> get _content => {
        r'''home_loc''': homeLoc,
        r'''no_device_dialog_loc''': noDeviceDialogLoc,
        r'''no_config_dialog_loc''': noConfigDialogLoc,
        r'''device_settings_loc''': deviceSettingsLoc,
        r'''config_screen_loc''': configScreenLoc,
        r'''log_screen_loc''': logScreenLoc,
        r'''mode_section''': modeSection,
        r'''video_section''': videoSection,
        r'''audio_section''': audioSection,
        r'''device_section''': deviceSection,
        r'''window_section''': windowSection,
        r'''add_flags''': addFlags,
        r'''connect''': connect,
        r'''test_config_loc''': testConfigLoc,
        r'''scrcpy_manager_loc''': scrcpyManagerLoc,
        r'''settings_loc''': settingsLoc,
        r'''button_label_loc''': buttonLabelLoc,
        r'''status_loc''': statusLoc,
        r'''common_loc''': commonLoc,
      };
  T getContent<T>(String key) {
    final Object? value = _content[key];
    if (value is T) {
      return value;
    }
    throw ArgumentError('Not found content for the key $key with type $T');
  }

  Map<String, Object> get content => _content;

  List<Object> get contentList => _content.values.toList();

  int get length => _content.length;

  Object? operator [](Object? key) {
    final Object? value = _content[key];
    if (value == null && key is String) {
      final int? index = int.tryParse(key);
      if (index == null || index >= contentList.length || index < 0) {
        return null;
      }

      return contentList[index];
    }
    return value;
  }
}

final LocalizationMessages en = LocalizationMessages(
  homeLoc: HomeLoc(
    title: 'Home',
    devices: HomeLocDevices(
      label: ({required String count}) => '''Connected devices (${count})''',
    ),
    deviceTile: HomeLocDeviceTile(
      runningInstances: ({required String count}) => '''Running (${count})''',
      context: HomeLocDeviceTileContext(
        disconnect: 'Disconnect',
        toWireless: 'To wireless',
        killRunning: 'Kill running instances',
      ),
    ),
    config: HomeLocConfig(
      label: 'Start scrcpy',
      new$: 'Create new config',
      select: 'Select a config',
      details: 'Show details',
      start: 'Start',
    ),
  ),
  noDeviceDialogLoc: NoDeviceDialogLoc(
    title: 'Device',
    contents:
        '''No device selected. \nSelect a device to edit scrcpy config.''',
  ),
  noConfigDialogLoc: NoConfigDialogLoc(
    title: 'Config',
    contents: '''No config selected.\nSelect a scrcpy config to start.''',
  ),
  deviceSettingsLoc: DeviceSettingsLoc(
    title: 'Settings',
    info: 'Info',
    refresh: 'Refresh info',
    rename: DeviceSettingsLocRename(
      label: 'Rename',
      info: 'Press [Enter] to apply name',
    ),
    autoConnect: DeviceSettingsLocAutoConnect(
      label: 'Auto connect',
      info: 'Auto connect wireless device',
    ),
    onConnected: DeviceSettingsLocOnConnected(
      label: 'On connected',
      info:
          'Start (1) scrcpy instance with selected config on device connection',
    ),
    doNothing: 'Do nothing',
    scrcpyInfo: DeviceSettingsLocScrcpyInfo(
      fetching: 'Getting scrcpy info',
      label: 'Scrcpy info',
      name: 'Name',
      id: 'ID',
      model: 'Model',
      version: 'Android version',
      displays: 'Displays',
      cameras: 'Cameras',
      videoEnc: 'Video encoders',
      audioEnc: 'Audio encoders',
    ),
  ),
  configScreenLoc: ConfigScreenLoc(
    connectionLost: 'Device connection lost',
  ),
  logScreenLoc: LogScreenLoc(
    title: 'Test log',
    dialog: LogScreenLocDialog(
      title: 'Command',
    ),
  ),
  modeSection: ModeSection(
    title: 'Mode',
    saveFolder: ModeSectionSaveFolder(
      label: 'Save folder',
      info: '''appends save path to '--record=savepath/file' ''',
    ),
    mainMode: ModeSectionMainMode(
      label: 'Mode',
      mirror: 'Mirror',
      record: 'Record',
      info: ModeSectionMainModeInfo(
        default$: 'mirror or record, no flag for mirror',
        alt: '''uses '--record=' flag''',
      ),
    ),
    scrcpyMode: ModeSectionScrcpyMode(
      both: 'Both',
      audioOnly: 'Audio only',
      videoOnly: 'Video only',
      info: ModeSectionScrcpyModeInfo(
        default$: 'defaults to both, no flag',
        alt: ({required String command}) => '''uses '${command}' flag''',
      ),
    ),
  ),
  videoSection: VideoSection(
    title: 'Video',
    displays: VideoSectionDisplays(
      label: 'Displays',
      info: VideoSectionDisplaysInfo(
        default$:
            'defaults to first available, no flag; virtual displays is not listed',
        alt: '''uses '--display-id=' flag''',
      ),
    ),
    codec: VideoSectionCodec(
      label: 'Codec',
      info: VideoSectionCodecInfo(
        default$: 'defaults to h264, no flag',
        alt: ({required String codec}) =>
            '''uses '--video-codec=${codec}' flag''',
      ),
    ),
    encoder: VideoSectionEncoder(
      label: 'Encoder',
      info: VideoSectionEncoderInfo(
        default$: 'defaults to first available, no flag',
        alt: ({required String encoder}) =>
            '''uses '--video-encoder=${encoder}' flag''',
      ),
    ),
    format: VideoSectionFormat(
      label: 'Format',
      info: VideoSectionFormatInfo(
        default$: ({required String format}) =>
            '''appends format to '--record=savepath/file${format}' "''',
      ),
    ),
    bitrate: VideoSectionBitrate(
      label: 'Bitrate',
      info: VideoSectionBitrateInfo(
        default$: 'defaults to 8M, no flag',
        alt: ({required String bitrate}) =>
            '''uses '--video-bit-rate=${bitrate}M' flag''',
      ),
    ),
    fpsLimit: VideoSectionFpsLimit(
      label: 'FPS limit',
      info: VideoSectionFpsLimitInfo(
        default$: 'no flag unless set',
        alt: ({required String fps}) => '''uses '--max-fps=${fps}' flag''',
      ),
    ),
    resolutionScale: VideoSectionResolutionScale(
      label: 'Resolution scale',
      info: VideoSectionResolutionScaleInfo(
        default$:
            '''calculated based on device's resolution, no flag unless set''',
        alt: ({required String size}) => '''uses '--max-size=${size}' flag''',
      ),
    ),
  ),
  audioSection: AudioSection(
    title: 'Audio',
    duplicate: AudioSectionDuplicate(
      label: 'Duplicate audio',
      info: AudioSectionDuplicateInfo(
        default$: 'only for Android 13 and above',
        alt: '''uses '--audio-dup' flag''',
      ),
    ),
    source: AudioSectionSource(
      label: 'Source',
      info: AudioSectionSourceInfo(
        default$: 'defaults to output, no flag',
        alt: ({required String source}) => '''uses '${source}' flag''',
        inCaseOfDup: '''implied to 'Playback' with '--audio-dup', no flag''',
      ),
    ),
    codec: AudioSectionCodec(
      label: 'Codec',
      info: AudioSectionCodecInfo(
        default$: 'defaults to opus, no flag',
        alt: ({required String codec}) =>
            '''uses '--audio-codec=${codec}' flag''',
        isAudioOnly: ({required String format, required String codec}) =>
            '''Format: ${format}, requires Codec: ${codec}''',
      ),
    ),
    encoder: AudioSectionEncoder(
      label: 'Encoder',
      info: AudioSectionEncoderInfo(
        default$: 'defaults to first available, no flag',
        alt: ({required String encoder}) =>
            '''uses '--audio-encoder=${encoder}' flag''',
      ),
    ),
    format: AudioSectionFormat(
      label: 'Format',
      info: AudioSectionFormatInfo(
        default$: ({required String format}) =>
            '''appends format to '--record=savepath/file.${format}' "''',
      ),
    ),
    bitrate: AudioSectionBitrate(
      label: 'Bitrate',
      info: AudioSectionBitrateInfo(
        default$: 'defaults to 128k, no flag',
        alt: ({required String bitrate}) =>
            '''uses '--audio-bit-rate=${bitrate}K' flag''',
      ),
    ),
  ),
  deviceSection: DeviceSection(
    title: 'Device',
    stayAwake: DeviceSectionStayAwake(
      label: 'Stay awake',
      info: DeviceSectionStayAwakeInfo(
        default$:
            'prevent the device from sleeping, only works with usb connection',
        alt: '''uses '--stay-awake' flag''',
      ),
    ),
    showTouches: DeviceSectionShowTouches(
      label: 'Show touches',
      info: DeviceSectionShowTouchesInfo(
        default$:
            'show finger touches, only works with physical touches on the device',
        alt: '''uses '--show-touches' flag''',
      ),
    ),
    offDisplayStart: DeviceSectionOffDisplayStart(
      label: 'Turn off display on start',
      info: DeviceSectionOffDisplayStartInfo(
        default$: 'turn device display off, on scrcpy start',
        alt: '''uses '--turn-screen-off' flag''',
      ),
    ),
    offDisplayExit: DeviceSectionOffDisplayExit(
      label: 'Turn off display on exit',
      info: DeviceSectionOffDisplayExitInfo(
        default$: 'turn device display off, on scrcpy exit',
        alt: '''uses '--power-off-on-close' flag''',
      ),
    ),
    screensaver: DeviceSectionScreensaver(
      label: 'Disable screensaver (HOST)',
      info: DeviceSectionScreensaverInfo(
        default$: 'disable screensaver',
        alt: '''uses '--disable-screensaver' flag''',
      ),
    ),
  ),
  windowSection: WindowSection(
    title: 'Window',
    hideWindow: WindowSectionHideWindow(
      label: 'Hide window',
      info: WindowSectionHideWindowInfo(
        default$: 'start scrcpy with no window',
        alt: '''uses '--no-window' flag''',
      ),
    ),
    borderless: WindowSectionBorderless(
      label: 'Borderless',
      info: WindowSectionBorderlessInfo(
        default$: 'disable window decorations',
        alt: '''uses '--window-borderless' flag''',
      ),
    ),
    alwaysOnTop: WindowSectionAlwaysOnTop(
      label: 'Always on top',
      info: WindowSectionAlwaysOnTopInfo(
        default$: 'scrcpy window always on top',
        alt: '''uses '--always-on-top' flag''',
      ),
    ),
    timeLimit: WindowSectionTimeLimit(
      label: 'Time limit',
      info: WindowSectionTimeLimitInfo(
        default$: 'limits scrcpy session, in seconds',
        alt: ({required String time}) => '''uses '--time-limit=${time}' flag''',
      ),
    ),
  ),
  addFlags: AddFlags(
    title: 'Additional flags',
    add: 'Add',
    info: 'avoid using flags that are already an option',
  ),
  connect: Connect(
    title: 'Connect',
    withIp: ConnectWithIp(
      label: 'Connect with IP',
      connect: 'Connect',
    ),
    withMdns: ConnectWithMdns(
      label: ({required String count}) => '''MDNS devices (${count})''',
    ),
    qrPair: ConnectQrPair(
      label: 'QR pairing',
      pair: 'Pair device',
    ),
  ),
  testConfigLoc: TestConfigLoc(
    title: 'Test config',
    preview: 'Command preview',
  ),
  scrcpyManagerLoc: ScrcpyManagerLoc(
    title: 'Scrcpy Manager',
    current: ScrcpyManagerLocCurrent(
      label: 'Current',
      inUse: 'In-use',
      latest: 'latest',
      exec: ScrcpyManagerLocCurrentExec(
        open: 'Open executable location',
        warning: 'Modify with care',
      ),
    ),
  ),
  settingsLoc: SettingsLoc(
    title: 'Settings',
    looks: SettingsLocLooks(
      label: 'Looks',
      mode: SettingsLocLooksMode(
        label: 'Theme mode',
        value: SettingsLocLooksModeValue(
          dark: 'Dark',
          light: 'Light',
          system: 'System',
        ),
      ),
      accentColor: SettingsLocLooksAccentColor(
        label: 'Accent color',
      ),
      tintLevel: SettingsLocLooksTintLevel(
        label: 'Tint level',
      ),
    ),
    behaviour: SettingsLocBehaviour(
      label: 'App behaviour',
      minimize: SettingsLocBehaviourMinimize(
        label: 'Minimize',
        value: SettingsLocBehaviourMinimizeValue(
          tray: 'to tray',
          taskbar: 'to taskbar',
        ),
      ),
    ),
  ),
  buttonLabelLoc: ButtonLabelLoc(
    ok: '',
    close: 'Close',
    cancel: 'Cancel',
    stop: 'Stop',
    testConfig: 'Test config',
  ),
  statusLoc: StatusLoc(
    failed: 'Failed',
  ),
  commonLoc: CommonLoc(
    default$: 'Default',
    yes: 'Yes',
    no: 'No',
  ),
);
final Map<Locale, LocalizationMessages> _languageMap = {
  Locale('en'): en,
};

final Map<Locale, LocalizationMessages> _providersLanguagesMap = {};

class EasiestLocalizationDelegate
    extends LocalizationsDelegate<LocalizationMessages> {
  EasiestLocalizationDelegate({
    List<LocalizationProvider<LocalizationMessages>> providers = const [],
  }) {
    providers.forEach(registerProvider);
  }

  final List<LocalizationProvider<LocalizationMessages>> _providers = [];

  void registerProvider(LocalizationProvider<LocalizationMessages> provider) {
    _providers.add(provider);
  }

  @override
  bool isSupported(Locale locale) {
    final bool supportedByProviders =
        _providers.any((LocalizationProvider value) => value.canLoad(locale));
    if (supportedByProviders) {
      return true;
    }
    final bool hasInLanguageMap = _languageMap.containsKey(locale);
    if (hasInLanguageMap) {
      return true;
    }
    for (final Locale supportedLocale in _languageMap.keys) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  Future<LocalizationMessages> load(Locale locale) async {
    Intl.defaultLocale = locale.toString();

    LocalizationProvider<LocalizationMessages>? localizationProvider;

    for (final LocalizationProvider<LocalizationMessages> provider
        in _providers) {
      if (provider.canLoad(locale)) {
        localizationProvider = provider;
        break;
      }
    }

    LocalizationMessages? localeContent;

    if (localizationProvider != null) {
      try {
        localeContent = await localizationProvider.fetchLocalization(locale);
        _providersLanguagesMap[locale] = localeContent;
      } catch (error, stackTrace) {
        log('Error on loading localization with provider "${localizationProvider.name}"',
            error: error, stackTrace: stackTrace);
      }
    }

    localeContent ??= _loadLocalLocale(locale) ?? _languageMap.values.first;
    return localeContent;
  }

  @override
  bool shouldReload(LocalizationsDelegate<LocalizationMessages> old) =>
      old != this;
}

class Messages {
  static LocalizationMessages of(BuildContext context) =>
      Localizations.of(context, LocalizationMessages)!;

  static LocalizationMessages? getContent(Locale locale) =>
      _loadLocalLocale(locale);

  static LocalizationMessages get el {
    final String? defaultLocaleString = Intl.defaultLocale;
    final List<String> localeParticles = defaultLocaleString == null
        ? []
        : defaultLocaleString.split(RegExp(r'[_-]'));
    final Locale? defaultLocale = localeParticles.isEmpty
        ? null
        : Locale(localeParticles.first,
            localeParticles.length > 1 ? localeParticles[1] : null);
    LocalizationMessages? localeContent = _providersLanguagesMap[defaultLocale];
    localeContent ??= _languageMap[defaultLocale] ?? _languageMap.values.first;
    return localeContent;
  }
}

LocalizationMessages? _loadLocalLocale(Locale locale) {
  final bool hasInLanguageMap = _languageMap.containsKey(locale);
  if (hasInLanguageMap) {
    return _languageMap[locale];
  }
  for (final Locale supportedLocale in _languageMap.keys) {
    if (supportedLocale.languageCode == locale.languageCode) {
      return _languageMap[supportedLocale];
    }
  }
  return null;
}

LocalizationMessages get el => Messages.el;

final List<LocalizationsDelegate> localizationsDelegates = [
  EasiestLocalizationDelegate(),
  ...GlobalMaterialLocalizations.delegates,
];

List<LocalizationsDelegate> localizationsDelegatesWithProviders(
    List<LocalizationProvider<LocalizationMessages>> providers) {
  return [
    EasiestLocalizationDelegate(providers: providers),
    ...GlobalMaterialLocalizations.delegates,
  ];
}

// Supported locales: en
const List<Locale> supportedLocales = [
  Locale('en'),
];

List<Locale> supportedLocalesWithProviders(
        List<LocalizationProvider<LocalizationMessages>> providers) =>
    [
      for (final LocalizationProvider provider in providers)
        ...provider.supportedLocales,
      ...supportedLocales,
    ];

extension EasiestLocalizationContext on BuildContext {
  LocalizationMessages get el {
    return Messages.of(this);
  }

  dynamic tr(String key) => key.tr();
}

extension EasiestLocalizationString on String {
  dynamic get el {
    final List<String> groupOfStrings = contains('.') ? split('.') : [this];
    dynamic targetContent;
    for (int i = 0; i < groupOfStrings.length; i++) {
      final String key = groupOfStrings[i];
      if (i == 0) {
        targetContent = Messages.el[key];
        if (targetContent == null) {
          return '';
        }
      } else {
        try {
          targetContent = targetContent[key];
          if (targetContent == null) {
            return '';
          }
        } catch (error) {
          if (kDebugMode) {
            print(
                '[ERROR] Incorrect retrieving of value by key "$key" from value "$targetContent"; Original key was "$this"');
          }
          return '';
        }
      }
    }
    return targetContent;
  }

  dynamic tr() => el;
}

dynamic tr(String key) => key.tr();
