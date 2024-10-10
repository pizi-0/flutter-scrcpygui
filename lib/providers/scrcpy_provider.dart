import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_running_instance.dart';

enum Mode { mirroring, recording }

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
