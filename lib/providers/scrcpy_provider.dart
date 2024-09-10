import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pg_scrcpy/models/adb_devices.dart';
import 'package:pg_scrcpy/models/scrcpy_related/scrcpy_config.dart';
import 'package:pg_scrcpy/models/scrcpy_related/scrcpy_running_instance.dart';
import 'package:pg_scrcpy/utils/scrcpy_utils.dart';

import '../utils/const.dart';

enum Mode { mirroring, recording }

class ScrcpyProvider extends ChangeNotifier {
  String? appPid;
  bool adbInstalled = false;
  bool scrcpyInstalled = false;

  AdbDevices? device;
  List<ScrcpyConfig> customConfig = [];
  List<AdbDevices> adbDevices = [];
  List<ScrcpyRunningInstance> runningInstance = [];
  List<String> polledPIDs = [];

  ScrcpyConfig selectedConfig = defaultMirror;
  ScrcpyConfig? toEdit;
  String customInstanceName = '';

  Brightness theme = Brightness.dark;

  Color color = const Color(0xff006D66);

  modifyRunningInstance(ScrcpyRunningInstance inst, {bool add = true}) {
    if (add) {
      runningInstance.add(inst);
    } else {
      runningInstance.remove(inst);
    }
    notifyListeners();
  }

  setColor(Color col) {
    color = col;
    notifyListeners();
  }

  onDeviceSelect(AdbDevices? dev) {
    device = dev;
    notifyListeners();
  }

  setCustomConfig(List<ScrcpyConfig> confs) {
    customConfig = confs;
    notifyListeners();
  }

  deleteCustomConfig(ScrcpyConfig config) {
    customConfig.remove(config);
    ScrcpyUtils.saveConfigs(customConfig);
    notifyListeners();
  }

  setAdbDevices(List<AdbDevices> devs) {
    adbDevices = devs;
    notifyListeners();
  }

  setSelectedConfig(ScrcpyConfig config) {
    selectedConfig = config;
    notifyListeners();
  }

  setToEdit(ScrcpyConfig config) {
    toEdit = config;
    notifyListeners();
  }

  modifyCurrentConfig(ScrcpyConfig config) {
    selectedConfig = config;
    notifyListeners();
  }

  setAppPid(String pid) {
    appPid = pid;
    notifyListeners();
  }

  dependencies({required bool adb, required bool scrcpy}) {
    adbInstalled = adb;
    scrcpyInstalled = scrcpy;
    notifyListeners();
  }

  noti() {
    notifyListeners();
  }
}

class ScrcpyInstanceNotifier extends Notifier<List<ScrcpyRunningInstance>> {
  @override
  List<ScrcpyRunningInstance> build() {
    return [];
  }

  addInstance(ScrcpyRunningInstance inst) {
    if (!state.contains(inst)) {
      state = [...state, inst];
    }
  }

  removeInstance(ScrcpyRunningInstance inst) {
    if (state.contains(inst)) {
      state = state.where((i) => i != inst).toList();
    }
  }

  removeAll() {
    state = [];
  }
}

final scrcpyInstanceProvider =
    NotifierProvider<ScrcpyInstanceNotifier, List<ScrcpyRunningInstance>>(
        () => ScrcpyInstanceNotifier());

final appPidProvider = StateProvider<String>((ref) => '');

final customNameProvider = StateProvider<String>((ref) => '');
