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

class HomeTab {
  const HomeTab({
    required this.title,
    required this.devices,
    required this.deviceTile,
    required this.config,
  });
  factory HomeTab.fromJson(Map<String, dynamic> json) {
    return HomeTab(
      title: (json['title'] ?? '').toString(),
      devices: HomeTabDevices.fromJson(
          (json['devices'] as Map).cast<String, dynamic>()),
      deviceTile: HomeTabDeviceTile.fromJson(
          (json['device_tile'] as Map).cast<String, dynamic>()),
      config: HomeTabConfig.fromJson(
          (json['config'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final HomeTabDevices devices;

  final HomeTabDeviceTile deviceTile;

  final HomeTabConfig config;

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

class HomeTabDevices {
  const HomeTabDevices({
    required this.label,
  });
  factory HomeTabDevices.fromJson(Map<String, dynamic> json) {
    return HomeTabDevices(
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

class HomeTabDeviceTile {
  const HomeTabDeviceTile({
    required this.runningInstances,
    required this.context,
  });
  factory HomeTabDeviceTile.fromJson(Map<String, dynamic> json) {
    return HomeTabDeviceTile(
      runningInstances: ({required String count}) =>
          (json['running_instances'] ?? '')
              .toString()
              .replaceAll(r'${count}', count)
              .replaceAll(_variableRegExp, ''),
      context: HomeTabDeviceTileContext.fromJson(
          (json['context'] as Map).cast<String, dynamic>()),
    );
  }
  final String Function({required String count}) runningInstances;

  final HomeTabDeviceTileContext context;

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

class HomeTabDeviceTileContext {
  const HomeTabDeviceTileContext({
    required this.disconnect,
    required this.toWireless,
    required this.killRunning,
  });
  factory HomeTabDeviceTileContext.fromJson(Map<String, dynamic> json) {
    return HomeTabDeviceTileContext(
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

class HomeTabConfig {
  const HomeTabConfig({
    required this.label,
    required this.new$,
    required this.select,
    required this.details,
    required this.start,
  });
  factory HomeTabConfig.fromJson(Map<String, dynamic> json) {
    return HomeTabConfig(
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

class NoDeviceDialog {
  const NoDeviceDialog({
    required this.title,
    required this.contents,
  });
  factory NoDeviceDialog.fromJson(Map<String, dynamic> json) {
    return NoDeviceDialog(
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

class NoConfigDialog {
  const NoConfigDialog({
    required this.title,
    required this.contents,
  });
  factory NoConfigDialog.fromJson(Map<String, dynamic> json) {
    return NoConfigDialog(
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

class DeviceSettingsScreen {
  const DeviceSettingsScreen({
    required this.title,
    required this.info,
    required this.refresh,
    required this.rename,
    required this.autoConnect,
    required this.onConnected,
    required this.doNothing,
    required this.scrcpyInfo,
  });
  factory DeviceSettingsScreen.fromJson(Map<String, dynamic> json) {
    return DeviceSettingsScreen(
      title: (json['title'] ?? '').toString(),
      info: (json['info'] ?? '').toString(),
      refresh: (json['refresh'] ?? '').toString(),
      rename: DeviceSettingsScreenRename.fromJson(
          (json['rename'] as Map).cast<String, dynamic>()),
      autoConnect: DeviceSettingsScreenAutoConnect.fromJson(
          (json['auto_connect'] as Map).cast<String, dynamic>()),
      onConnected: DeviceSettingsScreenOnConnected.fromJson(
          (json['on_connected'] as Map).cast<String, dynamic>()),
      doNothing: (json['do_nothing'] ?? '').toString(),
      scrcpyInfo: DeviceSettingsScreenScrcpyInfo.fromJson(
          (json['scrcpy_info'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final String info;
  final String refresh;
  final DeviceSettingsScreenRename rename;

  final DeviceSettingsScreenAutoConnect autoConnect;

  final DeviceSettingsScreenOnConnected onConnected;

  final String doNothing;
  final DeviceSettingsScreenScrcpyInfo scrcpyInfo;

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

class DeviceSettingsScreenRename {
  const DeviceSettingsScreenRename({
    required this.label,
    required this.info,
  });
  factory DeviceSettingsScreenRename.fromJson(Map<String, dynamic> json) {
    return DeviceSettingsScreenRename(
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

class DeviceSettingsScreenAutoConnect {
  const DeviceSettingsScreenAutoConnect({
    required this.label,
    required this.info,
  });
  factory DeviceSettingsScreenAutoConnect.fromJson(Map<String, dynamic> json) {
    return DeviceSettingsScreenAutoConnect(
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

class DeviceSettingsScreenOnConnected {
  const DeviceSettingsScreenOnConnected({
    required this.label,
    required this.info,
  });
  factory DeviceSettingsScreenOnConnected.fromJson(Map<String, dynamic> json) {
    return DeviceSettingsScreenOnConnected(
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

class DeviceSettingsScreenScrcpyInfo {
  const DeviceSettingsScreenScrcpyInfo({
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
  factory DeviceSettingsScreenScrcpyInfo.fromJson(Map<String, dynamic> json) {
    return DeviceSettingsScreenScrcpyInfo(
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

class ConfigScreen {
  const ConfigScreen({
    required this.connectionLost,
  });
  factory ConfigScreen.fromJson(Map<String, dynamic> json) {
    return ConfigScreen(
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

class ScrcpyManager {
  const ScrcpyManager({
    required this.title,
    required this.current,
  });
  factory ScrcpyManager.fromJson(Map<String, dynamic> json) {
    return ScrcpyManager(
      title: (json['title'] ?? '').toString(),
      current: ScrcpyManagerCurrent.fromJson(
          (json['current'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final ScrcpyManagerCurrent current;

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

class ScrcpyManagerCurrent {
  const ScrcpyManagerCurrent({
    required this.label,
    required this.inUse,
    required this.latest,
    required this.exec,
  });
  factory ScrcpyManagerCurrent.fromJson(Map<String, dynamic> json) {
    return ScrcpyManagerCurrent(
      label: (json['label'] ?? '').toString(),
      inUse: (json['in_use'] ?? '').toString(),
      latest: (json['latest'] ?? '').toString(),
      exec: ScrcpyManagerCurrentExec.fromJson(
          (json['exec'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final String inUse;
  final String latest;
  final ScrcpyManagerCurrentExec exec;

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

class ScrcpyManagerCurrentExec {
  const ScrcpyManagerCurrentExec({
    required this.open,
    required this.warning,
  });
  factory ScrcpyManagerCurrentExec.fromJson(Map<String, dynamic> json) {
    return ScrcpyManagerCurrentExec(
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

class Settings {
  const Settings({
    required this.title,
    required this.looks,
  });
  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      title: (json['title'] ?? '').toString(),
      looks: SettingsLooks.fromJson(
          (json['looks'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final SettingsLooks looks;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''looks''': looks,
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

class SettingsLooks {
  const SettingsLooks({
    required this.label,
    required this.theme,
  });
  factory SettingsLooks.fromJson(Map<String, dynamic> json) {
    return SettingsLooks(
      label: (json['label'] ?? '').toString(),
      theme: SettingsLooksTheme.fromJson(
          (json['theme'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final SettingsLooksTheme theme;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''theme''': theme,
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

class SettingsLooksTheme {
  const SettingsLooksTheme({
    required this.mode,
    required this.dark,
    required this.light,
    required this.system,
  });
  factory SettingsLooksTheme.fromJson(Map<String, dynamic> json) {
    return SettingsLooksTheme(
      mode: (json['mode'] ?? '').toString(),
      dark: (json['dark'] ?? '').toString(),
      light: (json['light'] ?? '').toString(),
      system: (json['system'] ?? '').toString(),
    );
  }
  final String mode;
  final String dark;
  final String light;
  final String system;
  Map<String, Object> get _content => {
        r'''mode''': mode,
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

class ButtonLabel {
  const ButtonLabel({
    required this.ok,
    required this.close,
    required this.cancel,
  });
  factory ButtonLabel.fromJson(Map<String, dynamic> json) {
    return ButtonLabel(
      ok: (json['ok'] ?? '').toString(),
      close: (json['close'] ?? '').toString(),
      cancel: (json['cancel'] ?? '').toString(),
    );
  }
  final String ok;
  final String close;
  final String cancel;
  Map<String, Object> get _content => {
        r'''ok''': ok,
        r'''close''': close,
        r'''cancel''': cancel,
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

class Status {
  const Status({
    required this.failed,
  });
  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
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

class LocalizationMessages {
  LocalizationMessages({
    required this.homeTab,
    required this.noDeviceDialog,
    required this.noConfigDialog,
    required this.deviceSettingsScreen,
    required this.configScreen,
    required this.modeSection,
    required this.videoSection,
    required this.connect,
    required this.scrcpyManager,
    required this.settings,
    required this.buttonLabel,
    required this.status,
  });
  factory LocalizationMessages.fromJson(Map<String, dynamic> json) {
    return LocalizationMessages(
      homeTab:
          HomeTab.fromJson((json['home_tab'] as Map).cast<String, dynamic>()),
      noDeviceDialog: NoDeviceDialog.fromJson(
          (json['no_device_dialog'] as Map).cast<String, dynamic>()),
      noConfigDialog: NoConfigDialog.fromJson(
          (json['no_config_dialog'] as Map).cast<String, dynamic>()),
      deviceSettingsScreen: DeviceSettingsScreen.fromJson(
          (json['device_settings_screen'] as Map).cast<String, dynamic>()),
      configScreen: ConfigScreen.fromJson(
          (json['config_screen'] as Map).cast<String, dynamic>()),
      modeSection: ModeSection.fromJson(
          (json['mode_section'] as Map).cast<String, dynamic>()),
      videoSection: VideoSection.fromJson(
          (json['video_section'] as Map).cast<String, dynamic>()),
      connect:
          Connect.fromJson((json['connect'] as Map).cast<String, dynamic>()),
      scrcpyManager: ScrcpyManager.fromJson(
          (json['scrcpy_manager'] as Map).cast<String, dynamic>()),
      settings:
          Settings.fromJson((json['settings'] as Map).cast<String, dynamic>()),
      buttonLabel: ButtonLabel.fromJson(
          (json['button_label'] as Map).cast<String, dynamic>()),
      status: Status.fromJson((json['status'] as Map).cast<String, dynamic>()),
    );
  }
  final HomeTab homeTab;

  final NoDeviceDialog noDeviceDialog;

  final NoConfigDialog noConfigDialog;

  final DeviceSettingsScreen deviceSettingsScreen;

  final ConfigScreen configScreen;

  final ModeSection modeSection;

  final VideoSection videoSection;

  final Connect connect;

  final ScrcpyManager scrcpyManager;

  final Settings settings;

  final ButtonLabel buttonLabel;

  final Status status;

  Map<String, Object> get _content => {
        r'''home_tab''': homeTab,
        r'''no_device_dialog''': noDeviceDialog,
        r'''no_config_dialog''': noConfigDialog,
        r'''device_settings_screen''': deviceSettingsScreen,
        r'''config_screen''': configScreen,
        r'''mode_section''': modeSection,
        r'''video_section''': videoSection,
        r'''connect''': connect,
        r'''scrcpy_manager''': scrcpyManager,
        r'''settings''': settings,
        r'''button_label''': buttonLabel,
        r'''status''': status,
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
  homeTab: HomeTab(
    title: 'Home',
    devices: HomeTabDevices(
      label: ({required String count}) => '''Connected devices (${count})''',
    ),
    deviceTile: HomeTabDeviceTile(
      runningInstances: ({required String count}) => '''Running (${count})''',
      context: HomeTabDeviceTileContext(
        disconnect: 'Disconnect',
        toWireless: 'To wireless',
        killRunning: 'Kill running instances',
      ),
    ),
    config: HomeTabConfig(
      label: 'Start scrcpy',
      new$: 'Create new config',
      select: 'Select a config',
      details: 'Show details',
      start: 'Start',
    ),
  ),
  noDeviceDialog: NoDeviceDialog(
    title: 'Device',
    contents:
        '''No device selected. \nSelect a device to edit scrcpy config.''',
  ),
  noConfigDialog: NoConfigDialog(
    title: 'Config',
    contents: '''No config selected.\nSelect a scrcpy config to start.''',
  ),
  deviceSettingsScreen: DeviceSettingsScreen(
    title: 'Settings',
    info: 'Info',
    refresh: 'Refresh info',
    rename: DeviceSettingsScreenRename(
      label: 'Rename',
      info: 'Press [Enter] to apply name',
    ),
    autoConnect: DeviceSettingsScreenAutoConnect(
      label: 'Auto connect',
      info: 'Auto connect wireless device',
    ),
    onConnected: DeviceSettingsScreenOnConnected(
      label: 'On connected',
      info:
          'Start (1) scrcpy instance with selected config on device connection',
    ),
    doNothing: 'Do nothing',
    scrcpyInfo: DeviceSettingsScreenScrcpyInfo(
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
  configScreen: ConfigScreen(
    connectionLost: 'Device connection lost',
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
  scrcpyManager: ScrcpyManager(
    title: 'Scrcpy Manager',
    current: ScrcpyManagerCurrent(
      label: 'Current',
      inUse: 'In-use',
      latest: 'latest',
      exec: ScrcpyManagerCurrentExec(
        open: 'Open executable location',
        warning: 'Modify with care',
      ),
    ),
  ),
  settings: Settings(
    title: 'Settings',
    looks: SettingsLooks(
      label: 'Looks',
      theme: SettingsLooksTheme(
        mode: 'Theme mode',
        dark: 'Dark',
        light: 'Light',
        system: 'System',
      ),
    ),
  ),
  buttonLabel: ButtonLabel(
    ok: '',
    close: 'Close',
    cancel: 'cancel',
  ),
  status: Status(
    failed: 'Failed',
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
