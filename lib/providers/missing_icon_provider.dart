import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';

class MissingIconNotifier extends StateNotifier<List<ScrcpyApp>> {
  MissingIconNotifier(super.state);

  void addApp(ScrcpyApp app) {
    if (!state.contains(app)) {
      state = [...state, app];
    }
  }

  void removeApp(ScrcpyApp app) {
    state = [...state.where((a) => a.packageName != app.packageName)];
  }
}

final missingIconProvider =
    StateNotifierProvider<MissingIconNotifier, List<ScrcpyApp>>((ref) {
  return MissingIconNotifier([]);
});
