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
  });
  factory HomeLoc.fromJson(Map<String, dynamic> json) {
    return HomeLoc(
      title: (json['title'] ?? '').toString(),
      devices: HomeLocDevices.fromJson(
          (json['devices'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final HomeLocDevices devices;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''devices''': devices,
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

class DeviceTileLoc {
  const DeviceTileLoc({
    required this.runningInstances,
    required this.context,
  });
  factory DeviceTileLoc.fromJson(Map<String, dynamic> json) {
    return DeviceTileLoc(
      runningInstances: ({required String count}) =>
          (json['running_instances'] ?? '')
              .toString()
              .replaceAll(r'${count}', count)
              .replaceAll(_variableRegExp, ''),
      context: DeviceTileLocContext.fromJson(
          (json['context'] as Map).cast<String, dynamic>()),
    );
  }
  final String Function({required String count}) runningInstances;

  final DeviceTileLocContext context;

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

class DeviceTileLocContext {
  const DeviceTileLocContext({
    required this.disconnect,
    required this.toWireless,
    required this.killRunning,
    required this.scrcpy,
    required this.all,
    required this.allScrcpy,
    required this.manage,
  });
  factory DeviceTileLocContext.fromJson(Map<String, dynamic> json) {
    return DeviceTileLocContext(
      disconnect: (json['disconnect'] ?? '').toString(),
      toWireless: (json['to_wireless'] ?? '').toString(),
      killRunning: (json['kill_running'] ?? '').toString(),
      scrcpy: (json['scrcpy'] ?? '').toString(),
      all: (json['all'] ?? '').toString(),
      allScrcpy: (json['all_scrcpy'] ?? '').toString(),
      manage: (json['manage'] ?? '').toString(),
    );
  }
  final String disconnect;
  final String toWireless;
  final String killRunning;
  final String scrcpy;
  final String all;
  final String allScrcpy;
  final String manage;
  Map<String, Object> get _content => {
        r'''disconnect''': disconnect,
        r'''to_wireless''': toWireless,
        r'''kill_running''': killRunning,
        r'''scrcpy''': scrcpy,
        r'''all''': all,
        r'''all_scrcpy''': allScrcpy,
        r'''manage''': manage,
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

class LoungeLoc {
  const LoungeLoc({
    required this.controls,
    required this.pinnedApps,
    required this.launcher,
    required this.running,
    required this.appTile,
    required this.placeholders,
    required this.tooltip,
    required this.info,
  });
  factory LoungeLoc.fromJson(Map<String, dynamic> json) {
    return LoungeLoc(
      controls: LoungeLocControls.fromJson(
          (json['controls'] as Map).cast<String, dynamic>()),
      pinnedApps: LoungeLocPinnedApps.fromJson(
          (json['pinned_apps'] as Map).cast<String, dynamic>()),
      launcher: LoungeLocLauncher.fromJson(
          (json['launcher'] as Map).cast<String, dynamic>()),
      running: LoungeLocRunning.fromJson(
          (json['running'] as Map).cast<String, dynamic>()),
      appTile: LoungeLocAppTile.fromJson(
          (json['app_tile'] as Map).cast<String, dynamic>()),
      placeholders: LoungeLocPlaceholders.fromJson(
          (json['placeholders'] as Map).cast<String, dynamic>()),
      tooltip: LoungeLocTooltip.fromJson(
          (json['tooltip'] as Map).cast<String, dynamic>()),
      info:
          LoungeLocInfo.fromJson((json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final LoungeLocControls controls;

  final LoungeLocPinnedApps pinnedApps;

  final LoungeLocLauncher launcher;

  final LoungeLocRunning running;

  final LoungeLocAppTile appTile;

  final LoungeLocPlaceholders placeholders;

  final LoungeLocTooltip tooltip;

  final LoungeLocInfo info;

  Map<String, Object> get _content => {
        r'''controls''': controls,
        r'''pinned_apps''': pinnedApps,
        r'''launcher''': launcher,
        r'''running''': running,
        r'''app_tile''': appTile,
        r'''placeholders''': placeholders,
        r'''tooltip''': tooltip,
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

class LoungeLocControls {
  const LoungeLocControls({
    required this.label,
  });
  factory LoungeLocControls.fromJson(Map<String, dynamic> json) {
    return LoungeLocControls(
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

class LoungeLocPinnedApps {
  const LoungeLocPinnedApps({
    required this.label,
  });
  factory LoungeLocPinnedApps.fromJson(Map<String, dynamic> json) {
    return LoungeLocPinnedApps(
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

class LoungeLocLauncher {
  const LoungeLocLauncher({
    required this.label,
  });
  factory LoungeLocLauncher.fromJson(Map<String, dynamic> json) {
    return LoungeLocLauncher(
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

class LoungeLocRunning {
  const LoungeLocRunning({
    required this.label,
  });
  factory LoungeLocRunning.fromJson(Map<String, dynamic> json) {
    return LoungeLocRunning(
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

class LoungeLocAppTile {
  const LoungeLocAppTile({
    required this.contextMenu,
  });
  factory LoungeLocAppTile.fromJson(Map<String, dynamic> json) {
    return LoungeLocAppTile(
      contextMenu: LoungeLocAppTileContextMenu.fromJson(
          (json['context_menu'] as Map).cast<String, dynamic>()),
    );
  }
  final LoungeLocAppTileContextMenu contextMenu;

  Map<String, Object> get _content => {
        r'''context_menu''': contextMenu,
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

class LoungeLocAppTileContextMenu {
  const LoungeLocAppTileContextMenu({
    required this.pin,
    required this.unpin,
    required this.forceClose,
    required this.selectConfig,
  });
  factory LoungeLocAppTileContextMenu.fromJson(Map<String, dynamic> json) {
    return LoungeLocAppTileContextMenu(
      pin: ({required String config}) => (json['pin'] ?? '')
          .toString()
          .replaceAll(r'${config}', config)
          .replaceAll(_variableRegExp, ''),
      unpin: (json['unpin'] ?? '').toString(),
      forceClose: (json['force_close'] ?? '').toString(),
      selectConfig: (json['select_config'] ?? '').toString(),
    );
  }
  final String Function({required String config}) pin;

  final String unpin;
  final String forceClose;
  final String selectConfig;
  Map<String, Object> get _content => {
        r'''pin''': pin,
        r'''unpin''': unpin,
        r'''force_close''': forceClose,
        r'''select_config''': selectConfig,
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

class LoungeLocPlaceholders {
  const LoungeLocPlaceholders({
    required this.config,
    required this.app,
    required this.search,
  });
  factory LoungeLocPlaceholders.fromJson(Map<String, dynamic> json) {
    return LoungeLocPlaceholders(
      config: (json['config'] ?? '').toString(),
      app: (json['app'] ?? '').toString(),
      search: (json['search'] ?? '').toString(),
    );
  }
  final String config;
  final String app;
  final String search;
  Map<String, Object> get _content => {
        r'''config''': config,
        r'''app''': app,
        r'''search''': search,
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

class LoungeLocTooltip {
  const LoungeLocTooltip({
    required this.missingConfig,
    required this.pin,
    required this.onConfig,
  });
  factory LoungeLocTooltip.fromJson(Map<String, dynamic> json) {
    return LoungeLocTooltip(
      missingConfig: ({required String config}) =>
          (json['missing_config'] ?? '')
              .toString()
              .replaceAll(r'${config}', config)
              .replaceAll(_variableRegExp, ''),
      pin: (json['pin'] ?? '').toString(),
      onConfig: ({required String config}) => (json['on_config'] ?? '')
          .toString()
          .replaceAll(r'${config}', config)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String Function({required String config}) missingConfig;

  final String pin;
  final String Function({required String config}) onConfig;

  Map<String, Object> get _content => {
        r'''missing_config''': missingConfig,
        r'''pin''': pin,
        r'''on_config''': onConfig,
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

class LoungeLocInfo {
  const LoungeLocInfo({
    required this.emptySearch,
    required this.emptyPin,
    required this.emptyInstance,
  });
  factory LoungeLocInfo.fromJson(Map<String, dynamic> json) {
    return LoungeLocInfo(
      emptySearch: (json['empty_search'] ?? '').toString(),
      emptyPin: (json['empty_pin'] ?? '').toString(),
      emptyInstance: (json['empty_instance'] ?? '').toString(),
    );
  }
  final String emptySearch;
  final String emptyPin;
  final String emptyInstance;
  Map<String, Object> get _content => {
        r'''empty_search''': emptySearch,
        r'''empty_pin''': emptyPin,
        r'''empty_instance''': emptyInstance,
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

class ConfigLoc {
  const ConfigLoc({
    required this.label,
    required this.new$,
    required this.select,
    required this.details,
    required this.start,
    required this.empty,
  });
  factory ConfigLoc.fromJson(Map<String, dynamic> json) {
    return ConfigLoc(
      label: ({required String count}) => (json['label'] ?? '')
          .toString()
          .replaceAll(r'${count}', count)
          .replaceAll(_variableRegExp, ''),
      new$: (json['new'] ?? '').toString(),
      select: (json['select'] ?? '').toString(),
      details: (json['details'] ?? '').toString(),
      start: (json['start'] ?? '').toString(),
      empty: (json['empty'] ?? '').toString(),
    );
  }
  final String Function({required String count}) label;

  final String new$;
  final String select;
  final String details;
  final String start;
  final String empty;
  Map<String, Object> get _content => {
        r'''label''': label,
        r'''new''': new$,
        r'''select''': select,
        r'''details''': details,
        r'''start''': start,
        r'''empty''': empty,
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
    required this.contentsEdit,
    required this.contentsStart,
    required this.contentsNew,
  });
  factory NoDeviceDialogLoc.fromJson(Map<String, dynamic> json) {
    return NoDeviceDialogLoc(
      title: (json['title'] ?? '').toString(),
      contentsEdit: (json['contentsEdit'] ?? '').toString(),
      contentsStart: (json['contentsStart'] ?? '').toString(),
      contentsNew: (json['contentsNew'] ?? '').toString(),
    );
  }
  final String title;
  final String contentsEdit;
  final String contentsStart;
  final String contentsNew;
  Map<String, Object> get _content => {
        r'''title''': title,
        r'''contentsEdit''': contentsEdit,
        r'''contentsStart''': contentsStart,
        r'''contentsNew''': contentsNew,
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

class DeleteConfigDialogLoc {
  const DeleteConfigDialogLoc({
    required this.title,
    required this.contents,
  });
  factory DeleteConfigDialogLoc.fromJson(Map<String, dynamic> json) {
    return DeleteConfigDialogLoc(
      title: (json['title'] ?? '').toString(),
      contents: ({required String configname}) => (json['contents'] ?? '')
          .toString()
          .replaceAll(r'${configname}', configname)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String title;
  final String Function({required String configname}) contents;

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
      name: ({required String name}) => (json['name'] ?? '')
          .toString()
          .replaceAll(r'${name}', name)
          .replaceAll(_variableRegExp, ''),
      id: ({required String id}) => (json['id'] ?? '')
          .toString()
          .replaceAll(r'${id}', id)
          .replaceAll(_variableRegExp, ''),
      model: ({required String model}) => (json['model'] ?? '')
          .toString()
          .replaceAll(r'${model}', model)
          .replaceAll(_variableRegExp, ''),
      version: ({required String version}) => (json['version'] ?? '')
          .toString()
          .replaceAll(r'${version}', version)
          .replaceAll(_variableRegExp, ''),
      displays: ({required String count}) => (json['displays'] ?? '')
          .toString()
          .replaceAll(r'${count}', count)
          .replaceAll(_variableRegExp, ''),
      cameras: ({required String count}) => (json['cameras'] ?? '')
          .toString()
          .replaceAll(r'${count}', count)
          .replaceAll(_variableRegExp, ''),
      videoEnc: ({required String count}) => (json['video_enc'] ?? '')
          .toString()
          .replaceAll(r'${count}', count)
          .replaceAll(_variableRegExp, ''),
      audioEnc: ({required String count}) => (json['audio_enc'] ?? '')
          .toString()
          .replaceAll(r'${count}', count)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String fetching;
  final String label;
  final String Function({required String name}) name;

  final String Function({required String id}) id;

  final String Function({required String model}) model;

  final String Function({required String version}) version;

  final String Function({required String count}) displays;

  final String Function({required String count}) cameras;

  final String Function({required String count}) videoEnc;

  final String Function({required String count}) audioEnc;

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

class ConfigManagerLoc {
  const ConfigManagerLoc({
    required this.title,
  });
  factory ConfigManagerLoc.fromJson(Map<String, dynamic> json) {
    return ConfigManagerLoc(
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

class ConfigScreenLoc {
  const ConfigScreenLoc({
    required this.title,
    required this.connectionLost,
    required this.similarExist,
  });
  factory ConfigScreenLoc.fromJson(Map<String, dynamic> json) {
    return ConfigScreenLoc(
      title: (json['title'] ?? '').toString(),
      connectionLost: (json['connection_lost'] ?? '').toString(),
      similarExist: ({required String count}) => (json['similar_exist'] ?? '')
          .toString()
          .replaceAll(r'${count}', count)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String title;
  final String connectionLost;
  final String Function({required String count}) similarExist;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''connection_lost''': connectionLost,
        r'''similar_exist''': similarExist,
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

class RenameSection {
  const RenameSection({
    required this.title,
  });
  factory RenameSection.fromJson(Map<String, dynamic> json) {
    return RenameSection(
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
    required this.virtual,
  });
  factory VideoSectionDisplays.fromJson(Map<String, dynamic> json) {
    return VideoSectionDisplays(
      label: (json['label'] ?? '').toString(),
      info: VideoSectionDisplaysInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
      virtual: VideoSectionDisplaysVirtual.fromJson(
          (json['virtual'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final VideoSectionDisplaysInfo info;

  final VideoSectionDisplaysVirtual virtual;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''info''': info,
        r'''virtual''': virtual,
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

class VideoSectionDisplaysVirtual {
  const VideoSectionDisplaysVirtual({
    required this.label,
    required this.newDisplay,
    required this.resolution,
    required this.dpi,
    required this.deco,
    required this.preserve,
  });
  factory VideoSectionDisplaysVirtual.fromJson(Map<String, dynamic> json) {
    return VideoSectionDisplaysVirtual(
      label: (json['label'] ?? '').toString(),
      newDisplay: VideoSectionDisplaysVirtualNewDisplay.fromJson(
          (json['new_display'] as Map).cast<String, dynamic>()),
      resolution: VideoSectionDisplaysVirtualResolution.fromJson(
          (json['resolution'] as Map).cast<String, dynamic>()),
      dpi: VideoSectionDisplaysVirtualDpi.fromJson(
          (json['dpi'] as Map).cast<String, dynamic>()),
      deco: VideoSectionDisplaysVirtualDeco.fromJson(
          (json['deco'] as Map).cast<String, dynamic>()),
      preserve: VideoSectionDisplaysVirtualPreserve.fromJson(
          (json['preserve'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final VideoSectionDisplaysVirtualNewDisplay newDisplay;

  final VideoSectionDisplaysVirtualResolution resolution;

  final VideoSectionDisplaysVirtualDpi dpi;

  final VideoSectionDisplaysVirtualDeco deco;

  final VideoSectionDisplaysVirtualPreserve preserve;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''new_display''': newDisplay,
        r'''resolution''': resolution,
        r'''dpi''': dpi,
        r'''deco''': deco,
        r'''preserve''': preserve,
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

class VideoSectionDisplaysVirtualNewDisplay {
  const VideoSectionDisplaysVirtualNewDisplay({
    required this.label,
    required this.info,
  });
  factory VideoSectionDisplaysVirtualNewDisplay.fromJson(
      Map<String, dynamic> json) {
    return VideoSectionDisplaysVirtualNewDisplay(
      label: (json['label'] ?? '').toString(),
      info: VideoSectionDisplaysVirtualNewDisplayInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final VideoSectionDisplaysVirtualNewDisplayInfo info;

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

class VideoSectionDisplaysVirtualNewDisplayInfo {
  const VideoSectionDisplaysVirtualNewDisplayInfo({
    required this.alt,
  });
  factory VideoSectionDisplaysVirtualNewDisplayInfo.fromJson(
      Map<String, dynamic> json) {
    return VideoSectionDisplaysVirtualNewDisplayInfo(
      alt: (json['alt'] ?? '').toString(),
    );
  }
  final String alt;
  Map<String, Object> get _content => {
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

class VideoSectionDisplaysVirtualResolution {
  const VideoSectionDisplaysVirtualResolution({
    required this.label,
    required this.info,
  });
  factory VideoSectionDisplaysVirtualResolution.fromJson(
      Map<String, dynamic> json) {
    return VideoSectionDisplaysVirtualResolution(
      label: (json['label'] ?? '').toString(),
      info: VideoSectionDisplaysVirtualResolutionInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final VideoSectionDisplaysVirtualResolutionInfo info;

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

class VideoSectionDisplaysVirtualResolutionInfo {
  const VideoSectionDisplaysVirtualResolutionInfo({
    required this.default$,
    required this.alt,
  });
  factory VideoSectionDisplaysVirtualResolutionInfo.fromJson(
      Map<String, dynamic> json) {
    return VideoSectionDisplaysVirtualResolutionInfo(
      default$: (json['default'] ?? '').toString(),
      alt: ({required String res}) => (json['alt'] ?? '')
          .toString()
          .replaceAll(r'${res}', res)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String default$;
  final String Function({required String res}) alt;

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

class VideoSectionDisplaysVirtualDpi {
  const VideoSectionDisplaysVirtualDpi({
    required this.label,
    required this.info,
  });
  factory VideoSectionDisplaysVirtualDpi.fromJson(Map<String, dynamic> json) {
    return VideoSectionDisplaysVirtualDpi(
      label: (json['label'] ?? '').toString(),
      info: VideoSectionDisplaysVirtualDpiInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final VideoSectionDisplaysVirtualDpiInfo info;

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

class VideoSectionDisplaysVirtualDpiInfo {
  const VideoSectionDisplaysVirtualDpiInfo({
    required this.default$,
    required this.alt,
  });
  factory VideoSectionDisplaysVirtualDpiInfo.fromJson(
      Map<String, dynamic> json) {
    return VideoSectionDisplaysVirtualDpiInfo(
      default$: (json['default'] ?? '').toString(),
      alt: ({required String res, required String dpi}) => (json['alt'] ?? '')
          .toString()
          .replaceAll(r'${res}', res)
          .replaceAll(r'${dpi}', dpi)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String default$;
  final String Function({required String res, required String dpi}) alt;

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

class VideoSectionDisplaysVirtualDeco {
  const VideoSectionDisplaysVirtualDeco({
    required this.label,
    required this.info,
  });
  factory VideoSectionDisplaysVirtualDeco.fromJson(Map<String, dynamic> json) {
    return VideoSectionDisplaysVirtualDeco(
      label: (json['label'] ?? '').toString(),
      info: VideoSectionDisplaysVirtualDecoInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final VideoSectionDisplaysVirtualDecoInfo info;

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

class VideoSectionDisplaysVirtualDecoInfo {
  const VideoSectionDisplaysVirtualDecoInfo({
    required this.default$,
    required this.alt,
  });
  factory VideoSectionDisplaysVirtualDecoInfo.fromJson(
      Map<String, dynamic> json) {
    return VideoSectionDisplaysVirtualDecoInfo(
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

class VideoSectionDisplaysVirtualPreserve {
  const VideoSectionDisplaysVirtualPreserve({
    required this.label,
    required this.info,
  });
  factory VideoSectionDisplaysVirtualPreserve.fromJson(
      Map<String, dynamic> json) {
    return VideoSectionDisplaysVirtualPreserve(
      label: (json['label'] ?? '').toString(),
      info: VideoSectionDisplaysVirtualPreserveInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final VideoSectionDisplaysVirtualPreserveInfo info;

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

class VideoSectionDisplaysVirtualPreserveInfo {
  const VideoSectionDisplaysVirtualPreserveInfo({
    required this.default$,
    required this.alt,
  });
  factory VideoSectionDisplaysVirtualPreserveInfo.fromJson(
      Map<String, dynamic> json) {
    return VideoSectionDisplaysVirtualPreserveInfo(
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

class AppSection {
  const AppSection({
    required this.title,
    required this.select,
    required this.forceClose,
  });
  factory AppSection.fromJson(Map<String, dynamic> json) {
    return AppSection(
      title: (json['title'] ?? '').toString(),
      select: AppSectionSelect.fromJson(
          (json['select'] as Map).cast<String, dynamic>()),
      forceClose: AppSectionForceClose.fromJson(
          (json['force_close'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final AppSectionSelect select;

  final AppSectionForceClose forceClose;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''select''': select,
        r'''force_close''': forceClose,
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

class AppSectionSelect {
  const AppSectionSelect({
    required this.label,
    required this.info,
  });
  factory AppSectionSelect.fromJson(Map<String, dynamic> json) {
    return AppSectionSelect(
      label: (json['label'] ?? '').toString(),
      info: AppSectionSelectInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final AppSectionSelectInfo info;

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

class AppSectionSelectInfo {
  const AppSectionSelectInfo({
    required this.alt,
    required this.fc,
  });
  factory AppSectionSelectInfo.fromJson(Map<String, dynamic> json) {
    return AppSectionSelectInfo(
      alt: ({required String app}) => (json['alt'] ?? '')
          .toString()
          .replaceAll(r'${app}', app)
          .replaceAll(_variableRegExp, ''),
      fc: ({required String app}) => (json['fc'] ?? '')
          .toString()
          .replaceAll(r'${app}', app)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String Function({required String app}) alt;

  final String Function({required String app}) fc;

  Map<String, Object> get _content => {
        r'''alt''': alt,
        r'''fc''': fc,
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

class AppSectionForceClose {
  const AppSectionForceClose({
    required this.label,
    required this.info,
  });
  factory AppSectionForceClose.fromJson(Map<String, dynamic> json) {
    return AppSectionForceClose(
      label: (json['label'] ?? '').toString(),
      info: AppSectionForceCloseInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final AppSectionForceCloseInfo info;

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

class AppSectionForceCloseInfo {
  const AppSectionForceCloseInfo({
    required this.alt,
  });
  factory AppSectionForceCloseInfo.fromJson(Map<String, dynamic> json) {
    return AppSectionForceCloseInfo(
      alt: (json['alt'] ?? '').toString(),
    );
  }
  final String alt;
  Map<String, Object> get _content => {
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

class ConnectLoc {
  const ConnectLoc({
    required this.title,
    required this.withIp,
    required this.withMdns,
    required this.qrPair,
    required this.unauthenticated,
    required this.failed,
  });
  factory ConnectLoc.fromJson(Map<String, dynamic> json) {
    return ConnectLoc(
      title: (json['title'] ?? '').toString(),
      withIp: ConnectLocWithIp.fromJson(
          (json['with_ip'] as Map).cast<String, dynamic>()),
      withMdns: ConnectLocWithMdns.fromJson(
          (json['with_mdns'] as Map).cast<String, dynamic>()),
      qrPair: ConnectLocQrPair.fromJson(
          (json['qr_pair'] as Map).cast<String, dynamic>()),
      unauthenticated: ConnectLocUnauthenticated.fromJson(
          (json['unauthenticated'] as Map).cast<String, dynamic>()),
      failed: ConnectLocFailed.fromJson(
          (json['failed'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final ConnectLocWithIp withIp;

  final ConnectLocWithMdns withMdns;

  final ConnectLocQrPair qrPair;

  final ConnectLocUnauthenticated unauthenticated;

  final ConnectLocFailed failed;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''with_ip''': withIp,
        r'''with_mdns''': withMdns,
        r'''qr_pair''': qrPair,
        r'''unauthenticated''': unauthenticated,
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

class ConnectLocWithIp {
  const ConnectLocWithIp({
    required this.label,
    required this.connect,
    required this.connected,
  });
  factory ConnectLocWithIp.fromJson(Map<String, dynamic> json) {
    return ConnectLocWithIp(
      label: (json['label'] ?? '').toString(),
      connect: (json['connect'] ?? '').toString(),
      connected: ({required String to}) => (json['connected'] ?? '')
          .toString()
          .replaceAll(r'${to}', to)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String label;
  final String connect;
  final String Function({required String to}) connected;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''connect''': connect,
        r'''connected''': connected,
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

class ConnectLocWithMdns {
  const ConnectLocWithMdns({
    required this.label,
    required this.info,
  });
  factory ConnectLocWithMdns.fromJson(Map<String, dynamic> json) {
    return ConnectLocWithMdns(
      label: ({required String count}) => (json['label'] ?? '')
          .toString()
          .replaceAll(r'${count}', count)
          .replaceAll(_variableRegExp, ''),
      info: ConnectLocWithMdnsInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final String Function({required String count}) label;

  final ConnectLocWithMdnsInfo info;

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

class ConnectLocWithMdnsInfo {
  const ConnectLocWithMdnsInfo({
    required this.i1,
    required this.i2,
    required this.i3,
  });
  factory ConnectLocWithMdnsInfo.fromJson(Map<String, dynamic> json) {
    return ConnectLocWithMdnsInfo(
      i1: (json['i1'] ?? '').toString(),
      i2: (json['i2'] ?? '').toString(),
      i3: (json['i3'] ?? '').toString(),
    );
  }
  final String i1;
  final String i2;
  final String i3;
  Map<String, Object> get _content => {
        r'''i1''': i1,
        r'''i2''': i2,
        r'''i3''': i3,
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

class ConnectLocQrPair {
  const ConnectLocQrPair({
    required this.label,
    required this.pair,
    required this.status,
  });
  factory ConnectLocQrPair.fromJson(Map<String, dynamic> json) {
    return ConnectLocQrPair(
      label: (json['label'] ?? '').toString(),
      pair: (json['pair'] ?? '').toString(),
      status: ConnectLocQrPairStatus.fromJson(
          (json['status'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final String pair;
  final ConnectLocQrPairStatus status;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''pair''': pair,
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

class ConnectLocQrPairStatus {
  const ConnectLocQrPairStatus({
    required this.cancelled,
    required this.success,
    required this.failed,
  });
  factory ConnectLocQrPairStatus.fromJson(Map<String, dynamic> json) {
    return ConnectLocQrPairStatus(
      cancelled: (json['cancelled'] ?? '').toString(),
      success: (json['success'] ?? '').toString(),
      failed: (json['failed'] ?? '').toString(),
    );
  }
  final String cancelled;
  final String success;
  final String failed;
  Map<String, Object> get _content => {
        r'''cancelled''': cancelled,
        r'''success''': success,
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

class ConnectLocUnauthenticated {
  const ConnectLocUnauthenticated({
    required this.info,
  });
  factory ConnectLocUnauthenticated.fromJson(Map<String, dynamic> json) {
    return ConnectLocUnauthenticated(
      info: ConnectLocUnauthenticatedInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final ConnectLocUnauthenticatedInfo info;

  Map<String, Object> get _content => {
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

class ConnectLocUnauthenticatedInfo {
  const ConnectLocUnauthenticatedInfo({
    required this.i1,
    required this.i2,
  });
  factory ConnectLocUnauthenticatedInfo.fromJson(Map<String, dynamic> json) {
    return ConnectLocUnauthenticatedInfo(
      i1: (json['i1'] ?? '').toString(),
      i2: (json['i2'] ?? '').toString(),
    );
  }
  final String i1;
  final String i2;
  Map<String, Object> get _content => {
        r'''i1''': i1,
        r'''i2''': i2,
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

class ConnectLocFailed {
  const ConnectLocFailed({
    required this.info,
  });
  factory ConnectLocFailed.fromJson(Map<String, dynamic> json) {
    return ConnectLocFailed(
      info: ConnectLocFailedInfo.fromJson(
          (json['info'] as Map).cast<String, dynamic>()),
    );
  }
  final ConnectLocFailedInfo info;

  Map<String, Object> get _content => {
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

class ConnectLocFailedInfo {
  const ConnectLocFailedInfo({
    required this.i1,
    required this.i2,
    required this.i3,
    required this.i4,
    required this.i5,
  });
  factory ConnectLocFailedInfo.fromJson(Map<String, dynamic> json) {
    return ConnectLocFailedInfo(
      i1: (json['i1'] ?? '').toString(),
      i2: (json['i2'] ?? '').toString(),
      i3: (json['i3'] ?? '').toString(),
      i4: (json['i4'] ?? '').toString(),
      i5: (json['i5'] ?? '').toString(),
    );
  }
  final String i1;
  final String i2;
  final String i3;
  final String i4;
  final String i5;
  Map<String, Object> get _content => {
        r'''i1''': i1,
        r'''i2''': i2,
        r'''i3''': i3,
        r'''i4''': i4,
        r'''i5''': i5,
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
    required this.check,
    required this.current,
    required this.exec,
    required this.infoPopup,
    required this.updater,
  });
  factory ScrcpyManagerLoc.fromJson(Map<String, dynamic> json) {
    return ScrcpyManagerLoc(
      title: (json['title'] ?? '').toString(),
      check: (json['check'] ?? '').toString(),
      current: ScrcpyManagerLocCurrent.fromJson(
          (json['current'] as Map).cast<String, dynamic>()),
      exec: ScrcpyManagerLocExec.fromJson(
          (json['exec'] as Map).cast<String, dynamic>()),
      infoPopup: ScrcpyManagerLocInfoPopup.fromJson(
          (json['info_popup'] as Map).cast<String, dynamic>()),
      updater: ScrcpyManagerLocUpdater.fromJson(
          (json['updater'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final String check;
  final ScrcpyManagerLocCurrent current;

  final ScrcpyManagerLocExec exec;

  final ScrcpyManagerLocInfoPopup infoPopup;

  final ScrcpyManagerLocUpdater updater;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''check''': check,
        r'''current''': current,
        r'''exec''': exec,
        r'''info_popup''': infoPopup,
        r'''updater''': updater,
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
  });
  factory ScrcpyManagerLocCurrent.fromJson(Map<String, dynamic> json) {
    return ScrcpyManagerLocCurrent(
      label: (json['label'] ?? '').toString(),
      inUse: (json['in_use'] ?? '').toString(),
    );
  }
  final String label;
  final String inUse;
  Map<String, Object> get _content => {
        r'''label''': label,
        r'''in_use''': inUse,
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

class ScrcpyManagerLocExec {
  const ScrcpyManagerLocExec({
    required this.label,
    required this.info,
  });
  factory ScrcpyManagerLocExec.fromJson(Map<String, dynamic> json) {
    return ScrcpyManagerLocExec(
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

class ScrcpyManagerLocInfoPopup {
  const ScrcpyManagerLocInfoPopup({
    required this.noUpdate,
    required this.error,
  });
  factory ScrcpyManagerLocInfoPopup.fromJson(Map<String, dynamic> json) {
    return ScrcpyManagerLocInfoPopup(
      noUpdate: (json['no_update'] ?? '').toString(),
      error: (json['error'] ?? '').toString(),
    );
  }
  final String noUpdate;
  final String error;
  Map<String, Object> get _content => {
        r'''no_update''': noUpdate,
        r'''error''': error,
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

class ScrcpyManagerLocUpdater {
  const ScrcpyManagerLocUpdater({
    required this.label,
    required this.newVersion,
  });
  factory ScrcpyManagerLocUpdater.fromJson(Map<String, dynamic> json) {
    return ScrcpyManagerLocUpdater(
      label: (json['label'] ?? '').toString(),
      newVersion: (json['new_version'] ?? '').toString(),
    );
  }
  final String label;
  final String newVersion;
  Map<String, Object> get _content => {
        r'''label''': label,
        r'''new_version''': newVersion,
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
    required this.behavior,
  });
  factory SettingsLoc.fromJson(Map<String, dynamic> json) {
    return SettingsLoc(
      title: (json['title'] ?? '').toString(),
      looks: SettingsLocLooks.fromJson(
          (json['looks'] as Map).cast<String, dynamic>()),
      behavior: SettingsLocBehavior.fromJson(
          (json['behavior'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final SettingsLocLooks looks;

  final SettingsLocBehavior behavior;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''looks''': looks,
        r'''behavior''': behavior,
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
    required this.cornerRadius,
    required this.accentColor,
    required this.tintLevel,
  });
  factory SettingsLocLooks.fromJson(Map<String, dynamic> json) {
    return SettingsLocLooks(
      label: (json['label'] ?? '').toString(),
      mode: SettingsLocLooksMode.fromJson(
          (json['mode'] as Map).cast<String, dynamic>()),
      cornerRadius: SettingsLocLooksCornerRadius.fromJson(
          (json['corner_radius'] as Map).cast<String, dynamic>()),
      accentColor: SettingsLocLooksAccentColor.fromJson(
          (json['accent_color'] as Map).cast<String, dynamic>()),
      tintLevel: SettingsLocLooksTintLevel.fromJson(
          (json['tint_level'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final SettingsLocLooksMode mode;

  final SettingsLocLooksCornerRadius cornerRadius;

  final SettingsLocLooksAccentColor accentColor;

  final SettingsLocLooksTintLevel tintLevel;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''mode''': mode,
        r'''corner_radius''': cornerRadius,
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

class SettingsLocLooksCornerRadius {
  const SettingsLocLooksCornerRadius({
    required this.label,
  });
  factory SettingsLocLooksCornerRadius.fromJson(Map<String, dynamic> json) {
    return SettingsLocLooksCornerRadius(
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

class SettingsLocBehavior {
  const SettingsLocBehavior({
    required this.label,
    required this.language,
    required this.minimize,
    required this.windowSize,
  });
  factory SettingsLocBehavior.fromJson(Map<String, dynamic> json) {
    return SettingsLocBehavior(
      label: (json['label'] ?? '').toString(),
      language: SettingsLocBehaviorLanguage.fromJson(
          (json['language'] as Map).cast<String, dynamic>()),
      minimize: SettingsLocBehaviorMinimize.fromJson(
          (json['minimize'] as Map).cast<String, dynamic>()),
      windowSize: SettingsLocBehaviorWindowSize.fromJson(
          (json['window_size'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final SettingsLocBehaviorLanguage language;

  final SettingsLocBehaviorMinimize minimize;

  final SettingsLocBehaviorWindowSize windowSize;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''language''': language,
        r'''minimize''': minimize,
        r'''window_size''': windowSize,
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

class SettingsLocBehaviorLanguage {
  const SettingsLocBehaviorLanguage({
    required this.label,
    required this.info,
  });
  factory SettingsLocBehaviorLanguage.fromJson(Map<String, dynamic> json) {
    return SettingsLocBehaviorLanguage(
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

class SettingsLocBehaviorMinimize {
  const SettingsLocBehaviorMinimize({
    required this.label,
    required this.value,
  });
  factory SettingsLocBehaviorMinimize.fromJson(Map<String, dynamic> json) {
    return SettingsLocBehaviorMinimize(
      label: (json['label'] ?? '').toString(),
      value: SettingsLocBehaviorMinimizeValue.fromJson(
          (json['value'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final SettingsLocBehaviorMinimizeValue value;

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

class SettingsLocBehaviorMinimizeValue {
  const SettingsLocBehaviorMinimizeValue({
    required this.tray,
    required this.taskbar,
  });
  factory SettingsLocBehaviorMinimizeValue.fromJson(Map<String, dynamic> json) {
    return SettingsLocBehaviorMinimizeValue(
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

class SettingsLocBehaviorWindowSize {
  const SettingsLocBehaviorWindowSize({
    required this.label,
    required this.info,
  });
  factory SettingsLocBehaviorWindowSize.fromJson(Map<String, dynamic> json) {
    return SettingsLocBehaviorWindowSize(
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

class CompanionLoc {
  const CompanionLoc({
    required this.title,
    required this.server,
    required this.client,
    required this.qr,
  });
  factory CompanionLoc.fromJson(Map<String, dynamic> json) {
    return CompanionLoc(
      title: (json['title'] ?? '').toString(),
      server: CompanionLocServer.fromJson(
          (json['server'] as Map).cast<String, dynamic>()),
      client: CompanionLocClient.fromJson(
          (json['client'] as Map).cast<String, dynamic>()),
      qr: (json['qr'] ?? '').toString(),
    );
  }
  final String title;
  final CompanionLocServer server;

  final CompanionLocClient client;

  final String qr;
  Map<String, Object> get _content => {
        r'''title''': title,
        r'''server''': server,
        r'''client''': client,
        r'''qr''': qr,
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

class CompanionLocServer {
  const CompanionLocServer({
    required this.label,
    required this.status,
    required this.name,
    required this.port,
    required this.secret,
    required this.autoStart,
  });
  factory CompanionLocServer.fromJson(Map<String, dynamic> json) {
    return CompanionLocServer(
      label: (json['label'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      name: CompanionLocServerName.fromJson(
          (json['name'] as Map).cast<String, dynamic>()),
      port: CompanionLocServerPort.fromJson(
          (json['port'] as Map).cast<String, dynamic>()),
      secret: CompanionLocServerSecret.fromJson(
          (json['secret'] as Map).cast<String, dynamic>()),
      autoStart: CompanionLocServerAutoStart.fromJson(
          (json['auto_start'] as Map).cast<String, dynamic>()),
    );
  }
  final String label;
  final String status;
  final CompanionLocServerName name;

  final CompanionLocServerPort port;

  final CompanionLocServerSecret secret;

  final CompanionLocServerAutoStart autoStart;

  Map<String, Object> get _content => {
        r'''label''': label,
        r'''status''': status,
        r'''name''': name,
        r'''port''': port,
        r'''secret''': secret,
        r'''auto_start''': autoStart,
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

class CompanionLocServerName {
  const CompanionLocServerName({
    required this.label,
    required this.info,
  });
  factory CompanionLocServerName.fromJson(Map<String, dynamic> json) {
    return CompanionLocServerName(
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

class CompanionLocServerPort {
  const CompanionLocServerPort({
    required this.label,
    required this.info,
  });
  factory CompanionLocServerPort.fromJson(Map<String, dynamic> json) {
    return CompanionLocServerPort(
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

class CompanionLocServerSecret {
  const CompanionLocServerSecret({
    required this.label,
  });
  factory CompanionLocServerSecret.fromJson(Map<String, dynamic> json) {
    return CompanionLocServerSecret(
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

class CompanionLocServerAutoStart {
  const CompanionLocServerAutoStart({
    required this.label,
  });
  factory CompanionLocServerAutoStart.fromJson(Map<String, dynamic> json) {
    return CompanionLocServerAutoStart(
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

class CompanionLocClient {
  const CompanionLocClient({
    required this.clients,
    required this.blocked,
    required this.noClient,
    required this.noBlocked,
  });
  factory CompanionLocClient.fromJson(Map<String, dynamic> json) {
    return CompanionLocClient(
      clients: ({required String count}) => (json['clients'] ?? '')
          .toString()
          .replaceAll(r'${count}', count)
          .replaceAll(_variableRegExp, ''),
      blocked: ({required String count}) => (json['blocked'] ?? '')
          .toString()
          .replaceAll(r'${count}', count)
          .replaceAll(_variableRegExp, ''),
      noClient: (json['no_client'] ?? '').toString(),
      noBlocked: (json['no_blocked'] ?? '').toString(),
    );
  }
  final String Function({required String count}) clients;

  final String Function({required String count}) blocked;

  final String noClient;
  final String noBlocked;
  Map<String, Object> get _content => {
        r'''clients''': clients,
        r'''blocked''': blocked,
        r'''no_client''': noClient,
        r'''no_blocked''': noBlocked,
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

class AboutLoc {
  const AboutLoc({
    required this.title,
    required this.version,
    required this.author,
    required this.credits,
  });
  factory AboutLoc.fromJson(Map<String, dynamic> json) {
    return AboutLoc(
      title: (json['title'] ?? '').toString(),
      version: (json['version'] ?? '').toString(),
      author: (json['author'] ?? '').toString(),
      credits: (json['credits'] ?? '').toString(),
    );
  }
  final String title;
  final String version;
  final String author;
  final String credits;
  Map<String, Object> get _content => {
        r'''title''': title,
        r'''version''': version,
        r'''author''': author,
        r'''credits''': credits,
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

class QuitDialogLoc {
  const QuitDialogLoc({
    required this.title,
    required this.killRunning,
    required this.disconnect,
  });
  factory QuitDialogLoc.fromJson(Map<String, dynamic> json) {
    return QuitDialogLoc(
      title: (json['title'] ?? '').toString(),
      killRunning: QuitDialogLocKillRunning.fromJson(
          (json['kill_running'] as Map).cast<String, dynamic>()),
      disconnect: QuitDialogLocDisconnect.fromJson(
          (json['disconnect'] as Map).cast<String, dynamic>()),
    );
  }
  final String title;
  final QuitDialogLocKillRunning killRunning;

  final QuitDialogLocDisconnect disconnect;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''kill_running''': killRunning,
        r'''disconnect''': disconnect,
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

class QuitDialogLocKillRunning {
  const QuitDialogLocKillRunning({
    required this.label,
    required this.info,
  });
  factory QuitDialogLocKillRunning.fromJson(Map<String, dynamic> json) {
    return QuitDialogLocKillRunning(
      label: (json['label'] ?? '').toString(),
      info: ({required String count}) => (json['info'] ?? '')
          .toString()
          .replaceAll(r'${count}', count)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String label;
  final String Function({required String count}) info;

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

class QuitDialogLocDisconnect {
  const QuitDialogLocDisconnect({
    required this.label,
    required this.info,
  });
  factory QuitDialogLocDisconnect.fromJson(Map<String, dynamic> json) {
    return QuitDialogLocDisconnect(
      label: (json['label'] ?? '').toString(),
      info: ({required String count}) => (json['info'] ?? '')
          .toString()
          .replaceAll(r'${count}', count)
          .replaceAll(_variableRegExp, ''),
    );
  }
  final String label;
  final String Function({required String count}) info;

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

class DisconnectDialogLoc {
  const DisconnectDialogLoc({
    required this.title,
    required this.hasRunning,
  });
  factory DisconnectDialogLoc.fromJson(Map<String, dynamic> json) {
    return DisconnectDialogLoc(
      title: ({required String name}) => (json['title'] ?? '')
          .toString()
          .replaceAll(r'${name}', name)
          .replaceAll(_variableRegExp, ''),
      hasRunning: DisconnectDialogLocHasRunning.fromJson(
          (json['has_running'] as Map).cast<String, dynamic>()),
    );
  }
  final String Function({required String name}) title;

  final DisconnectDialogLocHasRunning hasRunning;

  Map<String, Object> get _content => {
        r'''title''': title,
        r'''has_running''': hasRunning,
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

class DisconnectDialogLocHasRunning {
  const DisconnectDialogLocHasRunning({
    required this.label,
    required this.info,
  });
  factory DisconnectDialogLocHasRunning.fromJson(Map<String, dynamic> json) {
    return DisconnectDialogLocHasRunning(
      label: ({required String name, required String count}) =>
          (json['label'] ?? '')
              .toString()
              .replaceAll(r'${name}', name)
              .replaceAll(r'${count}', count)
              .replaceAll(_variableRegExp, ''),
      info: (json['info'] ?? '').toString(),
    );
  }
  final String Function({required String name, required String count}) label;

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

class CloseDialogLoc {
  const CloseDialogLoc({
    required this.notAllowed,
    required this.overwrite,
    required this.nameExist,
    required this.save,
    required this.commandPreview,
    required this.name,
  });
  factory CloseDialogLoc.fromJson(Map<String, dynamic> json) {
    return CloseDialogLoc(
      notAllowed: (json['not_allowed'] ?? '').toString(),
      overwrite: (json['overwrite'] ?? '').toString(),
      nameExist: (json['name_exist'] ?? '').toString(),
      save: (json['save'] ?? '').toString(),
      commandPreview: (json['command_preview'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }
  final String notAllowed;
  final String overwrite;
  final String nameExist;
  final String save;
  final String commandPreview;
  final String name;
  Map<String, Object> get _content => {
        r'''not_allowed''': notAllowed,
        r'''overwrite''': overwrite,
        r'''name_exist''': nameExist,
        r'''save''': save,
        r'''command_preview''': commandPreview,
        r'''name''': name,
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

class ServerDisclaimerLoc {
  const ServerDisclaimerLoc({
    required this.title,
    required this.contents,
  });
  factory ServerDisclaimerLoc.fromJson(Map<String, dynamic> json) {
    return ServerDisclaimerLoc(
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

class IpHistoryLoc {
  const IpHistoryLoc({
    required this.title,
    required this.empty,
  });
  factory IpHistoryLoc.fromJson(Map<String, dynamic> json) {
    return IpHistoryLoc(
      title: (json['title'] ?? '').toString(),
      empty: (json['empty'] ?? '').toString(),
    );
  }
  final String title;
  final String empty;
  Map<String, Object> get _content => {
        r'''title''': title,
        r'''empty''': empty,
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
    required this.update,
    required this.info,
    required this.selectAll,
    required this.quit,
    required this.discard,
    required this.overwrite,
    required this.save,
    required this.clear,
    required this.filter,
    required this.delete,
    required this.serverAgree,
    required this.reorder,
    required this.stopAll,
  });
  factory ButtonLabelLoc.fromJson(Map<String, dynamic> json) {
    return ButtonLabelLoc(
      ok: (json['ok'] ?? '').toString(),
      close: (json['close'] ?? '').toString(),
      cancel: (json['cancel'] ?? '').toString(),
      stop: (json['stop'] ?? '').toString(),
      testConfig: (json['test_config'] ?? '').toString(),
      update: (json['update'] ?? '').toString(),
      info: (json['info'] ?? '').toString(),
      selectAll: (json['select_all'] ?? '').toString(),
      quit: (json['quit'] ?? '').toString(),
      discard: (json['discard'] ?? '').toString(),
      overwrite: (json['overwrite'] ?? '').toString(),
      save: (json['save'] ?? '').toString(),
      clear: (json['clear'] ?? '').toString(),
      filter: (json['filter'] ?? '').toString(),
      delete: (json['delete'] ?? '').toString(),
      serverAgree: (json['server_agree'] ?? '').toString(),
      reorder: (json['reorder'] ?? '').toString(),
      stopAll: (json['stop_all'] ?? '').toString(),
    );
  }
  final String ok;
  final String close;
  final String cancel;
  final String stop;
  final String testConfig;
  final String update;
  final String info;
  final String selectAll;
  final String quit;
  final String discard;
  final String overwrite;
  final String save;
  final String clear;
  final String filter;
  final String delete;
  final String serverAgree;
  final String reorder;
  final String stopAll;
  Map<String, Object> get _content => {
        r'''ok''': ok,
        r'''close''': close,
        r'''cancel''': cancel,
        r'''stop''': stop,
        r'''test_config''': testConfig,
        r'''update''': update,
        r'''info''': info,
        r'''select_all''': selectAll,
        r'''quit''': quit,
        r'''discard''': discard,
        r'''overwrite''': overwrite,
        r'''save''': save,
        r'''clear''': clear,
        r'''filter''': filter,
        r'''delete''': delete,
        r'''server_agree''': serverAgree,
        r'''reorder''': reorder,
        r'''stop_all''': stopAll,
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
    required this.unauth,
    required this.error,
    required this.latest,
    required this.closing,
    required this.copied,
    required this.running,
    required this.stopped,
  });
  factory StatusLoc.fromJson(Map<String, dynamic> json) {
    return StatusLoc(
      failed: (json['failed'] ?? '').toString(),
      unauth: (json['unauth'] ?? '').toString(),
      error: (json['error'] ?? '').toString(),
      latest: (json['latest'] ?? '').toString(),
      closing: (json['closing'] ?? '').toString(),
      copied: (json['copied'] ?? '').toString(),
      running: (json['running'] ?? '').toString(),
      stopped: (json['stopped'] ?? '').toString(),
    );
  }
  final String failed;
  final String unauth;
  final String error;
  final String latest;
  final String closing;
  final String copied;
  final String running;
  final String stopped;
  Map<String, Object> get _content => {
        r'''failed''': failed,
        r'''unauth''': unauth,
        r'''error''': error,
        r'''latest''': latest,
        r'''closing''': closing,
        r'''copied''': copied,
        r'''running''': running,
        r'''stopped''': stopped,
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
    required this.bundled,
  });
  factory CommonLoc.fromJson(Map<String, dynamic> json) {
    return CommonLoc(
      default$: (json['default'] ?? '').toString(),
      yes: (json['yes'] ?? '').toString(),
      no: (json['no'] ?? '').toString(),
      bundled: (json['bundled'] ?? '').toString(),
    );
  }
  final String default$;
  final String yes;
  final String no;
  final String bundled;
  Map<String, Object> get _content => {
        r'''default''': default$,
        r'''yes''': yes,
        r'''no''': no,
        r'''bundled''': bundled,
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

class ColorSchemeNameLoc {
  const ColorSchemeNameLoc({
    required this.blue,
    required this.gray,
    required this.green,
    required this.neutral,
    required this.orange,
    required this.red,
    required this.rose,
    required this.slate,
    required this.stone,
    required this.violet,
    required this.yellow,
    required this.zinc,
  });
  factory ColorSchemeNameLoc.fromJson(Map<String, dynamic> json) {
    return ColorSchemeNameLoc(
      blue: (json['blue'] ?? '').toString(),
      gray: (json['gray'] ?? '').toString(),
      green: (json['green'] ?? '').toString(),
      neutral: (json['neutral'] ?? '').toString(),
      orange: (json['orange'] ?? '').toString(),
      red: (json['red'] ?? '').toString(),
      rose: (json['rose'] ?? '').toString(),
      slate: (json['slate'] ?? '').toString(),
      stone: (json['stone'] ?? '').toString(),
      violet: (json['violet'] ?? '').toString(),
      yellow: (json['yellow'] ?? '').toString(),
      zinc: (json['zinc'] ?? '').toString(),
    );
  }
  final String blue;
  final String gray;
  final String green;
  final String neutral;
  final String orange;
  final String red;
  final String rose;
  final String slate;
  final String stone;
  final String violet;
  final String yellow;
  final String zinc;
  Map<String, Object> get _content => {
        r'''blue''': blue,
        r'''gray''': gray,
        r'''green''': green,
        r'''neutral''': neutral,
        r'''orange''': orange,
        r'''red''': red,
        r'''rose''': rose,
        r'''slate''': slate,
        r'''stone''': stone,
        r'''violet''': violet,
        r'''yellow''': yellow,
        r'''zinc''': zinc,
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

class ConfigFiltersLoc {
  const ConfigFiltersLoc({
    required this.label,
  });
  factory ConfigFiltersLoc.fromJson(Map<String, dynamic> json) {
    return ConfigFiltersLoc(
      label: ConfigFiltersLocLabel.fromJson(
          (json['label'] as Map).cast<String, dynamic>()),
    );
  }
  final ConfigFiltersLocLabel label;

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

class ConfigFiltersLocLabel {
  const ConfigFiltersLocLabel({
    required this.withApp,
    required this.virt,
  });
  factory ConfigFiltersLocLabel.fromJson(Map<String, dynamic> json) {
    return ConfigFiltersLocLabel(
      withApp: (json['withApp'] ?? '').toString(),
      virt: (json['virt'] ?? '').toString(),
    );
  }
  final String withApp;
  final String virt;
  Map<String, Object> get _content => {
        r'''withApp''': withApp,
        r'''virt''': virt,
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
    required this.deviceTileLoc,
    required this.loungeLoc,
    required this.configLoc,
    required this.noDeviceDialogLoc,
    required this.noConfigDialogLoc,
    required this.deleteConfigDialogLoc,
    required this.deviceSettingsLoc,
    required this.configManagerLoc,
    required this.configScreenLoc,
    required this.logScreenLoc,
    required this.renameSection,
    required this.modeSection,
    required this.videoSection,
    required this.audioSection,
    required this.appSection,
    required this.deviceSection,
    required this.windowSection,
    required this.addFlags,
    required this.connectLoc,
    required this.testConfigLoc,
    required this.scrcpyManagerLoc,
    required this.settingsLoc,
    required this.companionLoc,
    required this.aboutLoc,
    required this.quitDialogLoc,
    required this.disconnectDialogLoc,
    required this.closeDialogLoc,
    required this.serverDisclaimerLoc,
    required this.ipHistoryLoc,
    required this.buttonLabelLoc,
    required this.statusLoc,
    required this.commonLoc,
    required this.colorSchemeNameLoc,
    required this.configFiltersLoc,
  });
  factory LocalizationMessages.fromJson(Map<String, dynamic> json) {
    return LocalizationMessages(
      homeLoc:
          HomeLoc.fromJson((json['home_loc'] as Map).cast<String, dynamic>()),
      deviceTileLoc: DeviceTileLoc.fromJson(
          (json['device_tile_loc'] as Map).cast<String, dynamic>()),
      loungeLoc: LoungeLoc.fromJson(
          (json['lounge_loc'] as Map).cast<String, dynamic>()),
      configLoc: ConfigLoc.fromJson(
          (json['config_loc'] as Map).cast<String, dynamic>()),
      noDeviceDialogLoc: NoDeviceDialogLoc.fromJson(
          (json['no_device_dialog_loc'] as Map).cast<String, dynamic>()),
      noConfigDialogLoc: NoConfigDialogLoc.fromJson(
          (json['no_config_dialog_loc'] as Map).cast<String, dynamic>()),
      deleteConfigDialogLoc: DeleteConfigDialogLoc.fromJson(
          (json['delete_config_dialog_loc'] as Map).cast<String, dynamic>()),
      deviceSettingsLoc: DeviceSettingsLoc.fromJson(
          (json['device_settings_loc'] as Map).cast<String, dynamic>()),
      configManagerLoc: ConfigManagerLoc.fromJson(
          (json['config_manager_loc'] as Map).cast<String, dynamic>()),
      configScreenLoc: ConfigScreenLoc.fromJson(
          (json['config_screen_loc'] as Map).cast<String, dynamic>()),
      logScreenLoc: LogScreenLoc.fromJson(
          (json['log_screen_loc'] as Map).cast<String, dynamic>()),
      renameSection: RenameSection.fromJson(
          (json['rename_section'] as Map).cast<String, dynamic>()),
      modeSection: ModeSection.fromJson(
          (json['mode_section'] as Map).cast<String, dynamic>()),
      videoSection: VideoSection.fromJson(
          (json['video_section'] as Map).cast<String, dynamic>()),
      audioSection: AudioSection.fromJson(
          (json['audio_section'] as Map).cast<String, dynamic>()),
      appSection: AppSection.fromJson(
          (json['app_section'] as Map).cast<String, dynamic>()),
      deviceSection: DeviceSection.fromJson(
          (json['device_section'] as Map).cast<String, dynamic>()),
      windowSection: WindowSection.fromJson(
          (json['window_section'] as Map).cast<String, dynamic>()),
      addFlags:
          AddFlags.fromJson((json['add_flags'] as Map).cast<String, dynamic>()),
      connectLoc: ConnectLoc.fromJson(
          (json['connect_loc'] as Map).cast<String, dynamic>()),
      testConfigLoc: TestConfigLoc.fromJson(
          (json['test_config_loc'] as Map).cast<String, dynamic>()),
      scrcpyManagerLoc: ScrcpyManagerLoc.fromJson(
          (json['scrcpy_manager_loc'] as Map).cast<String, dynamic>()),
      settingsLoc: SettingsLoc.fromJson(
          (json['settings_loc'] as Map).cast<String, dynamic>()),
      companionLoc: CompanionLoc.fromJson(
          (json['companion_loc'] as Map).cast<String, dynamic>()),
      aboutLoc:
          AboutLoc.fromJson((json['about_loc'] as Map).cast<String, dynamic>()),
      quitDialogLoc: QuitDialogLoc.fromJson(
          (json['quit_dialog_loc'] as Map).cast<String, dynamic>()),
      disconnectDialogLoc: DisconnectDialogLoc.fromJson(
          (json['disconnect_dialog_loc'] as Map).cast<String, dynamic>()),
      closeDialogLoc: CloseDialogLoc.fromJson(
          (json['close_dialog_loc'] as Map).cast<String, dynamic>()),
      serverDisclaimerLoc: ServerDisclaimerLoc.fromJson(
          (json['server_disclaimer_loc'] as Map).cast<String, dynamic>()),
      ipHistoryLoc: IpHistoryLoc.fromJson(
          (json['ip_history_loc'] as Map).cast<String, dynamic>()),
      buttonLabelLoc: ButtonLabelLoc.fromJson(
          (json['button_label_loc'] as Map).cast<String, dynamic>()),
      statusLoc: StatusLoc.fromJson(
          (json['status_loc'] as Map).cast<String, dynamic>()),
      commonLoc: CommonLoc.fromJson(
          (json['common_loc'] as Map).cast<String, dynamic>()),
      colorSchemeNameLoc: ColorSchemeNameLoc.fromJson(
          (json['color_scheme_name_loc'] as Map).cast<String, dynamic>()),
      configFiltersLoc: ConfigFiltersLoc.fromJson(
          (json['config_filters_loc'] as Map).cast<String, dynamic>()),
    );
  }
  final HomeLoc homeLoc;

  final DeviceTileLoc deviceTileLoc;

  final LoungeLoc loungeLoc;

  final ConfigLoc configLoc;

  final NoDeviceDialogLoc noDeviceDialogLoc;

  final NoConfigDialogLoc noConfigDialogLoc;

  final DeleteConfigDialogLoc deleteConfigDialogLoc;

  final DeviceSettingsLoc deviceSettingsLoc;

  final ConfigManagerLoc configManagerLoc;

  final ConfigScreenLoc configScreenLoc;

  final LogScreenLoc logScreenLoc;

  final RenameSection renameSection;

  final ModeSection modeSection;

  final VideoSection videoSection;

  final AudioSection audioSection;

  final AppSection appSection;

  final DeviceSection deviceSection;

  final WindowSection windowSection;

  final AddFlags addFlags;

  final ConnectLoc connectLoc;

  final TestConfigLoc testConfigLoc;

  final ScrcpyManagerLoc scrcpyManagerLoc;

  final SettingsLoc settingsLoc;

  final CompanionLoc companionLoc;

  final AboutLoc aboutLoc;

  final QuitDialogLoc quitDialogLoc;

  final DisconnectDialogLoc disconnectDialogLoc;

  final CloseDialogLoc closeDialogLoc;

  final ServerDisclaimerLoc serverDisclaimerLoc;

  final IpHistoryLoc ipHistoryLoc;

  final ButtonLabelLoc buttonLabelLoc;

  final StatusLoc statusLoc;

  final CommonLoc commonLoc;

  final ColorSchemeNameLoc colorSchemeNameLoc;

  final ConfigFiltersLoc configFiltersLoc;

  Map<String, Object> get _content => {
        r'''home_loc''': homeLoc,
        r'''device_tile_loc''': deviceTileLoc,
        r'''lounge_loc''': loungeLoc,
        r'''config_loc''': configLoc,
        r'''no_device_dialog_loc''': noDeviceDialogLoc,
        r'''no_config_dialog_loc''': noConfigDialogLoc,
        r'''delete_config_dialog_loc''': deleteConfigDialogLoc,
        r'''device_settings_loc''': deviceSettingsLoc,
        r'''config_manager_loc''': configManagerLoc,
        r'''config_screen_loc''': configScreenLoc,
        r'''log_screen_loc''': logScreenLoc,
        r'''rename_section''': renameSection,
        r'''mode_section''': modeSection,
        r'''video_section''': videoSection,
        r'''audio_section''': audioSection,
        r'''app_section''': appSection,
        r'''device_section''': deviceSection,
        r'''window_section''': windowSection,
        r'''add_flags''': addFlags,
        r'''connect_loc''': connectLoc,
        r'''test_config_loc''': testConfigLoc,
        r'''scrcpy_manager_loc''': scrcpyManagerLoc,
        r'''settings_loc''': settingsLoc,
        r'''companion_loc''': companionLoc,
        r'''about_loc''': aboutLoc,
        r'''quit_dialog_loc''': quitDialogLoc,
        r'''disconnect_dialog_loc''': disconnectDialogLoc,
        r'''close_dialog_loc''': closeDialogLoc,
        r'''server_disclaimer_loc''': serverDisclaimerLoc,
        r'''ip_history_loc''': ipHistoryLoc,
        r'''button_label_loc''': buttonLabelLoc,
        r'''status_loc''': statusLoc,
        r'''common_loc''': commonLoc,
        r'''color_scheme_name_loc''': colorSchemeNameLoc,
        r'''config_filters_loc''': configFiltersLoc,
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
  ),
  deviceTileLoc: DeviceTileLoc(
    runningInstances: ({required String count}) => '''Running (${count})''',
    context: DeviceTileLocContext(
      disconnect: 'Disconnect',
      toWireless: 'To wireless',
      killRunning: 'Kill running scrcpy',
      scrcpy: 'Scrcpy',
      all: 'All',
      allScrcpy: 'Kill all scrcpy',
      manage: 'Manage',
    ),
  ),
  loungeLoc: LoungeLoc(
    controls: LoungeLocControls(
      label: 'Controls',
    ),
    pinnedApps: LoungeLocPinnedApps(
      label: 'Pinned apps',
    ),
    launcher: LoungeLocLauncher(
      label: 'App launcher',
    ),
    running: LoungeLocRunning(
      label: ({required String count}) => '''Running instances (${count})''',
    ),
    appTile: LoungeLocAppTile(
      contextMenu: LoungeLocAppTileContextMenu(
        pin: ({required String config}) => '''Pin on ${config}''',
        unpin: 'Unpin',
        forceClose: 'Force close & start',
        selectConfig: 'Select a config first',
      ),
    ),
    placeholders: LoungeLocPlaceholders(
      config: 'Select config',
      app: 'Select app',
      search: '''Press '/' to search''',
    ),
    tooltip: LoungeLocTooltip(
      missingConfig: ({required String config}) =>
          '''Missing config: ${config}''',
      pin: 'Pin app/config pair',
      onConfig: ({required String config}) => '''On: ${config}''',
    ),
    info: LoungeLocInfo(
      emptySearch: 'No apps found',
      emptyPin: 'No pinned apps',
      emptyInstance: 'No running instance',
    ),
  ),
  configLoc: ConfigLoc(
    label: ({required String count}) => '''Configs (${count})''',
    new$: 'Create',
    select: 'Select a config',
    details: 'Show details',
    start: 'Start',
    empty: 'No config found',
  ),
  noDeviceDialogLoc: NoDeviceDialogLoc(
    title: 'Device',
    contentsEdit:
        '''No device selected. \nSelect a device to edit scrcpy config.''',
    contentsStart: '''No device selected. \nSelect a device to start scrcpy.''',
    contentsNew:
        '''No device selected. \nSelect a device to create scrcpy config.''',
  ),
  noConfigDialogLoc: NoConfigDialogLoc(
    title: 'Config',
    contents: '''No config selected.\nSelect a scrcpy config to start.''',
  ),
  deleteConfigDialogLoc: DeleteConfigDialogLoc(
    title: 'Confirm',
    contents: ({required String configname}) => '''Delete ${configname}?''',
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
      info: 'Start (1) scrcpy with selected config on device connection',
    ),
    doNothing: 'Do nothing',
    scrcpyInfo: DeviceSettingsLocScrcpyInfo(
      fetching: 'Getting scrcpy info',
      label: 'Scrcpy info',
      name: ({required String name}) => '''Name: ${name}''',
      id: ({required String id}) => '''ID: ${id}''',
      model: ({required String model}) => '''Model: ${model}''',
      version: ({required String version}) => '''Android version: ${version}''',
      displays: ({required String count}) => '''Displays (${count})''',
      cameras: ({required String count}) => '''Cameras (${count})''',
      videoEnc: ({required String count}) => '''Video encoders (${count})''',
      audioEnc: ({required String count}) => '''Audio encoders (${count})''',
    ),
  ),
  configManagerLoc: ConfigManagerLoc(
    title: 'Configs manager',
  ),
  configScreenLoc: ConfigScreenLoc(
    title: 'Config settings',
    connectionLost: 'Lost connection to device',
    similarExist: ({required String count}) =>
        '''Similar config exists (${count})''',
  ),
  logScreenLoc: LogScreenLoc(
    title: 'Test log',
    dialog: LogScreenLocDialog(
      title: 'Command',
    ),
  ),
  renameSection: RenameSection(
    title: 'Rename',
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
        alt: '''uses '--record=' flag ''',
      ),
    ),
    scrcpyMode: ModeSectionScrcpyMode(
      both: 'Audio + video',
      audioOnly: 'Audio only',
      videoOnly: 'Video only',
      info: ModeSectionScrcpyModeInfo(
        default$: 'defaults to both, no flag',
        alt: ({required String command}) => '''uses '${command}' flag ''',
      ),
    ),
  ),
  videoSection: VideoSection(
    title: 'Video',
    displays: VideoSectionDisplays(
      label: 'Displays',
      info: VideoSectionDisplaysInfo(
        default$: 'defaults to first available, no flag',
        alt: '''uses '--display-id=' flag ''',
      ),
      virtual: VideoSectionDisplaysVirtual(
        label: 'Virtual display settings',
        newDisplay: VideoSectionDisplaysVirtualNewDisplay(
          label: 'New display',
          info: VideoSectionDisplaysVirtualNewDisplayInfo(
            alt: '''uses '--new-display' flag''',
          ),
        ),
        resolution: VideoSectionDisplaysVirtualResolution(
          label: 'Resolution',
          info: VideoSectionDisplaysVirtualResolutionInfo(
            default$: '''defaults to device's resolution''',
            alt: ({required String res}) =>
                '''appends resolution to '--new-display=${res}' flag''',
          ),
        ),
        dpi: VideoSectionDisplaysVirtualDpi(
          label: 'DPI',
          info: VideoSectionDisplaysVirtualDpiInfo(
            default$: '''defaults to device's DPI''',
            alt: ({required String res, required String dpi}) =>
                '''appends DPI to '--new-display=${res}/${dpi}' flag''',
          ),
        ),
        deco: VideoSectionDisplaysVirtualDeco(
          label: 'Disable system decorations',
          info: VideoSectionDisplaysVirtualDecoInfo(
            default$: 'defaults with system decorations',
            alt: '''uses '--no-vd-system-decorations' flag''',
          ),
        ),
        preserve: VideoSectionDisplaysVirtualPreserve(
          label: 'Preserve app',
          info: VideoSectionDisplaysVirtualPreserveInfo(
            default$:
                'apps are destroyed by default when a scrcpy session ends',
            alt:
                '''move app to main display when session ends; uses '--no-vd-destroy-content' flag''',
          ),
        ),
      ),
    ),
    codec: VideoSectionCodec(
      label: 'Codec',
      info: VideoSectionCodecInfo(
        default$: 'defaults to h264, no flag',
        alt: ({required String codec}) =>
            '''uses '--video-codec=${codec}' flag ''',
      ),
    ),
    encoder: VideoSectionEncoder(
      label: 'Encoder',
      info: VideoSectionEncoderInfo(
        default$: 'defaults to first available, no flag',
        alt: ({required String encoder}) =>
            '''uses '--video-encoder=${encoder}' flag ''',
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
            '''uses '--video-bit-rate=${bitrate}M' flag ''',
      ),
    ),
    fpsLimit: VideoSectionFpsLimit(
      label: 'FPS limit',
      info: VideoSectionFpsLimitInfo(
        default$: 'no flag unless set',
        alt: ({required String fps}) => '''uses '--max-fps=${fps}' flag ''',
      ),
    ),
    resolutionScale: VideoSectionResolutionScale(
      label: 'Resolution scale',
      info: VideoSectionResolutionScaleInfo(
        default$:
            '''calculated based on device's resolution, no flag unless set''',
        alt: ({required String size}) => '''uses '--max-size=${size}' flag ''',
      ),
    ),
  ),
  audioSection: AudioSection(
    title: 'Audio',
    duplicate: AudioSectionDuplicate(
      label: 'Duplicate audio',
      info: AudioSectionDuplicateInfo(
        default$: 'only for Android 13 and above',
        alt: '''uses '--audio-dup' flag ''',
      ),
    ),
    source: AudioSectionSource(
      label: 'Source',
      info: AudioSectionSourceInfo(
        default$: 'defaults to output, no flag',
        alt: ({required String source}) => '''uses '${source}' flag ''',
        inCaseOfDup: '''implied to 'Playback' with '--audio-dup', no flag''',
      ),
    ),
    codec: AudioSectionCodec(
      label: 'Codec',
      info: AudioSectionCodecInfo(
        default$: 'defaults to opus, no flag',
        alt: ({required String codec}) =>
            '''uses '--audio-codec=${codec}' flag ''',
        isAudioOnly: ({required String format, required String codec}) =>
            '''Format: ${format}, requires Codec: ${codec}''',
      ),
    ),
    encoder: AudioSectionEncoder(
      label: 'Encoder',
      info: AudioSectionEncoderInfo(
        default$: 'defaults to first available, no flag',
        alt: ({required String encoder}) =>
            '''uses '--audio-encoder=${encoder}' flag ''',
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
            '''uses '--audio-bit-rate=${bitrate}K' flag ''',
      ),
    ),
  ),
  appSection: AppSection(
    title: 'Start app',
    select: AppSectionSelect(
      label: 'Select an app',
      info: AppSectionSelectInfo(
        alt: ({required String app}) => '''uses '--start-app=${app}' flag ''',
        fc: ({required String app}) => '''uses '--start-app=+${app}' flag ''',
      ),
    ),
    forceClose: AppSectionForceClose(
      label: 'Force close app before starting',
      info: AppSectionForceCloseInfo(
        alt: '''prepend the app package name with '+' ''',
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
        alt: '''uses '--stay-awake' flag ''',
      ),
    ),
    showTouches: DeviceSectionShowTouches(
      label: 'Show touches',
      info: DeviceSectionShowTouchesInfo(
        default$:
            'show finger touches, only works with physical touches on the device',
        alt: '''uses '--show-touches' flag ''',
      ),
    ),
    offDisplayStart: DeviceSectionOffDisplayStart(
      label: 'Turn off display on start',
      info: DeviceSectionOffDisplayStartInfo(
        default$: 'turn device display off, on scrcpy start',
        alt: '''uses '--turn-screen-off' flag ''',
      ),
    ),
    offDisplayExit: DeviceSectionOffDisplayExit(
      label: 'Turn off display on exit',
      info: DeviceSectionOffDisplayExitInfo(
        default$: 'turn device display off, on scrcpy exit',
        alt: '''uses '--power-off-on-close' flag ''',
      ),
    ),
    screensaver: DeviceSectionScreensaver(
      label: 'Disable screensaver (HOST)',
      info: DeviceSectionScreensaverInfo(
        default$: 'disable screensaver',
        alt: '''uses '--disable-screensaver' flag ''',
      ),
    ),
  ),
  windowSection: WindowSection(
    title: 'Window',
    hideWindow: WindowSectionHideWindow(
      label: 'Hide window',
      info: WindowSectionHideWindowInfo(
        default$: 'start scrcpy with no window',
        alt: '''uses '--no-window' flag ''',
      ),
    ),
    borderless: WindowSectionBorderless(
      label: 'Borderless',
      info: WindowSectionBorderlessInfo(
        default$: 'disable window decorations',
        alt: '''uses '--window-borderless' flag ''',
      ),
    ),
    alwaysOnTop: WindowSectionAlwaysOnTop(
      label: 'Always on top',
      info: WindowSectionAlwaysOnTopInfo(
        default$: 'scrcpy window always on top',
        alt: '''uses '--always-on-top' flag ''',
      ),
    ),
    timeLimit: WindowSectionTimeLimit(
      label: 'Time limit',
      info: WindowSectionTimeLimitInfo(
        default$: 'limits scrcpy session, in seconds',
        alt: ({required String time}) =>
            '''uses '--time-limit=${time}' flag ''',
      ),
    ),
  ),
  addFlags: AddFlags(
    title: 'Additional flags',
    add: 'Add',
    info: 'avoid using flags that are already an option',
  ),
  connectLoc: ConnectLoc(
    title: 'Connect',
    withIp: ConnectLocWithIp(
      label: 'Connect with IP',
      connect: 'Connect',
      connected: ({required String to}) => '''Connected to ${to}''',
    ),
    withMdns: ConnectLocWithMdns(
      label: ({required String count}) => '''MDNS devices (${count})''',
      info: ConnectLocWithMdnsInfo(
        i1: 'Make sure your device is paired to your PC.',
        i2: 'If your device is not showing, try turning Wireless ADB off and on.',
        i3: 'MDNS devices usually will connect automatically if paired.',
      ),
    ),
    qrPair: ConnectLocQrPair(
      label: 'QR pairing',
      pair: 'Pair device',
      status: ConnectLocQrPairStatus(
        cancelled: 'Pairing cancelled',
        success: 'Pairing successful',
        failed: 'Pairing failed',
      ),
    ),
    unauthenticated: ConnectLocUnauthenticated(
      info: ConnectLocUnauthenticatedInfo(
        i1: 'Check your phone.',
        i2: 'Click allow debugging.',
      ),
    ),
    failed: ConnectLocFailed(
      info: ConnectLocFailedInfo(
        i1: 'Make sure your device is paired to your PC.',
        i2: 'Otherwise, try turning wireless Adb off and on.',
        i3: 'If not paired: ',
        i4: '1. Use the pair windows (top-right button)',
        i5: '2. Plug you device into your PC, allow debugging, and retry.',
      ),
    ),
  ),
  testConfigLoc: TestConfigLoc(
    title: 'Test config',
    preview: 'Command preview',
  ),
  scrcpyManagerLoc: ScrcpyManagerLoc(
    title: 'Scrcpy Manager',
    check: 'Check for update',
    current: ScrcpyManagerLocCurrent(
      label: 'Current',
      inUse: 'In-use',
    ),
    exec: ScrcpyManagerLocExec(
      label: 'Open executable location',
      info: 'Modify with care',
    ),
    infoPopup: ScrcpyManagerLocInfoPopup(
      noUpdate: 'No update available',
      error: 'Error checking for update',
    ),
    updater: ScrcpyManagerLocUpdater(
      label: 'New version available',
      newVersion: 'New version',
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
      cornerRadius: SettingsLocLooksCornerRadius(
        label: 'Corner radius',
      ),
      accentColor: SettingsLocLooksAccentColor(
        label: 'Accent color',
      ),
      tintLevel: SettingsLocLooksTintLevel(
        label: 'Tint level',
      ),
    ),
    behavior: SettingsLocBehavior(
      label: 'App behavior',
      language: SettingsLocBehaviorLanguage(
        label: 'Language',
        info: 'Some languages are AI generated',
      ),
      minimize: SettingsLocBehaviorMinimize(
        label: 'Minimize',
        value: SettingsLocBehaviorMinimizeValue(
          tray: 'to tray',
          taskbar: 'to taskbar',
        ),
      ),
      windowSize: SettingsLocBehaviorWindowSize(
        label: 'Remember window size',
        info: 'Remember window size on exit',
      ),
    ),
  ),
  companionLoc: CompanionLoc(
    title: 'Companion',
    server: CompanionLocServer(
      label: 'Setup server',
      status: 'Status',
      name: CompanionLocServerName(
        label: 'Server name',
        info: 'Default: Scrcpy GUI',
      ),
      port: CompanionLocServerPort(
        label: 'Server port',
        info: 'Default: 8080',
      ),
      secret: CompanionLocServerSecret(
        label: 'Server apikey',
      ),
      autoStart: CompanionLocServerAutoStart(
        label: 'Start server on launch',
      ),
    ),
    client: CompanionLocClient(
      clients: ({required String count}) => '''Connected (${count})''',
      blocked: ({required String count}) => '''Blocked (${count})''',
      noClient: 'No clients connected',
      noBlocked: 'No blocked clients',
    ),
    qr: 'Scan the QR code from the companion app',
  ),
  aboutLoc: AboutLoc(
    title: 'About',
    version: 'Version',
    author: 'Author',
    credits: 'Credits',
  ),
  quitDialogLoc: QuitDialogLoc(
    title: 'Quit Scrcpy GUI?',
    killRunning: QuitDialogLocKillRunning(
      label: 'Kill running?',
      info: ({required String count}) =>
          '''${count} scrcpy(s). Scrcpys with no window will be killed regardless''',
    ),
    disconnect: QuitDialogLocDisconnect(
      label: 'Disconnect wireless ADB?',
      info: ({required String count}) => '''${count} device(s)''',
    ),
  ),
  disconnectDialogLoc: DisconnectDialogLoc(
    title: ({required String name}) => '''Disconnect ${name}?''',
    hasRunning: DisconnectDialogLocHasRunning(
      label: ({required String name, required String count}) =>
          '''${name} has ${count} running scrcpy(s)''',
      info: 'Disconnecting will kill the scrcpy(s)',
    ),
  ),
  closeDialogLoc: CloseDialogLoc(
    notAllowed: 'Not allowed!',
    overwrite: 'Overwrite?',
    nameExist: 'Name already exists!',
    save: 'Save config?',
    commandPreview: 'Command preview:',
    name: 'Name:',
  ),
  serverDisclaimerLoc: ServerDisclaimerLoc(
    title: 'Disclaimer',
    contents:
        '''Security Warning: The companion server uses an unencrypted connection.\n\nOnly start the server if you are connected to a private network you trust, such as your home Wi-Fi.''',
  ),
  ipHistoryLoc: IpHistoryLoc(
    title: 'History',
    empty: 'No history',
  ),
  buttonLabelLoc: ButtonLabelLoc(
    ok: 'Ok',
    close: 'Close',
    cancel: 'Cancel',
    stop: 'Stop',
    testConfig: 'Test config',
    update: 'Update',
    info: 'Info',
    selectAll: 'Select all',
    quit: 'Quit',
    discard: 'Discard',
    overwrite: 'Overwrite',
    save: 'Save',
    clear: 'Clear',
    filter: 'Filter configs',
    delete: 'Delete',
    serverAgree: 'I understand, start server',
    reorder: 'Reorder',
    stopAll: 'Stop all',
  ),
  statusLoc: StatusLoc(
    failed: 'Failed',
    unauth: 'Unauthenticated',
    error: 'Error',
    latest: 'Latest',
    closing: 'Closing',
    copied: 'Copied',
    running: 'Running',
    stopped: 'Stopped',
  ),
  commonLoc: CommonLoc(
    default$: 'Default',
    yes: 'Yes',
    no: 'No',
    bundled: 'Bundled',
  ),
  colorSchemeNameLoc: ColorSchemeNameLoc(
    blue: 'Blue',
    gray: 'Gray',
    green: 'Green',
    neutral: 'Neutral',
    orange: 'Orange',
    red: 'Red',
    rose: 'Rose',
    slate: 'Slate',
    stone: 'Stone',
    violet: 'Violet',
    yellow: 'Yellow',
    zinc: 'Zinc',
  ),
  configFiltersLoc: ConfigFiltersLoc(
    label: ConfigFiltersLocLabel(
      withApp: 'With app',
      virt: 'Virtual display',
    ),
  ),
);
final LocalizationMessages es = LocalizationMessages(
  homeLoc: HomeLoc(
    title: 'Inicio',
    devices: HomeLocDevices(
      label: ({required String count}) =>
          '''Dispositivos conectados (${count})''',
    ),
  ),
  deviceTileLoc: DeviceTileLoc(
    runningInstances: ({required String count}) =>
        '''En ejecución (${count})''',
    context: DeviceTileLocContext(
      disconnect: 'Desconectar',
      toWireless: 'A inalámbrico',
      killRunning: 'Detener scrcpy en ejecución',
      scrcpy: 'Scrcpy',
      all: 'Todos',
      allScrcpy: 'Detener todo scrcpy',
      manage: 'Administrar',
    ),
  ),
  loungeLoc: LoungeLoc(
    controls: LoungeLocControls(
      label: 'Controles',
    ),
    pinnedApps: LoungeLocPinnedApps(
      label: 'Aplicaciones ancladas',
    ),
    launcher: LoungeLocLauncher(
      label: 'Lanzador de aplicaciones',
    ),
    running: LoungeLocRunning(
      label: ({required String count}) =>
          '''Instancias en ejecución (${count})''',
    ),
    appTile: LoungeLocAppTile(
      contextMenu: LoungeLocAppTileContextMenu(
        pin: ({required String config}) => '''Anclar en ${config}''',
        unpin: 'Desanclar',
        forceClose: 'Forzar cierre y iniciar',
        selectConfig: 'Selecciona una configuración primero',
      ),
    ),
    placeholders: LoungeLocPlaceholders(
      config: 'Seleccionar configuración',
      app: 'Seleccionar aplicación',
      search: '''Presiona '/' para buscar''',
    ),
    tooltip: LoungeLocTooltip(
      missingConfig: ({required String config}) =>
          '''Configuración faltante: ${config}''',
      pin: 'Anclar par aplicación/configuración',
      onConfig: ({required String config}) => '''En: ${config}''',
    ),
    info: LoungeLocInfo(
      emptySearch: 'No se encontraron aplicaciones',
      emptyPin: 'No hay aplicaciones ancladas',
      emptyInstance: 'Ninguna instancia en ejecución',
    ),
  ),
  configLoc: ConfigLoc(
    label: ({required String count}) => '''Configuraciones (${count})''',
    new$: 'Crear',
    select: 'Seleccionar una configuración',
    details: 'Mostrar detalles',
    start: 'Iniciar',
    empty: 'Ninguna configuración encontrada',
  ),
  noDeviceDialogLoc: NoDeviceDialogLoc(
    title: 'Dispositivo',
    contentsEdit:
        '''Ningún dispositivo seleccionado. \nSeleccione un dispositivo para editar la configuración de scrcpy.''',
    contentsStart:
        '''Ningún dispositivo seleccionado. \nSeleccione un dispositivo para iniciar scrcpy.''',
    contentsNew:
        '''Ningún dispositivo seleccionado. \nSeleccione un dispositivo para crear la configuración de scrcpy.''',
  ),
  noConfigDialogLoc: NoConfigDialogLoc(
    title: 'Configuración',
    contents:
        '''Ninguna configuración seleccionada.\nSeleccione una configuración de scrcpy para iniciar.''',
  ),
  deleteConfigDialogLoc: DeleteConfigDialogLoc(
    title: 'Confirmar',
    contents: ({required String configname}) => '''¿Eliminar ${configname}?''',
  ),
  deviceSettingsLoc: DeviceSettingsLoc(
    title: 'Ajustes',
    info: 'Información',
    refresh: 'Actualizar información',
    rename: DeviceSettingsLocRename(
      label: 'Renombrar',
      info: 'Presione [Enter] para aplicar el nombre',
    ),
    autoConnect: DeviceSettingsLocAutoConnect(
      label: 'Conexión automática',
      info: 'Conectar automáticamente dispositivo inalámbrico',
    ),
    onConnected: DeviceSettingsLocOnConnected(
      label: 'Al conectar',
      info:
          'Iniciar (1) scrcpy con la configuración seleccionada al conectar el dispositivo',
    ),
    doNothing: 'No hacer nada',
    scrcpyInfo: DeviceSettingsLocScrcpyInfo(
      fetching: 'Obteniendo información de scrcpy',
      label: 'Información de scrcpy',
      name: ({required String name}) => '''Nombre: ${name}''',
      id: ({required String id}) => '''ID: ${id}''',
      model: ({required String model}) => '''Modelo: ${model}''',
      version: ({required String version}) =>
          '''Versión de Android: ${version}''',
      displays: ({required String count}) => '''Pantallas (${count})''',
      cameras: ({required String count}) => '''Cámaras (${count})''',
      videoEnc: ({required String count}) =>
          '''Codificadores de vídeo (${count})''',
      audioEnc: ({required String count}) =>
          '''Codificadores de audio (${count})''',
    ),
  ),
  configManagerLoc: ConfigManagerLoc(
    title: 'Administrador de configuraciones',
  ),
  configScreenLoc: ConfigScreenLoc(
    title: 'Ajustes de configuración',
    connectionLost: 'Conexión del dispositivo perdida',
    similarExist: ({required String count}) =>
        '''Existe una configuración similar (${count})''',
  ),
  logScreenLoc: LogScreenLoc(
    title: 'Registro de prueba',
    dialog: LogScreenLocDialog(
      title: 'Comando',
    ),
  ),
  renameSection: RenameSection(
    title: 'Renombrar',
  ),
  modeSection: ModeSection(
    title: 'Modo',
    saveFolder: ModeSectionSaveFolder(
      label: 'Carpeta de guardado',
      info:
          '''agrega la ruta de guardado a '--record=rutadeguardado/archivo' ''',
    ),
    mainMode: ModeSectionMainMode(
      label: 'Modo',
      mirror: 'Espejo',
      record: 'Grabar',
      info: ModeSectionMainModeInfo(
        default$: 'espejo o grabar, sin indicador para espejo',
        alt: '''usa el indicador '--record=' ''',
      ),
    ),
    scrcpyMode: ModeSectionScrcpyMode(
      both: 'Audio + vídeo',
      audioOnly: 'Solo audio',
      videoOnly: 'Solo vídeo',
      info: ModeSectionScrcpyModeInfo(
        default$: 'por defecto ambos, sin indicador',
        alt: ({required String command}) =>
            '''usa el indicador '${command}' ''',
      ),
    ),
  ),
  videoSection: VideoSection(
    title: 'Vídeo',
    displays: VideoSectionDisplays(
      label: 'Pantallas',
      info: VideoSectionDisplaysInfo(
        default$: 'por defecto la primera disponible, sin indicador',
        alt: '''usa el indicador '--display-id=' ''',
      ),
      virtual: VideoSectionDisplaysVirtual(
        label: 'Ajustes de pantalla virtual',
        newDisplay: VideoSectionDisplaysVirtualNewDisplay(
          label: 'Nueva pantalla',
          info: VideoSectionDisplaysVirtualNewDisplayInfo(
            alt: '''usa el indicador '--new-display' ''',
          ),
        ),
        resolution: VideoSectionDisplaysVirtualResolution(
          label: 'Resolución',
          info: VideoSectionDisplaysVirtualResolutionInfo(
            default$: 'por defecto la resolución del dispositivo',
            alt: ({required String res}) =>
                '''agrega la resolución al indicador '--new-display=${res}' ''',
          ),
        ),
        dpi: VideoSectionDisplaysVirtualDpi(
          label: 'DPI',
          info: VideoSectionDisplaysVirtualDpiInfo(
            default$: 'por defecto el DPI del dispositivo',
            alt: ({required String res, required String dpi}) =>
                '''agrega el DPI al indicador '--new-display=${res}/${dpi}' ''',
          ),
        ),
        deco: VideoSectionDisplaysVirtualDeco(
          label: 'Deshabilitar decoraciones del sistema',
          info: VideoSectionDisplaysVirtualDecoInfo(
            default$: 'por defecto con decoraciones del sistema',
            alt: '''usa el indicador '--no-vd-system-decorations' ''',
          ),
        ),
        preserve: VideoSectionDisplaysVirtualPreserve(
          label: 'Preservar aplicación',
          info: VideoSectionDisplaysVirtualPreserveInfo(
            default$:
                'las aplicaciones se destruyen por defecto cuando una sesión de scrcpy termina',
            alt:
                '''mueve la aplicación a la pantalla principal cuando la sesión termina; usa el indicador '--no-vd-destroy-content' ''',
          ),
        ),
      ),
    ),
    codec: VideoSectionCodec(
      label: 'Códec',
      info: VideoSectionCodecInfo(
        default$: 'por defecto h264, sin indicador',
        alt: ({required String codec}) =>
            '''usa el indicador '--video-codec=${codec}' ''',
      ),
    ),
    encoder: VideoSectionEncoder(
      label: 'Codificador',
      info: VideoSectionEncoderInfo(
        default$: 'por defecto el primero disponible, sin indicador',
        alt: ({required String encoder}) =>
            '''usa el indicador '--video-encoder=${encoder}' ''',
      ),
    ),
    format: VideoSectionFormat(
      label: 'Formato',
      info: VideoSectionFormatInfo(
        default$: ({required String format}) =>
            '''agrega el formato a '--record=rutadeguardado/archivo${format}' "''',
      ),
    ),
    bitrate: VideoSectionBitrate(
      label: 'Tasa de bits',
      info: VideoSectionBitrateInfo(
        default$: 'por defecto 8M, sin indicador',
        alt: ({required String bitrate}) =>
            '''usa el indicador '--video-bit-rate=${bitrate}M' ''',
      ),
    ),
    fpsLimit: VideoSectionFpsLimit(
      label: 'Límite de FPS',
      info: VideoSectionFpsLimitInfo(
        default$: 'sin indicador a menos que se establezca',
        alt: ({required String fps}) =>
            '''usa el indicador '--max-fps=${fps}' ''',
      ),
    ),
    resolutionScale: VideoSectionResolutionScale(
      label: 'Escala de resolución',
      info: VideoSectionResolutionScaleInfo(
        default$:
            'calculada en base a la resolución del dispositivo, sin indicador a menos que se establezca',
        alt: ({required String size}) =>
            '''usa el indicador '--max-size=${size}' ''',
      ),
    ),
  ),
  audioSection: AudioSection(
    title: 'Audio',
    duplicate: AudioSectionDuplicate(
      label: 'Duplicar audio',
      info: AudioSectionDuplicateInfo(
        default$: 'solo para Android 13 y superior',
        alt: '''usa el indicador '--audio-dup' ''',
      ),
    ),
    source: AudioSectionSource(
      label: 'Fuente',
      info: AudioSectionSourceInfo(
        default$: 'por defecto salida, sin indicador',
        alt: ({required String source}) => '''usa el indicador '${source}' ''',
        inCaseOfDup:
            '''implicado a 'Reproducción' con '--audio-dup', sin indicador''',
      ),
    ),
    codec: AudioSectionCodec(
      label: 'Códec',
      info: AudioSectionCodecInfo(
        default$: 'por defecto opus, sin indicador',
        alt: ({required String codec}) =>
            '''usa el indicador '--audio-codec=${codec}' ''',
        isAudioOnly: ({required String format, required String codec}) =>
            '''Formato: ${format}, requiere Códec: ${codec}''',
      ),
    ),
    encoder: AudioSectionEncoder(
      label: 'Codificador',
      info: AudioSectionEncoderInfo(
        default$: 'por defecto el primero disponible, sin indicador',
        alt: ({required String encoder}) =>
            '''usa el indicador '--audio-encoder=${encoder}' ''',
      ),
    ),
    format: AudioSectionFormat(
      label: 'Formato',
      info: AudioSectionFormatInfo(
        default$: ({required String format}) =>
            '''agrega el formato a '--record=rutadeguardado/archivo.${format}' "''',
      ),
    ),
    bitrate: AudioSectionBitrate(
      label: 'Tasa de bits',
      info: AudioSectionBitrateInfo(
        default$: 'por defecto 128k, sin indicador',
        alt: ({required String bitrate}) =>
            '''usa el indicador '--audio-bit-rate=${bitrate}K' ''',
      ),
    ),
  ),
  appSection: AppSection(
    title: 'Iniciar aplicación',
    select: AppSectionSelect(
      label: 'Seleccionar una aplicación',
      info: AppSectionSelectInfo(
        alt: ({required String app}) =>
            '''usa el indicador '--start-app=${app}' ''',
        fc: ({required String app}) =>
            '''usa el indicador '--start-app=+${app}' ''',
      ),
    ),
    forceClose: AppSectionForceClose(
      label: 'Forzar cierre de la aplicación antes de iniciar',
      info: AppSectionForceCloseInfo(
        alt: '''anteponer el nombre del paquete de la aplicación con '+' ''',
      ),
    ),
  ),
  deviceSection: DeviceSection(
    title: 'Dispositivo',
    stayAwake: DeviceSectionStayAwake(
      label: 'Mantener despierto',
      info: DeviceSectionStayAwakeInfo(
        default$:
            'evita que el dispositivo entre en suspensión, solo funciona con conexión usb',
        alt: '''usa el indicador '--stay-awake' ''',
      ),
    ),
    showTouches: DeviceSectionShowTouches(
      label: 'Mostrar toques',
      info: DeviceSectionShowTouchesInfo(
        default$:
            'muestra los toques de los dedos, solo funciona con toques físicos en el dispositivo',
        alt: '''usa el indicador '--show-touches' ''',
      ),
    ),
    offDisplayStart: DeviceSectionOffDisplayStart(
      label: 'Apagar pantalla al iniciar',
      info: DeviceSectionOffDisplayStartInfo(
        default$: 'apaga la pantalla del dispositivo, al iniciar scrcpy',
        alt: '''usa el indicador '--turn-screen-off' ''',
      ),
    ),
    offDisplayExit: DeviceSectionOffDisplayExit(
      label: 'Apagar pantalla al salir',
      info: DeviceSectionOffDisplayExitInfo(
        default$: 'apaga la pantalla del dispositivo, al salir de scrcpy',
        alt: '''usa el indicador '--power-off-on-close' ''',
      ),
    ),
    screensaver: DeviceSectionScreensaver(
      label: 'Deshabilitar protector de pantalla (HOST)',
      info: DeviceSectionScreensaverInfo(
        default$: 'deshabilita el protector de pantalla',
        alt: '''usa el indicador '--disable-screensaver' ''',
      ),
    ),
  ),
  windowSection: WindowSection(
    title: 'Ventana',
    hideWindow: WindowSectionHideWindow(
      label: 'Ocultar ventana',
      info: WindowSectionHideWindowInfo(
        default$: 'inicia scrcpy sin ventana',
        alt: '''usa el indicador '--no-window' ''',
      ),
    ),
    borderless: WindowSectionBorderless(
      label: 'Sin bordes',
      info: WindowSectionBorderlessInfo(
        default$: 'deshabilita las decoraciones de la ventana',
        alt: '''usa el indicador '--window-borderless' ''',
      ),
    ),
    alwaysOnTop: WindowSectionAlwaysOnTop(
      label: 'Siempre encima',
      info: WindowSectionAlwaysOnTopInfo(
        default$: 'ventana de scrcpy siempre encima',
        alt: '''usa el indicador '--always-on-top' ''',
      ),
    ),
    timeLimit: WindowSectionTimeLimit(
      label: 'Límite de tiempo',
      info: WindowSectionTimeLimitInfo(
        default$: 'limita la sesión de scrcpy, en segundos',
        alt: ({required String time}) =>
            '''usa el indicador '--time-limit=${time}' ''',
      ),
    ),
  ),
  addFlags: AddFlags(
    title: 'Indicadores adicionales',
    add: 'Añadir',
    info: 'evite usar indicadores que ya son una opción',
  ),
  connectLoc: ConnectLoc(
    title: 'Conectar',
    withIp: ConnectLocWithIp(
      label: 'Conectar con IP',
      connect: 'Conectar',
      connected: ({required String to}) => '''Conectado a ${to}''',
    ),
    withMdns: ConnectLocWithMdns(
      label: ({required String count}) => '''Dispositivos MDNS (${count})''',
      info: ConnectLocWithMdnsInfo(
        i1: 'Asegúrate de que tu dispositivo esté emparejado con tu PC.',
        i2: 'Si tu dispositivo no aparece, intenta apagar y encender ADB inalámbrico.',
        i3: 'Los dispositivos MDNS generalmente se conectarán automáticamente si están emparejados.',
      ),
    ),
    qrPair: ConnectLocQrPair(
      label: 'Emparejamiento QR',
      pair: 'Emparejar dispositivo',
      status: ConnectLocQrPairStatus(
        cancelled: 'Emparejamiento cancelado',
        success: 'Emparejamiento exitoso',
        failed: 'Emparejamiento fallido',
      ),
    ),
    unauthenticated: ConnectLocUnauthenticated(
      info: ConnectLocUnauthenticatedInfo(
        i1: 'Revisa tu teléfono.',
        i2: 'Haz clic en permitir depuración.',
      ),
    ),
    failed: ConnectLocFailed(
      info: ConnectLocFailedInfo(
        i1: 'Asegúrate de que tu dispositivo esté emparejado con tu PC.',
        i2: 'De lo contrario, intenta apagar y encender Adb inalámbrico.',
        i3: 'Si no está emparejado: ',
        i4: '1. Use la ventana de emparejamiento (botón superior derecho)',
        i5: '2. Conecta tu dispositivo a tu PC, permite la depuración y vuelve a intentarlo.',
      ),
    ),
  ),
  testConfigLoc: TestConfigLoc(
    title: 'Probar configuración',
    preview: 'Vista previa del comando',
  ),
  scrcpyManagerLoc: ScrcpyManagerLoc(
    title: 'Administrador de scrcpy',
    check: 'Buscar actualizaciones',
    current: ScrcpyManagerLocCurrent(
      label: 'Actual',
      inUse: 'En uso',
    ),
    exec: ScrcpyManagerLocExec(
      label: 'Abrir ubicación del ejecutable',
      info: 'Modificar con cuidado',
    ),
    infoPopup: ScrcpyManagerLocInfoPopup(
      noUpdate: 'No hay actualizaciones disponibles',
      error: 'Error al buscar actualizaciones',
    ),
    updater: ScrcpyManagerLocUpdater(
      label: 'Nueva versión disponible',
      newVersion: 'Nueva versión',
    ),
  ),
  settingsLoc: SettingsLoc(
    title: 'Ajustes',
    looks: SettingsLocLooks(
      label: 'Apariencia',
      mode: SettingsLocLooksMode(
        label: 'Modo de tema',
        value: SettingsLocLooksModeValue(
          dark: 'Oscuro',
          light: 'Claro',
          system: 'Sistema',
        ),
      ),
      cornerRadius: SettingsLocLooksCornerRadius(
        label: 'Radio de las esquinas',
      ),
      accentColor: SettingsLocLooksAccentColor(
        label: 'Color de acento',
      ),
      tintLevel: SettingsLocLooksTintLevel(
        label: 'Nivel de tinte',
      ),
    ),
    behavior: SettingsLocBehavior(
      label: 'Comportamiento de la aplicación',
      language: SettingsLocBehaviorLanguage(
        label: 'Idioma',
        info: 'Algunos idiomas son generados por IA',
      ),
      minimize: SettingsLocBehaviorMinimize(
        label: 'Minimizar',
        value: SettingsLocBehaviorMinimizeValue(
          tray: 'a la bandeja',
          taskbar: 'a la barra de tareas',
        ),
      ),
      windowSize: SettingsLocBehaviorWindowSize(
        label: 'Recordar tamaño de ventana',
        info: 'Recordar tamaño de ventana al salir',
      ),
    ),
  ),
  companionLoc: CompanionLoc(
    title: 'Compañero',
    server: CompanionLocServer(
      label: 'Configurar servidor',
      status: 'Estado',
      name: CompanionLocServerName(
        label: 'Nombre del servidor',
        info: 'Predeterminado: Scrcpy GUI',
      ),
      port: CompanionLocServerPort(
        label: 'Puerto del servidor',
        info: 'Predeterminado: 8080',
      ),
      secret: CompanionLocServerSecret(
        label: 'Clave API del servidor',
      ),
      autoStart: CompanionLocServerAutoStart(
        label: 'Iniciar servidor al arrancar',
      ),
    ),
    client: CompanionLocClient(
      clients: ({required String count}) => '''Conectados (${count})''',
      blocked: ({required String count}) => '''Bloqueados (${count})''',
      noClient: 'No hay clientes conectados',
      noBlocked: 'No hay clientes bloqueados',
    ),
    qr: 'Escanea el código QR desde la aplicación compañera',
  ),
  aboutLoc: AboutLoc(
    title: 'Acerca de',
    version: 'Versión',
    author: 'Autor',
    credits: 'Créditos',
  ),
  quitDialogLoc: QuitDialogLoc(
    title: '¿Salir de la GUI de scrcpy?',
    killRunning: QuitDialogLocKillRunning(
      label: '¿Detener scrcpy en ejecución?',
      info: ({required String count}) =>
          '''${count} scrcpy(s). Las instancias sin ventana se cerrarán de todos modos''',
    ),
    disconnect: QuitDialogLocDisconnect(
      label: '¿Desconectar ADB inalámbrico?',
      info: ({required String count}) => '''${count} dispositivo(s)''',
    ),
  ),
  disconnectDialogLoc: DisconnectDialogLoc(
    title: ({required String name}) => '''¿Desconectar ${name}?''',
    hasRunning: DisconnectDialogLocHasRunning(
      label: ({required String name, required String count}) =>
          '''${name} tiene ${count} scrcpy(s) en ejecución''',
      info: 'La desconexión detendrá scrcpy(s)',
    ),
  ),
  closeDialogLoc: CloseDialogLoc(
    notAllowed: '¡No permitido!',
    overwrite: '¿Sobrescribir?',
    nameExist: '¡El nombre ya existe!',
    save: '¿Guardar configuración?',
    commandPreview: 'Vista previa del comando:',
    name: 'Nombre:',
  ),
  serverDisclaimerLoc: ServerDisclaimerLoc(
    title: 'Aviso',
    contents:
        '''Advertencia de seguridad: El servidor compañero utiliza una conexión no cifrada.\n\nInicia el servidor solo si estás conectado a una red privada en la que confíes, como tu Wi-Fi doméstico.''',
  ),
  ipHistoryLoc: IpHistoryLoc(
    title: 'Historial',
    empty: 'Sin historial',
  ),
  buttonLabelLoc: ButtonLabelLoc(
    ok: 'Aceptar',
    close: 'Cerrar',
    cancel: 'Cancelar',
    stop: 'Detener',
    testConfig: 'Probar configuración',
    update: 'Actualizar',
    info: 'Información',
    selectAll: 'Seleccionar todo',
    quit: 'Salir',
    discard: 'Descartar',
    overwrite: 'Sobrescribir',
    save: 'Guardar',
    clear: 'Limpiar',
    filter: 'Filtrar configuraciones',
    delete: 'Eliminar',
    serverAgree: 'Entiendo, iniciar servidor',
    reorder: 'Reordenar',
    stopAll: 'Detener todo',
  ),
  statusLoc: StatusLoc(
    failed: 'Fallido',
    unauth: 'No autenticado',
    error: 'Error',
    latest: 'Último',
    closing: 'Cerrando',
    copied: 'Copiado',
    running: 'En ejecución',
    stopped: 'Detenido',
  ),
  commonLoc: CommonLoc(
    default$: 'Predeterminado',
    yes: 'Sí',
    no: 'No',
    bundled: 'Incluido',
  ),
  colorSchemeNameLoc: ColorSchemeNameLoc(
    blue: 'Azul',
    gray: 'Gris',
    green: 'Verde',
    neutral: 'Neutro',
    orange: 'Naranja',
    red: 'Rojo',
    rose: 'Rosa',
    slate: 'Pizarra',
    stone: 'Piedra',
    violet: 'Violeta',
    yellow: 'Amarillo',
    zinc: 'Zinc',
  ),
  configFiltersLoc: ConfigFiltersLoc(
    label: ConfigFiltersLocLabel(
      withApp: 'Con app',
      virt: 'Pantalla virtual',
    ),
  ),
);
final LocalizationMessages it = LocalizationMessages(
  homeLoc: HomeLoc(
    title: 'Home',
    devices: HomeLocDevices(
      label: ({required String count}) => '''Dispositivi connessi (${count})''',
    ),
  ),
  deviceTileLoc: DeviceTileLoc(
    runningInstances: ({required String count}) =>
        '''In esecuzione (${count})''',
    context: DeviceTileLocContext(
      disconnect: 'Disconnetti',
      toWireless: 'A wireless',
      killRunning: 'Termina scrcpy in esecuzione',
      scrcpy: 'Scrcpy',
      all: 'Tutti',
      allScrcpy: 'Termina tutti gli scrcpy',
      manage: 'Gestisci',
    ),
  ),
  loungeLoc: LoungeLoc(
    controls: LoungeLocControls(
      label: 'Controlli',
    ),
    pinnedApps: LoungeLocPinnedApps(
      label: 'App bloccate',
    ),
    launcher: LoungeLocLauncher(
      label: 'Avvio app',
    ),
    running: LoungeLocRunning(
      label: ({required String count}) =>
          '''Istanze in esecuzione (${count})''',
    ),
    appTile: LoungeLocAppTile(
      contextMenu: LoungeLocAppTileContextMenu(
        pin: ({required String config}) => '''Blocca su ${config}''',
        unpin: 'Sblocca',
        forceClose: 'Forza chiusura e avvia',
        selectConfig: 'Seleziona prima una configurazione',
      ),
    ),
    placeholders: LoungeLocPlaceholders(
      config: 'Seleziona configurazione',
      app: 'Seleziona app',
      search: '''Premi '/' per cercare''',
    ),
    tooltip: LoungeLocTooltip(
      missingConfig: ({required String config}) =>
          '''Configurazione mancante: ${config}''',
      pin: 'Blocca coppia app/configurazione',
      onConfig: ({required String config}) => '''Su: ${config}''',
    ),
    info: LoungeLocInfo(
      emptySearch: 'Nessuna app trovata',
      emptyPin: 'Nessuna app bloccata',
      emptyInstance: 'Nessuna istanza in esecuzione',
    ),
  ),
  configLoc: ConfigLoc(
    label: ({required String count}) => '''Config (${count})''',
    new$: 'Crea',
    select: 'Seleziona una configurazione',
    details: 'Mostra dettagli',
    start: 'Avvia',
    empty: 'Nessuna configurazione trovata',
  ),
  noDeviceDialogLoc: NoDeviceDialogLoc(
    title: 'Dispositivo',
    contentsEdit:
        '''Nessun dispositivo selezionato. \nSeleziona un dispositivo per modificare la configurazione di scrcpy.''',
    contentsStart:
        '''Nessun dispositivo selezionato. \nSeleziona un dispositivo per avviare scrcpy.''',
    contentsNew:
        '''Nessun dispositivo selezionato. \nSeleziona un dispositivo per creare la configurazione di scrcpy.''',
  ),
  noConfigDialogLoc: NoConfigDialogLoc(
    title: 'Configurazione',
    contents:
        '''Nessuna configurazione selezionata.\nSeleziona una configurazione di scrcpy da avviare.''',
  ),
  deleteConfigDialogLoc: DeleteConfigDialogLoc(
    title: 'Conferma',
    contents: ({required String configname}) => '''Eliminare ${configname}?''',
  ),
  deviceSettingsLoc: DeviceSettingsLoc(
    title: 'Impostazioni',
    info: 'Info',
    refresh: 'Aggiorna info',
    rename: DeviceSettingsLocRename(
      label: 'Rinomina',
      info: 'Premi [Invio] per applicare il nome',
    ),
    autoConnect: DeviceSettingsLocAutoConnect(
      label: 'Connessione automatica',
      info: 'Connetti automaticamente il dispositivo wireless',
    ),
    onConnected: DeviceSettingsLocOnConnected(
      label: 'Alla connessione',
      info:
          'Avvia (1) scrcpy con la configurazione selezionata alla connessione del dispositivo',
    ),
    doNothing: 'Non fare nulla',
    scrcpyInfo: DeviceSettingsLocScrcpyInfo(
      fetching: 'Recupero informazioni scrcpy',
      label: 'Informazioni scrcpy',
      name: ({required String name}) => '''Nome: ${name}''',
      id: ({required String id}) => '''ID: ${id}''',
      model: ({required String model}) => '''Modello: ${model}''',
      version: ({required String version}) =>
          '''Versione Android: ${version}''',
      displays: ({required String count}) => '''Display (${count})''',
      cameras: ({required String count}) => '''Fotocamere (${count})''',
      videoEnc: ({required String count}) => '''Encoder video (${count})''',
      audioEnc: ({required String count}) => '''Encoder audio (${count})''',
    ),
  ),
  configManagerLoc: ConfigManagerLoc(
    title: 'Gestore configurazioni',
  ),
  configScreenLoc: ConfigScreenLoc(
    title: 'Impostazioni configurazione',
    connectionLost: 'Connessione al dispositivo persa',
    similarExist: ({required String count}) =>
        '''Esiste una configurazione simile (${count})''',
  ),
  logScreenLoc: LogScreenLoc(
    title: 'Log di test',
    dialog: LogScreenLocDialog(
      title: 'Comando',
    ),
  ),
  renameSection: RenameSection(
    title: 'Rinomina',
  ),
  modeSection: ModeSection(
    title: 'Modalità',
    saveFolder: ModeSectionSaveFolder(
      label: 'Cartella di salvataggio',
      info:
          '''aggiunge il percorso di salvataggio a '--record=percorso_salvataggio/file' ''',
    ),
    mainMode: ModeSectionMainMode(
      label: 'Modalità',
      mirror: 'Mirror',
      record: 'Registra',
      info: ModeSectionMainModeInfo(
        default$: 'mirror o registra, nessun flag per mirror',
        alt: '''usa il flag '--record=' ''',
      ),
    ),
    scrcpyMode: ModeSectionScrcpyMode(
      both: 'Audio + video',
      audioOnly: 'Solo audio',
      videoOnly: 'Solo video',
      info: ModeSectionScrcpyModeInfo(
        default$: 'predefinito su entrambi, nessun flag',
        alt: ({required String command}) => '''usa il flag '${command}' ''',
      ),
    ),
  ),
  videoSection: VideoSection(
    title: 'Video',
    displays: VideoSectionDisplays(
      label: 'Display',
      info: VideoSectionDisplaysInfo(
        default$: 'predefinito sul primo disponibile, nessun flag',
        alt: '''usa il flag '--display-id=' ''',
      ),
      virtual: VideoSectionDisplaysVirtual(
        label: 'Impostazioni display virtuale',
        newDisplay: VideoSectionDisplaysVirtualNewDisplay(
          label: 'Nuovo display',
          info: VideoSectionDisplaysVirtualNewDisplayInfo(
            alt: '''usa il flag '--new-display' ''',
          ),
        ),
        resolution: VideoSectionDisplaysVirtualResolution(
          label: 'Risoluzione',
          info: VideoSectionDisplaysVirtualResolutionInfo(
            default$: 'predefinito sulla risoluzione del dispositivo',
            alt: ({required String res}) =>
                '''aggiunge la risoluzione al flag '--new-display=${res}' ''',
          ),
        ),
        dpi: VideoSectionDisplaysVirtualDpi(
          label: 'DPI',
          info: VideoSectionDisplaysVirtualDpiInfo(
            default$: 'predefinito sul DPI del dispositivo',
            alt: ({required String res, required String dpi}) =>
                '''aggiunge il DPI al flag '--new-display=${res}/${dpi}' ''',
          ),
        ),
        deco: VideoSectionDisplaysVirtualDeco(
          label: 'Disabilita decorazioni di sistema',
          info: VideoSectionDisplaysVirtualDecoInfo(
            default$: 'predefinito con decorazioni di sistema',
            alt: '''usa il flag '--no-vd-system-decorations' ''',
          ),
        ),
        preserve: VideoSectionDisplaysVirtualPreserve(
          label: 'Mantieni app',
          info: VideoSectionDisplaysVirtualPreserveInfo(
            default$:
                'le app vengono distrutte per impostazione predefinita quando una sessione scrcpy termina',
            alt:
                '''sposta l'app sul display principale al termine della sessione; usa il flag '--no-vd-destroy-content' ''',
          ),
        ),
      ),
    ),
    codec: VideoSectionCodec(
      label: 'Codec',
      info: VideoSectionCodecInfo(
        default$: 'predefinito su h264, nessun flag',
        alt: ({required String codec}) =>
            '''usa il flag '--video-codec=${codec}' ''',
      ),
    ),
    encoder: VideoSectionEncoder(
      label: 'Encoder',
      info: VideoSectionEncoderInfo(
        default$: 'predefinito sul primo disponibile, nessun flag',
        alt: ({required String encoder}) =>
            '''usa il flag '--video-encoder=${encoder}' ''',
      ),
    ),
    format: VideoSectionFormat(
      label: 'Formato',
      info: VideoSectionFormatInfo(
        default$: ({required String format}) =>
            '''aggiunge il formato a '--record=percorso_salvataggio/file${format}' "''',
      ),
    ),
    bitrate: VideoSectionBitrate(
      label: 'Bitrate',
      info: VideoSectionBitrateInfo(
        default$: 'predefinito su 8M, nessun flag',
        alt: ({required String bitrate}) =>
            '''usa il flag '--video-bit-rate=${bitrate}M' ''',
      ),
    ),
    fpsLimit: VideoSectionFpsLimit(
      label: 'Limite FPS',
      info: VideoSectionFpsLimitInfo(
        default$: 'nessun flag a meno che non sia impostato',
        alt: ({required String fps}) => '''usa il flag '--max-fps=${fps}' ''',
      ),
    ),
    resolutionScale: VideoSectionResolutionScale(
      label: 'Scala risoluzione',
      info: VideoSectionResolutionScaleInfo(
        default$:
            'calcolata in base alla risoluzione del dispositivo, nessun flag a meno che non sia impostato',
        alt: ({required String size}) =>
            '''usa il flag '--max-size=${size}' ''',
      ),
    ),
  ),
  audioSection: AudioSection(
    title: 'Audio',
    duplicate: AudioSectionDuplicate(
      label: 'Duplica audio',
      info: AudioSectionDuplicateInfo(
        default$: 'solo per Android 13 e versioni successive',
        alt: '''usa il flag '--audio-dup' ''',
      ),
    ),
    source: AudioSectionSource(
      label: 'Sorgente',
      info: AudioSectionSourceInfo(
        default$: 'predefinito su output, nessun flag',
        alt: ({required String source}) => '''usa il flag '${source}' ''',
        inCaseOfDup:
            '''implicito su 'Riproduzione' con '--audio-dup', nessun flag''',
      ),
    ),
    codec: AudioSectionCodec(
      label: 'Codec',
      info: AudioSectionCodecInfo(
        default$: 'predefinito su opus, nessun flag',
        alt: ({required String codec}) =>
            '''usa il flag '--audio-codec=${codec}' ''',
        isAudioOnly: ({required String format, required String codec}) =>
            '''Formato: ${format}, richiede Codec: ${codec}''',
      ),
    ),
    encoder: AudioSectionEncoder(
      label: 'Encoder',
      info: AudioSectionEncoderInfo(
        default$: 'predefinito sul primo disponibile, nessun flag',
        alt: ({required String encoder}) =>
            '''usa il flag '--audio-encoder=${encoder}' ''',
      ),
    ),
    format: AudioSectionFormat(
      label: 'Formato',
      info: AudioSectionFormatInfo(
        default$: ({required String format}) =>
            '''aggiunge il formato a '--record=percorso_salvataggio/file.${format}' "''',
      ),
    ),
    bitrate: AudioSectionBitrate(
      label: 'Bitrate',
      info: AudioSectionBitrateInfo(
        default$: 'predefinito su 128k, nessun flag',
        alt: ({required String bitrate}) =>
            '''usa il flag '--audio-bit-rate=${bitrate}K' ''',
      ),
    ),
  ),
  appSection: AppSection(
    title: 'Avvia app',
    select: AppSectionSelect(
      label: '''Seleziona un'app''',
      info: AppSectionSelectInfo(
        alt: ({required String app}) => '''usa il flag '--start-app=${app}' ''',
        fc: ({required String app}) => '''usa il flag '--start-app=+${app}' ''',
      ),
    ),
    forceClose: AppSectionForceClose(
      label: '''Forza chiusura app prima dell'avvio''',
      info: AppSectionForceCloseInfo(
        alt: '''anteponi il nome del pacchetto dell'app con '+' ''',
      ),
    ),
  ),
  deviceSection: DeviceSection(
    title: 'Dispositivo',
    stayAwake: DeviceSectionStayAwake(
      label: 'Mantieni attivo',
      info: DeviceSectionStayAwakeInfo(
        default$:
            'impedisce al dispositivo di andare in sospensione, funziona solo con connessione USB',
        alt: '''usa il flag '--stay-awake' ''',
      ),
    ),
    showTouches: DeviceSectionShowTouches(
      label: 'Mostra tocchi',
      info: DeviceSectionShowTouchesInfo(
        default$:
            'mostra i tocchi delle dita, funziona solo con tocchi fisici sul dispositivo',
        alt: '''usa il flag '--show-touches' ''',
      ),
    ),
    offDisplayStart: DeviceSectionOffDisplayStart(
      label: '''Spegni display all'avvio''',
      info: DeviceSectionOffDisplayStartInfo(
        default$: '''spegne il display del dispositivo, all'avvio di scrcpy''',
        alt: '''usa il flag '--turn-screen-off' ''',
      ),
    ),
    offDisplayExit: DeviceSectionOffDisplayExit(
      label: '''Spegni display all'uscita''',
      info: DeviceSectionOffDisplayExitInfo(
        default$: '''spegne il display del dispositivo, all'uscita di scrcpy''',
        alt: '''usa il flag '--power-off-on-close' ''',
      ),
    ),
    screensaver: DeviceSectionScreensaver(
      label: 'Disabilita screensaver (HOST)',
      info: DeviceSectionScreensaverInfo(
        default$: 'disabilita lo screensaver',
        alt: '''usa il flag '--disable-screensaver' ''',
      ),
    ),
  ),
  windowSection: WindowSection(
    title: 'Finestra',
    hideWindow: WindowSectionHideWindow(
      label: 'Nascondi finestra',
      info: WindowSectionHideWindowInfo(
        default$: 'avvia scrcpy senza finestra',
        alt: '''usa il flag '--no-window' ''',
      ),
    ),
    borderless: WindowSectionBorderless(
      label: 'Senza bordi',
      info: WindowSectionBorderlessInfo(
        default$: 'disabilita le decorazioni della finestra',
        alt: '''usa il flag '--window-borderless' ''',
      ),
    ),
    alwaysOnTop: WindowSectionAlwaysOnTop(
      label: 'Sempre in primo piano',
      info: WindowSectionAlwaysOnTopInfo(
        default$: 'finestra scrcpy sempre in primo piano',
        alt: '''usa il flag '--always-on-top' ''',
      ),
    ),
    timeLimit: WindowSectionTimeLimit(
      label: 'Limite di tempo',
      info: WindowSectionTimeLimitInfo(
        default$: 'limita la sessione scrcpy, in secondi',
        alt: ({required String time}) =>
            '''usa il flag '--time-limit=${time}' ''',
      ),
    ),
  ),
  addFlags: AddFlags(
    title: 'Flag aggiuntivi',
    add: 'Aggiungi',
    info: '''evitare di usare flag che sono già un'opzione''',
  ),
  connectLoc: ConnectLoc(
    title: 'Connetti',
    withIp: ConnectLocWithIp(
      label: 'Connetti con IP',
      connect: 'Connetti',
      connected: ({required String to}) => '''Connesso a ${to}''',
    ),
    withMdns: ConnectLocWithMdns(
      label: ({required String count}) => '''Dispositivi MDNS (${count})''',
      info: ConnectLocWithMdnsInfo(
        i1: 'Assicurati che il tuo dispositivo sia associato al tuo PC.',
        i2: 'Se il tuo dispositivo non viene visualizzato, prova a disattivare e riattivare ADB wireless.',
        i3: 'I dispositivi MDNS di solito si connettono automaticamente se associati.',
      ),
    ),
    qrPair: ConnectLocQrPair(
      label: 'Associazione QR',
      pair: 'Associa dispositivo',
      status: ConnectLocQrPairStatus(
        cancelled: 'Associazione annullata',
        success: 'Associazione riuscita',
        failed: 'Associazione fallita',
      ),
    ),
    unauthenticated: ConnectLocUnauthenticated(
      info: ConnectLocUnauthenticatedInfo(
        i1: 'Controlla il tuo telefono.',
        i2: 'Clicca su consenti debug.',
      ),
    ),
    failed: ConnectLocFailed(
      info: ConnectLocFailedInfo(
        i1: 'Assicurati che il tuo dispositivo sia associato al tuo PC.',
        i2: 'Altrimenti, prova a disattivare e riattivare Adb wireless.',
        i3: 'Se non associato: ',
        i4: '1. Usa la finestra di associazione (pulsante in alto a destra)',
        i5: '2. Collega il tuo dispositivo al PC, consenti il debug e riprova.',
      ),
    ),
  ),
  testConfigLoc: TestConfigLoc(
    title: 'Prova configurazione',
    preview: 'Anteprima comando',
  ),
  scrcpyManagerLoc: ScrcpyManagerLoc(
    title: 'Gestione Scrcpy',
    check: 'Controlla aggiornamenti',
    current: ScrcpyManagerLocCurrent(
      label: 'Corrente',
      inUse: 'In uso',
    ),
    exec: ScrcpyManagerLocExec(
      label: 'Apri percorso eseguibile',
      info: 'Modificare con attenzione',
    ),
    infoPopup: ScrcpyManagerLocInfoPopup(
      noUpdate: 'Nessun aggiornamento disponibile',
      error: 'Errore durante il controllo degli aggiornamenti',
    ),
    updater: ScrcpyManagerLocUpdater(
      label: 'Nuova versione disponibile',
      newVersion: 'Nuova versione',
    ),
  ),
  settingsLoc: SettingsLoc(
    title: 'Impostazioni',
    looks: SettingsLocLooks(
      label: 'Aspetto',
      mode: SettingsLocLooksMode(
        label: 'Modalità tema',
        value: SettingsLocLooksModeValue(
          dark: 'Scuro',
          light: 'Chiaro',
          system: 'Sistema',
        ),
      ),
      cornerRadius: SettingsLocLooksCornerRadius(
        label: 'Raggio angoli',
      ),
      accentColor: SettingsLocLooksAccentColor(
        label: 'Colore accento',
      ),
      tintLevel: SettingsLocLooksTintLevel(
        label: 'Livello tinta',
      ),
    ),
    behavior: SettingsLocBehavior(
      label: 'Comportamento app',
      language: SettingsLocBehaviorLanguage(
        label: 'Lingua',
        info: '''Alcune lingue sono generate dall'IA''',
      ),
      minimize: SettingsLocBehaviorMinimize(
        label: 'Riduci a icona',
        value: SettingsLocBehaviorMinimizeValue(
          tray: 'a icona',
          taskbar: 'a barra delle applicazioni',
        ),
      ),
      windowSize: SettingsLocBehaviorWindowSize(
        label: 'Ricorda dimensioni finestra',
        info: '''Ricorda le dimensioni della finestra all'uscita''',
      ),
    ),
  ),
  companionLoc: CompanionLoc(
    title: 'Companion',
    server: CompanionLocServer(
      label: 'Configura server',
      status: 'Stato',
      name: CompanionLocServerName(
        label: 'Nome del server',
        info: 'Predefinito: Scrcpy GUI',
      ),
      port: CompanionLocServerPort(
        label: 'Porta del server',
        info: 'Predefinito: 8080',
      ),
      secret: CompanionLocServerSecret(
        label: 'Chiave API del server',
      ),
      autoStart: CompanionLocServerAutoStart(
        label: '''Avvia server all'avvio''',
      ),
    ),
    client: CompanionLocClient(
      clients: ({required String count}) => '''Clienti (${count})''',
      blocked: ({required String count}) => '''Bloccati (${count})''',
      noClient: 'Nessun client connesso',
      noBlocked: 'Nessun client bloccato',
    ),
    qr: '''Scansiona il codice QR dall'app companion''',
  ),
  aboutLoc: AboutLoc(
    title: 'Informazioni',
    version: 'Versione',
    author: 'Autore',
    credits: 'Crediti',
  ),
  quitDialogLoc: QuitDialogLoc(
    title: 'Uscire da Scrcpy GUI?',
    killRunning: QuitDialogLocKillRunning(
      label: 'Terminare in esecuzione?',
      info: ({required String count}) =>
          '''${count} scrcpy(s). Gli scrcpy senza finestra verranno terminati comunque''',
    ),
    disconnect: QuitDialogLocDisconnect(
      label: 'Disconnettere ADB wireless?',
      info: ({required String count}) => '''${count} dispositivo(i)''',
    ),
  ),
  disconnectDialogLoc: DisconnectDialogLoc(
    title: ({required String name}) => '''Disconnettere ${name}?''',
    hasRunning: DisconnectDialogLocHasRunning(
      label: ({required String name, required String count}) =>
          '''${name} ha ${count} scrcpy(s) in esecuzione''',
      info: 'La disconnessione terminerà gli scrcpy(s)',
    ),
  ),
  closeDialogLoc: CloseDialogLoc(
    notAllowed: 'Non consentito!',
    overwrite: 'Sovrascrivere?',
    nameExist: 'Nome già esistente!',
    save: 'Salvare configurazione?',
    commandPreview: 'Anteprima comando:',
    name: 'Nome:',
  ),
  serverDisclaimerLoc: ServerDisclaimerLoc(
    title: 'Avviso',
    contents:
        '''Avviso di sicurezza: Il server companion utilizza una connessione non crittografata.\n\nAvvia il server solo se sei connesso a una rete privata di cui ti fidi, come il tuo Wi-Fi domestico.''',
  ),
  ipHistoryLoc: IpHistoryLoc(
    title: 'Cronologia',
    empty: 'Nessuna cronologia',
  ),
  buttonLabelLoc: ButtonLabelLoc(
    ok: 'Ok',
    close: 'Chiudi',
    cancel: 'Annulla',
    stop: 'Ferma',
    testConfig: 'Prova configurazione',
    update: 'Aggiorna',
    info: 'Info',
    selectAll: 'Seleziona tutto',
    quit: 'Esci',
    discard: 'Scarta',
    overwrite: 'Sovrascrivi',
    save: 'Salva',
    clear: 'Cancella',
    filter: 'Filtra configurazioni',
    delete: 'Elimina',
    serverAgree: 'Capisco, avvia server',
    reorder: 'Riordina',
    stopAll: 'Ferma tutto',
  ),
  statusLoc: StatusLoc(
    failed: 'Fallito',
    unauth: 'Non autenticato',
    error: 'Errore',
    latest: 'Ultimo',
    closing: 'Chiusura in corso',
    copied: 'Copiato',
    running: 'In esecuzione',
    stopped: 'Fermato',
  ),
  commonLoc: CommonLoc(
    default$: 'Predefinito',
    yes: 'Sì',
    no: 'No',
    bundled: 'Incluso',
  ),
  colorSchemeNameLoc: ColorSchemeNameLoc(
    blue: 'Blu',
    gray: 'Grigio',
    green: 'Verde',
    neutral: 'Neutro',
    orange: 'Arancione',
    red: 'Rosso',
    rose: 'Rosa',
    slate: 'Ardesia',
    stone: 'Pietra',
    violet: 'Viola',
    yellow: 'Giallo',
    zinc: 'Zinco',
  ),
  configFiltersLoc: ConfigFiltersLoc(
    label: ConfigFiltersLocLabel(
      withApp: 'Con app',
      virt: 'Display virtuale',
    ),
  ),
);
final LocalizationMessages ms = LocalizationMessages(
  homeLoc: HomeLoc(
    title: 'Laman Utama',
    devices: HomeLocDevices(
      label: ({required String count}) =>
          '''Peranti yang disambungkan (${count})''',
    ),
  ),
  deviceTileLoc: DeviceTileLoc(
    runningInstances: ({required String count}) =>
        '''Sedang Berjalan (${count})''',
    context: DeviceTileLocContext(
      disconnect: 'Putuskan Sambungan',
      toWireless: 'Ke Tanpa Wayar',
      killRunning: 'Hentikan scrcpy',
      scrcpy: 'Scrcpy',
      all: 'Semua',
      allScrcpy: 'Hentikan semua scrcpy',
      manage: 'Urus',
    ),
  ),
  loungeLoc: LoungeLoc(
    controls: LoungeLocControls(
      label: 'Kawalan',
    ),
    pinnedApps: LoungeLocPinnedApps(
      label: 'Aplikasi yang disemat',
    ),
    launcher: LoungeLocLauncher(
      label: 'Pelancar aplikasi',
    ),
    running: LoungeLocRunning(
      label: ({required String count}) =>
          '''Instans sedang berjalan (${count})''',
    ),
    appTile: LoungeLocAppTile(
      contextMenu: LoungeLocAppTileContextMenu(
        pin: ({required String config}) => '''Pin pada ${config}''',
        unpin: 'Buang pin',
        forceClose: 'Paksa tutup & mula',
        selectConfig: 'Pilih konfigurasi dahulu',
      ),
    ),
    placeholders: LoungeLocPlaceholders(
      config: 'Pilih konfigurasi',
      app: 'Pilih aplikasi',
      search: '''Tekan '/' untuk mencari''',
    ),
    tooltip: LoungeLocTooltip(
      missingConfig: ({required String config}) =>
          '''Konfigurasi tiada: ${config}''',
      pin: 'Pin pasangan aplikasi/konfigurasi',
      onConfig: ({required String config}) => '''Pada: ${config}''',
    ),
    info: LoungeLocInfo(
      emptySearch: 'Tiada aplikasi ditemui',
      emptyPin: 'Tiada aplikasi yang di pin',
      emptyInstance: 'Tiada instans sedang berjalan',
    ),
  ),
  configLoc: ConfigLoc(
    label: ({required String count}) => '''Konfigurasi (${count})''',
    new$: 'Cipta',
    select: 'Pilih konfigurasi',
    details: 'Tunjukkan butiran',
    start: 'Mula',
    empty: 'Tiada konfigurasi ditemui',
  ),
  noDeviceDialogLoc: NoDeviceDialogLoc(
    title: 'Peranti',
    contentsEdit:
        '''Tiada peranti dipilih. \nPilih peranti untuk mengedit konfigurasi scrcpy.''',
    contentsStart:
        '''Tiada peranti dipilih. \nPilih peranti untuk memulakan scrcpy.''',
    contentsNew:
        '''Tiada peranti dipilih. \nPilih peranti untuk mencipta konfigurasi scrcpy.''',
  ),
  noConfigDialogLoc: NoConfigDialogLoc(
    title: 'Konfigurasi',
    contents:
        '''Tiada konfigurasi dipilih.\nPilih konfigurasi scrcpy untuk dimulakan.''',
  ),
  deleteConfigDialogLoc: DeleteConfigDialogLoc(
    title: 'Sahkan',
    contents: ({required String configname}) => '''Padam ${configname}?''',
  ),
  deviceSettingsLoc: DeviceSettingsLoc(
    title: 'Tetapan',
    info: 'Maklumat',
    refresh: 'Muat Semula Maklumat',
    rename: DeviceSettingsLocRename(
      label: 'Namakan Semula',
      info: 'Tekan [Enter] untuk menggunakan nama',
    ),
    autoConnect: DeviceSettingsLocAutoConnect(
      label: 'Sambung Automatik',
      info: 'Sambung peranti tanpa wayar secara automatik',
    ),
    onConnected: DeviceSettingsLocOnConnected(
      label: 'Semasa Disambungkan',
      info:
          'Mulakan (1) scrcpy dengan konfigurasi yang dipilih semasa sambungan peranti',
    ),
    doNothing: 'Jangan buat apa-apa',
    scrcpyInfo: DeviceSettingsLocScrcpyInfo(
      fetching: 'Mendapatkan maklumat scrcpy',
      label: 'Maklumat scrcpy',
      name: ({required String name}) => '''Nama: ${name}''',
      id: ({required String id}) => '''ID: ${id}''',
      model: ({required String model}) => '''Model: ${model}''',
      version: ({required String version}) => '''Versi Android: ${version}''',
      displays: ({required String count}) => '''Paparan (${count})''',
      cameras: ({required String count}) => '''Kamera (${count})''',
      videoEnc: ({required String count}) => '''Pengekod video (${count})''',
      audioEnc: ({required String count}) => '''Pengekod audio (${count})''',
    ),
  ),
  configManagerLoc: ConfigManagerLoc(
    title: 'Pengurus konfigurasi',
  ),
  configScreenLoc: ConfigScreenLoc(
    title: 'Tetapan konfigurasi',
    connectionLost: 'Sambungan ke peranti terputus',
    similarExist: ({required String count}) =>
        '''Konfigurasi serupa wujud (${count})''',
  ),
  logScreenLoc: LogScreenLoc(
    title: 'Log Ujian',
    dialog: LogScreenLocDialog(
      title: 'Perintah',
    ),
  ),
  renameSection: RenameSection(
    title: 'Namakan Semula',
  ),
  modeSection: ModeSection(
    title: 'Mod',
    saveFolder: ModeSectionSaveFolder(
      label: 'Folder Simpan',
      info: '''menambah laluan simpan ke '--record=laluan_simpan/fail' ''',
    ),
    mainMode: ModeSectionMainMode(
      label: 'Mod',
      mirror: 'Cermin',
      record: 'Rakam',
      info: ModeSectionMainModeInfo(
        default$: 'cermin atau rakam, tiada bendera untuk cermin',
        alt: '''menggunakan bendera '--record=' ''',
      ),
    ),
    scrcpyMode: ModeSectionScrcpyMode(
      both: 'Audio + video',
      audioOnly: 'Audio sahaja',
      videoOnly: 'Video sahaja',
      info: ModeSectionScrcpyModeInfo(
        default$: 'lalai kepada kedua-duanya, tiada bendera',
        alt: ({required String command}) =>
            '''menggunakan bendera '${command}' ''',
      ),
    ),
  ),
  videoSection: VideoSection(
    title: 'Video',
    displays: VideoSectionDisplays(
      label: 'Paparan',
      info: VideoSectionDisplaysInfo(
        default$: 'lalai kepada yang pertama tersedia, tiada bendera',
        alt: '''menggunakan bendera '--display-id=' ''',
      ),
      virtual: VideoSectionDisplaysVirtual(
        label: 'Tetapan Paparan Maya',
        newDisplay: VideoSectionDisplaysVirtualNewDisplay(
          label: 'Paparan Baru',
          info: VideoSectionDisplaysVirtualNewDisplayInfo(
            alt: '''menggunakan bendera '--new-display' ''',
          ),
        ),
        resolution: VideoSectionDisplaysVirtualResolution(
          label: 'Resolusi',
          info: VideoSectionDisplaysVirtualResolutionInfo(
            default$: 'lalai kepada resolusi peranti',
            alt: ({required String res}) =>
                '''menambah resolusi ke bendera '--new-display=${res}' ''',
          ),
        ),
        dpi: VideoSectionDisplaysVirtualDpi(
          label: 'DPI',
          info: VideoSectionDisplaysVirtualDpiInfo(
            default$: 'lalai kepada DPI peranti',
            alt: ({required String res, required String dpi}) =>
                '''menambah DPI ke bendera '--new-display=${res}/${dpi}' ''',
          ),
        ),
        deco: VideoSectionDisplaysVirtualDeco(
          label: 'Lumpuhkan Hiasan Sistem',
          info: VideoSectionDisplaysVirtualDecoInfo(
            default$: 'lalai dengan hiasan sistem',
            alt: '''menggunakan bendera '--no-vd-system-decorations' ''',
          ),
        ),
        preserve: VideoSectionDisplaysVirtualPreserve(
          label: 'Kekalkan Aplikasi',
          info: VideoSectionDisplaysVirtualPreserveInfo(
            default$:
                'aplikasi dimusnahkan secara lalai apabila sesi scrcpy berakhir',
            alt:
                '''pindahkan aplikasi ke paparan utama apabila sesi berakhir; menggunakan bendera '--no-vd-destroy-content' ''',
          ),
        ),
      ),
    ),
    codec: VideoSectionCodec(
      label: 'Codec',
      info: VideoSectionCodecInfo(
        default$: 'lalai kepada h264, tiada bendera',
        alt: ({required String codec}) =>
            '''menggunakan bendera '--video-codec=${codec}' ''',
      ),
    ),
    encoder: VideoSectionEncoder(
      label: 'Pengekod',
      info: VideoSectionEncoderInfo(
        default$: 'lalai kepada yang pertama tersedia, tiada bendera',
        alt: ({required String encoder}) =>
            '''menggunakan bendera '--video-encoder=${encoder}' ''',
      ),
    ),
    format: VideoSectionFormat(
      label: 'Format',
      info: VideoSectionFormatInfo(
        default$: ({required String format}) =>
            '''menambah format ke '--record=laluan_simpan/fail${format}' "''',
      ),
    ),
    bitrate: VideoSectionBitrate(
      label: 'Kadar Bit',
      info: VideoSectionBitrateInfo(
        default$: 'lalai kepada 8M, tiada bendera',
        alt: ({required String bitrate}) =>
            '''menggunakan bendera '--video-bit-rate=${bitrate}M' ''',
      ),
    ),
    fpsLimit: VideoSectionFpsLimit(
      label: 'Had FPS',
      info: VideoSectionFpsLimitInfo(
        default$: 'tiada bendera melainkan ditetapkan',
        alt: ({required String fps}) =>
            '''menggunakan bendera '--max-fps=${fps}' ''',
      ),
    ),
    resolutionScale: VideoSectionResolutionScale(
      label: 'Skala Resolusi',
      info: VideoSectionResolutionScaleInfo(
        default$:
            'dikira berdasarkan resolusi peranti, tiada bendera melainkan ditetapkan',
        alt: ({required String size}) =>
            '''menggunakan bendera '--max-size=${size}' ''',
      ),
    ),
  ),
  audioSection: AudioSection(
    title: 'Audio',
    duplicate: AudioSectionDuplicate(
      label: 'Gandakan Audio',
      info: AudioSectionDuplicateInfo(
        default$: 'hanya untuk Android 13 dan ke atas',
        alt: '''menggunakan bendera '--audio-dup' ''',
      ),
    ),
    source: AudioSectionSource(
      label: 'Sumber',
      info: AudioSectionSourceInfo(
        default$: 'lalai kepada output, tiada bendera',
        alt: ({required String source}) =>
            '''menggunakan bendera '${source}' ''',
        inCaseOfDup:
            '''tersirat kepada 'Main Semula' dengan '--audio-dup', tiada bendera''',
      ),
    ),
    codec: AudioSectionCodec(
      label: 'Codec',
      info: AudioSectionCodecInfo(
        default$: 'lalai kepada opus, tiada bendera',
        alt: ({required String codec}) =>
            '''menggunakan bendera '--audio-codec=${codec}' ''',
        isAudioOnly: ({required String format, required String codec}) =>
            '''Format: ${format}, memerlukan Codec: ${codec}''',
      ),
    ),
    encoder: AudioSectionEncoder(
      label: 'Pengekod',
      info: AudioSectionEncoderInfo(
        default$: 'lalai kepada yang pertama tersedia, tiada bendera',
        alt: ({required String encoder}) =>
            '''menggunakan bendera '--audio-encoder=${encoder}' ''',
      ),
    ),
    format: AudioSectionFormat(
      label: 'Format',
      info: AudioSectionFormatInfo(
        default$: ({required String format}) =>
            '''menambah format ke '--record=laluan_simpan/fail.${format}' "''',
      ),
    ),
    bitrate: AudioSectionBitrate(
      label: 'Kadar Bit',
      info: AudioSectionBitrateInfo(
        default$: 'lalai kepada 128k, tiada bendera',
        alt: ({required String bitrate}) =>
            '''menggunakan bendera '--audio-bit-rate=${bitrate}K' ''',
      ),
    ),
  ),
  appSection: AppSection(
    title: 'Mulakan Aplikasi',
    select: AppSectionSelect(
      label: 'Pilih Aplikasi',
      info: AppSectionSelectInfo(
        alt: ({required String app}) =>
            '''menggunakan bendera '--start-app=${app}' ''',
        fc: ({required String app}) =>
            '''menggunakan bendera '--start-app=+${app}' ''',
      ),
    ),
    forceClose: AppSectionForceClose(
      label: 'Paksa Tutup Aplikasi Sebelum Memulakan',
      info: AppSectionForceCloseInfo(
        alt: '''awalkan nama pakej aplikasi dengan '+' ''',
      ),
    ),
  ),
  deviceSection: DeviceSection(
    title: 'Peranti',
    stayAwake: DeviceSectionStayAwake(
      label: 'Kekal Berjaga',
      info: DeviceSectionStayAwakeInfo(
        default$:
            'menghalang peranti daripada tidur, hanya berfungsi dengan sambungan USB',
        alt: '''menggunakan bendera '--stay-awake' ''',
      ),
    ),
    showTouches: DeviceSectionShowTouches(
      label: 'Tunjukkan Sentuhan',
      info: DeviceSectionShowTouchesInfo(
        default$:
            'menunjukkan sentuhan jari, hanya berfungsi dengan sentuhan fizikal pada peranti',
        alt: '''menggunakan bendera '--show-touches' ''',
      ),
    ),
    offDisplayStart: DeviceSectionOffDisplayStart(
      label: 'Matikan Paparan Semasa Mula',
      info: DeviceSectionOffDisplayStartInfo(
        default$: 'matikan paparan peranti, semasa permulaan scrcpy',
        alt: '''menggunakan bendera '--turn-screen-off' ''',
      ),
    ),
    offDisplayExit: DeviceSectionOffDisplayExit(
      label: 'Matikan Paparan Semasa Keluar',
      info: DeviceSectionOffDisplayExitInfo(
        default$: 'matikan paparan peranti, semasa keluar scrcpy',
        alt: '''menggunakan bendera '--power-off-on-close' ''',
      ),
    ),
    screensaver: DeviceSectionScreensaver(
      label: 'Lumpuhkan Penjimat Skrin (HOST)',
      info: DeviceSectionScreensaverInfo(
        default$: 'lumpuhkan penjimat skrin',
        alt: '''menggunakan bendera '--disable-screensaver' ''',
      ),
    ),
  ),
  windowSection: WindowSection(
    title: 'Tetingkap',
    hideWindow: WindowSectionHideWindow(
      label: 'Sembunyikan Tetingkap',
      info: WindowSectionHideWindowInfo(
        default$: 'mulakan scrcpy tanpa tetingkap',
        alt: '''menggunakan bendera '--no-window' ''',
      ),
    ),
    borderless: WindowSectionBorderless(
      label: 'Tanpa Sempadan',
      info: WindowSectionBorderlessInfo(
        default$: 'lumpuhkan hiasan tetingkap',
        alt: '''menggunakan bendera '--window-borderless' ''',
      ),
    ),
    alwaysOnTop: WindowSectionAlwaysOnTop(
      label: 'Sentiasa di Atas',
      info: WindowSectionAlwaysOnTopInfo(
        default$: 'tetingkap scrcpy sentiasa di atas',
        alt: '''menggunakan bendera '--always-on-top' ''',
      ),
    ),
    timeLimit: WindowSectionTimeLimit(
      label: 'Had Masa',
      info: WindowSectionTimeLimitInfo(
        default$: 'mengehadkan sesi scrcpy, dalam saat',
        alt: ({required String time}) =>
            '''menggunakan bendera '--time-limit=${time}' ''',
      ),
    ),
  ),
  addFlags: AddFlags(
    title: 'Bendera Tambahan',
    add: 'Tambah',
    info: 'elakkan menggunakan bendera yang sudah menjadi pilihan',
  ),
  connectLoc: ConnectLoc(
    title: 'Sambung',
    withIp: ConnectLocWithIp(
      label: 'Sambung dengan IP',
      connect: 'Sambung',
      connected: ({required String to}) => '''Disambungkan ke ${to}''',
    ),
    withMdns: ConnectLocWithMdns(
      label: ({required String count}) => '''Peranti MDNS (${count})''',
      info: ConnectLocWithMdnsInfo(
        i1: 'Pastikan peranti anda dipasangkan dengan PC anda.',
        i2: 'Jika peranti anda tidak muncul, cuba matikan dan hidupkan ADB Tanpa Wayar.',
        i3: 'Peranti MDNS biasanya akan bersambung secara automatik jika dipasangkan.',
      ),
    ),
    qrPair: ConnectLocQrPair(
      label: 'Pemasangan QR',
      pair: 'Pasangkan Peranti',
      status: ConnectLocQrPairStatus(
        cancelled: 'Pemasangan Dibatalkan',
        success: 'Pemasangan Berjaya',
        failed: 'Pemasangan Gagal',
      ),
    ),
    unauthenticated: ConnectLocUnauthenticated(
      info: ConnectLocUnauthenticatedInfo(
        i1: 'Semak telefon anda.',
        i2: 'Klik benarkan penyahpepijatan.',
      ),
    ),
    failed: ConnectLocFailed(
      info: ConnectLocFailedInfo(
        i1: 'Pastikan peranti anda dipasangkan dengan PC anda.',
        i2: 'Jika tidak, cuba matikan dan hidupkan Adb tanpa wayar.',
        i3: 'Jika tidak dipasangkan: ',
        i4: '1. Gunakan tetingkap pemasangan (butang kanan atas)',
        i5: '2. Palamkan peranti anda ke PC anda, benarkan penyahpepijatan, dan cuba lagi.',
      ),
    ),
  ),
  testConfigLoc: TestConfigLoc(
    title: 'Uji Konfigurasi',
    preview: 'Pratonton Perintah',
  ),
  scrcpyManagerLoc: ScrcpyManagerLoc(
    title: 'Pengurus scrcpy',
    check: 'Semak Kemas Kini',
    current: ScrcpyManagerLocCurrent(
      label: 'Semasa',
      inUse: 'Digunakan',
    ),
    exec: ScrcpyManagerLocExec(
      label: 'Buka Lokasi Boleh Laku',
      info: 'Ubah suai dengan berhati-hati',
    ),
    infoPopup: ScrcpyManagerLocInfoPopup(
      noUpdate: 'Tiada kemas kini tersedia',
      error: 'Ralat menyemak kemas kini',
    ),
    updater: ScrcpyManagerLocUpdater(
      label: 'Versi Baru Tersedia',
      newVersion: 'Versi Baru',
    ),
  ),
  settingsLoc: SettingsLoc(
    title: 'Tetapan',
    looks: SettingsLocLooks(
      label: 'Rupa',
      mode: SettingsLocLooksMode(
        label: 'Mod Tema',
        value: SettingsLocLooksModeValue(
          dark: 'Gelap',
          light: 'Cerah',
          system: 'Sistem',
        ),
      ),
      cornerRadius: SettingsLocLooksCornerRadius(
        label: 'Jejari Sudut',
      ),
      accentColor: SettingsLocLooksAccentColor(
        label: 'Warna Aksen',
      ),
      tintLevel: SettingsLocLooksTintLevel(
        label: 'Tahap Warna',
      ),
    ),
    behavior: SettingsLocBehavior(
      label: 'Tingkah Laku Aplikasi',
      language: SettingsLocBehaviorLanguage(
        label: 'Bahasa',
        info: 'Sesetengah bahasa dijana oleh AI',
      ),
      minimize: SettingsLocBehaviorMinimize(
        label: 'Minimumkan',
        value: SettingsLocBehaviorMinimizeValue(
          tray: 'ke dulang',
          taskbar: 'ke bar tugas',
        ),
      ),
      windowSize: SettingsLocBehaviorWindowSize(
        label: 'Ingat saiz tetingkap',
        info: 'Ingat saiz tetingkap semasa keluar',
      ),
    ),
  ),
  companionLoc: CompanionLoc(
    title: 'Pendamping',
    server: CompanionLocServer(
      label: 'Konfigurasi server',
      status: 'Status',
      name: CompanionLocServerName(
        label: 'Nama server',
        info: 'Lalai: Scrcpy GUI',
      ),
      port: CompanionLocServerPort(
        label: 'Port server',
        info: 'Lalai: 8080',
      ),
      secret: CompanionLocServerSecret(
        label: 'Kunci API server',
      ),
      autoStart: CompanionLocServerAutoStart(
        label: 'Mulakan server sewaktu aplikasi dilancarkan',
      ),
    ),
    client: CompanionLocClient(
      clients: ({required String count}) => '''Disambungkan (${count})''',
      blocked: ({required String count}) => '''Disekat (${count})''',
      noClient: 'Tiada klien disambungkan',
      noBlocked: 'Tiada klien disekat',
    ),
    qr: 'Imbas kod QR daripada aplikasi pendamping',
  ),
  aboutLoc: AboutLoc(
    title: 'Perihal',
    version: 'Versi',
    author: 'Penulis',
    credits: 'Penghargaan',
  ),
  quitDialogLoc: QuitDialogLoc(
    title: 'Keluar dari GUI scrcpy?',
    killRunning: QuitDialogLocKillRunning(
      label: 'Hentikan yang Sedang Berjalan?',
      info: ({required String count}) =>
          '''${count} scrcpy. scrcpy tanpa tetingkap akan dihentikan juga''',
    ),
    disconnect: QuitDialogLocDisconnect(
      label: 'Putuskan Sambungan ADB Tanpa Wayar?',
      info: ({required String count}) => '''${count} peranti''',
    ),
  ),
  disconnectDialogLoc: DisconnectDialogLoc(
    title: ({required String name}) => '''Putuskan Sambungan ${name}?''',
    hasRunning: DisconnectDialogLocHasRunning(
      label: ({required String name, required String count}) =>
          '''${name} mempunyai ${count} scrcpy yang sedang berjalan''',
      info: 'Memutuskan sambungan akan menghentikan scrcpy',
    ),
  ),
  closeDialogLoc: CloseDialogLoc(
    notAllowed: 'Tidak Dibenarkan!',
    overwrite: 'Timpa?',
    nameExist: 'Nama sudah wujud!',
    save: 'Simpan Konfigurasi?',
    commandPreview: 'Pratonton Perintah:',
    name: 'Nama:',
  ),
  serverDisclaimerLoc: ServerDisclaimerLoc(
    title: 'Maklumat',
    contents:
        '''Amaran Keselamatan: Server pendamping menggunakan sambungan tidak disulitkan.\n\nHanya mulakan server jika anda disambungkan ke rangkaian peribadi yang anda percayai, seperti Wi-Fi rumah anda.''',
  ),
  ipHistoryLoc: IpHistoryLoc(
    title: 'Sejarah',
    empty: 'Tiada Sejarah',
  ),
  buttonLabelLoc: ButtonLabelLoc(
    ok: 'Ok',
    close: 'Tutup',
    cancel: 'Batal',
    stop: 'Hentikan',
    testConfig: 'Uji Konfigurasi',
    update: 'Kemas Kini',
    info: 'Maklumat',
    selectAll: 'Pilih Semua',
    quit: 'Keluar',
    discard: 'Buang',
    overwrite: 'Timpa',
    save: 'Simpan',
    clear: 'Kosongkan',
    filter: 'Tapis konfigurasi',
    delete: 'Padam',
    serverAgree: 'Saya faham, mulakan pelayan',
    reorder: 'Susun semula',
    stopAll: 'Hentikan semua',
  ),
  statusLoc: StatusLoc(
    failed: 'Gagal',
    unauth: 'Tidak Disahkan',
    error: 'Ralat',
    latest: 'Terkini',
    closing: 'Menutup',
    copied: 'Disalin',
    running: 'Sedang berjalan',
    stopped: 'Dihentikan',
  ),
  commonLoc: CommonLoc(
    default$: 'Lalai',
    yes: 'Ya',
    no: 'Tidak',
    bundled: 'Dibundel',
  ),
  colorSchemeNameLoc: ColorSchemeNameLoc(
    blue: 'Biru',
    gray: 'Kelabu',
    green: 'Hijau',
    neutral: 'Neutral',
    orange: 'Jingga',
    red: 'Merah',
    rose: 'Merah Jambu',
    slate: 'Batu Tulis',
    stone: 'Batu',
    violet: 'Ungu',
    yellow: 'Kuning',
    zinc: 'Zink',
  ),
  configFiltersLoc: ConfigFiltersLoc(
    label: ConfigFiltersLocLabel(
      withApp: 'Dengan aplikasi',
      virt: 'Paparan maya',
    ),
  ),
);
final Map<Locale, LocalizationMessages> _languageMap = {
  Locale('en'): en,
  Locale('es'): es,
  Locale('it'): it,
  Locale('ms'): ms,
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

// Supported locales: en, es, it, ms
const List<Locale> supportedLocales = [
  Locale('en'),
  Locale('es'),
  Locale('it'),
  Locale('ms'),
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
