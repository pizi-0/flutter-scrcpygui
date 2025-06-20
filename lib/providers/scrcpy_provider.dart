import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_running_instance.dart';
import 'package:scrcpygui/utils/extension.dart';

import '../models/installed_scrcpy.dart';

enum Mode { mirroring, recording }

class ScrcpyInstanceNotifier extends Notifier<List<ScrcpyRunningInstance>> {
  @override
  List<ScrcpyRunningInstance> build() {
    return [];
  }

  void addInstance(ScrcpyRunningInstance inst) {
    if (!state.contains(inst)) {
      state = [...state, inst];
    }
  }

  void removeInstance(ScrcpyRunningInstance inst) {
    if (state.contains(inst)) {
      state = state.where((i) => i != inst).toList();
    }
  }

  void removeAll() {
    state = [];
  }
}

final scrcpyInstanceProvider =
    NotifierProvider<ScrcpyInstanceNotifier, List<ScrcpyRunningInstance>>(
        () => ScrcpyInstanceNotifier());

final appPidProvider = StateProvider<String>((ref) => '');

final customNameProvider = StateProvider<String>((ref) => '');

class InstalledScrcpyNotifier extends Notifier<List<InstalledScrcpy>> {
  @override
  List<InstalledScrcpy> build() {
    return [];
  }

  void setInstalled(List<InstalledScrcpy> installed) {
    state = installed;
  }

  void addVersion(InstalledScrcpy version) {
    var newstate = [...state];
    newstate.addIfNotExist(version);

    state = newstate;
  }
}

final installedScrcpyProvider =
    NotifierProvider<InstalledScrcpyNotifier, List<InstalledScrcpy>>(
        () => InstalledScrcpyNotifier());
