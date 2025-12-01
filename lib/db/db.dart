import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/app_config_pair.dart';
import 'package:scrcpygui/models/automation.dart';
import 'package:scrcpygui/models/device_info_model.dart';
import 'package:scrcpygui/models/settings_model/app_grid_settings.dart';
import 'package:scrcpygui/models/settings_model/companion_server_settings.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/adb_devices.dart';
import '../models/scrcpy_related/scrcpy_config.dart';
import '../models/settings_model/app_settings.dart';
import '../providers/config_provider.dart';
import '../providers/version_provider.dart';
import '../utils/const.dart';
import '../utils/prefs_key.dart';

class Db {
  /*
  App Settings DB
  */

  static Future<void> saveAppSettings(AppSettings appSettings) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(PKEY_APP_SETTINGS, appSettings.toJson());
  }

  static Future<AppSettings> getAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsons = prefs.getString(PKEY_APP_SETTINGS);

    if (jsons == null) {
      return defaultSettings;
    } else {
      return AppSettings.fromJson(jsons);
    }
  }

  static Future<void> clearSharedPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove(key);
  }

  static Future<void> saveWinSize(Size size) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(PKEY_LAST_WIN_SIZE,
        jsonEncode({'width': size.width, 'height': size.height}));
  }

  static Future<Size> getWinSize() async {
    final prefs = await SharedPreferences.getInstance();

    final res = prefs.getString(PKEY_LAST_WIN_SIZE);

    if (res == null) {
      return Size(500, 600);
    } else {
      return Size(jsonDecode(res)['width'], jsonDecode(res)['height']);
    }
  }

  /*
  Device DB
  */

  static Future<void> saveAdbDevice(List<AdbDevices> dev) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        PKEY_SAVED_DEVICES, dev.map((e) => e.toJson()).toList());
    // prefs.remove(PKEY_SAVED_DEVICES);
  }

  static Future<List<AdbDevices>> getSavedAdbDevice() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove(PKEY_SAVED_DEVICES);
    final jsons = prefs.getStringList(PKEY_SAVED_DEVICES) ?? [];

    return jsons.map((e) => AdbDevices.fromJson(e)).toList();
  }

  static Future<void> saveWirelessHistory(List<String> devs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        PKEY_WIRELESS_DEVICE_HX, devs.map((d) => d).toList());
  }

  static Future<List<String>> getWirelessHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyStr =
        prefs.getStringList(PKEY_WIRELESS_DEVICE_HX) ?? [];

    return historyStr;
  }

  /*
  Device Info DB
  */

  static Future<void> saveDeviceInfos(List<DeviceInfo> infos) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        PKEY_DEVICE_INFOS, infos.map((e) => e.toJson()).toList());
    // prefs.remove(PKEY_SAVED_DEVICES);
  }

  static Future<List<DeviceInfo>> getDeviceInfos() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove(PKEY_SAVED_DEVICES);
    final jsons = prefs.getStringList(PKEY_DEVICE_INFOS) ?? [];

    return jsons.map((e) => DeviceInfo.fromJson(e)).toList();
  }

  /*
  Configs DB
  */

  static Future<List<ScrcpyConfig>> getSavedConfig() async {
    List<ScrcpyConfig> saved = [];
    final prefs = await SharedPreferences.getInstance();

    final res = prefs.getStringList(PKEY_SAVED_CONFIG) ?? [];

    for (var r in res) {
      saved.add(ScrcpyConfig.fromJson(r));
    }

    return saved;
  }

  static Future<void> saveLastUsedConfig(ScrcpyConfig config) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(PKEY_LASTUSED_CONFIG, config.id);
  }

  static Future<ScrcpyConfig?> getLastUsedConfig(WidgetRef ref) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allConfig = ref.read(configsProvider);

      final res = prefs.getString(PKEY_LASTUSED_CONFIG) ?? defaultMirror.id;

      final lastUsed = allConfig.firstWhere((c) => c.id == res);

      return lastUsed;
    } on StateError catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<void> saveConfigs(List<ScrcpyConfig> conf) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedJson = [];

    for (var c in conf) {
      savedJson.add(c.toJson());
    }

    prefs.setStringList(PKEY_SAVED_CONFIG, savedJson);
  }

  static Future<void> saveHiddenConfigs(List<String> hidden) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(PKEY_HIDDEN_CONFIGS, hidden);
  }

  static Future<List<String>> getHiddenConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(PKEY_HIDDEN_CONFIGS) ?? [];
  }

  /*
  Device control dialog DB
  */

  static Future<List<AppConfigPair>> getAppConfigPairs() async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(PKEY_APP_CONFIG_PAIR) ?? [];

    return list.map((e) => AppConfigPair.fromJson(e)).toList();
  }

  static Future<void> saveAppConfigPairs(List<AppConfigPair> pairList) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList(
        PKEY_APP_CONFIG_PAIR, pairList.map((pair) => pair.toJson()).toList());
  }

  /*
  Server API Key DB
  */

  static Future<CompanionServerSettings?> getCompanionServerSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final res = prefs.getString(PKEY_COMPANION_SERVER_SETTINGS);

    if (res == null) {
      return null;
    } else {
      return CompanionServerSettings.fromJson(res);
    }
  }

  static Future<void> saveCompanionServerSettings(
      CompanionServerSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(PKEY_COMPANION_SERVER_SETTINGS, settings.toJson());
  }

  /*
  Automation DB
  */

  static Future<List<ConnectAutomation>> getAutoConnect() async {
    final prefs = await SharedPreferences.getInstance();

    return (prefs.getStringList(PKEY_AUTO_CONNECT) ?? [])
        .map((e) => ConnectAutomation.fromJson(e))
        .toList();
  }

  static Future<List<ConfigAutomation>> getAutoLaunch() async {
    final prefs = await SharedPreferences.getInstance();

    return (prefs.getStringList(PKEY_AUTO_LAUNCH) ?? [])
        .map((e) => ConfigAutomation.fromJson(e))
        .toList();
  }

  static Future<void> saveAutoConnect(List<ConnectAutomation> list) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList(
        PKEY_AUTO_CONNECT, list.map((e) => e.toJson()).toList());
  }

  static Future<void> saveAutoLaunch(List<ConfigAutomation> list) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList(PKEY_AUTO_LAUNCH, list.map((e) => e.toJson()).toList());
  }

  /*
  App grid settings DB
  */

  static Future<void> saveAppGridSettings(AppGridSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(PKEY_APPGRID_SETTINGS, settings.toJson());
  }

  static Future<AppGridSettings> getAppGridSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final res = prefs.getString(PKEY_APPGRID_SETTINGS);

    if (res == null) {
      return AppGridSettings(gridExtent: 80, hideName: false);
    } else {
      return AppGridSettings.fromJson(res);
    }
  }

  static Future<String> saveEifaVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(PKEY_EIFA_VERSION, version);
    return version;
  }

  static Future<String> getEifaVersion() async {
    final prefs = await SharedPreferences.getInstance();

    final res = prefs.getString(PKEY_EIFA_VERSION);

    if (res == null) {
      return EIFA_VERSION;
    } else {
      return res;
    }
  }

  static Future<void> hideIconExtractorDisclaimerDialog() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool(PKEY_HIDE_ICON_EXTRACTOR_DISCLAIMER, true);
  }
}
