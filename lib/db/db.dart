import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/adb_devices.dart';
import '../models/scrcpy_related/scrcpy_config.dart';
import '../models/settings_model/app_settings.dart';
import '../providers/config_provider.dart';
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

  static Future<void> saveConfigs(
      WidgetRef ref, BuildContext context, List<ScrcpyConfig> conf) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedJson = [];

    for (var c in conf) {
      savedJson.add(c.toJson());
    }

    prefs.setStringList(PKEY_SAVED_CONFIG, savedJson);
  }
}
