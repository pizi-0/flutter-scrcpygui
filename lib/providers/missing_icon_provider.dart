import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/missing_icon_model.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';

class MissingIconNotifier extends StateNotifier<List<MissingIcon>> {
  MissingIconNotifier(super.state);

  void addMissing(String serialNo, ScrcpyApp app) {
    final toUpdate = state.firstWhereOrNull(
      (element) => element.serialNo == serialNo,
    );

    if (toUpdate == null) {
      state = [
        ...state,
        MissingIcon(serialNo: serialNo, apps: [app]),
      ];
    } else {
      final toUpdateIndex = state.indexOf(toUpdate);
      final newState = List<MissingIcon>.from(state);
      newState[toUpdateIndex] = toUpdate.addApp(app);
      state = newState;
    }
  }

  void removeMissing(String serialNo, ScrcpyApp app) {
    final toUpdate = state.firstWhereOrNull(
      (element) => element.serialNo == serialNo,
    );

    if (toUpdate != null) {
      final updated = toUpdate.removeApp(app);
      if (updated.apps.isEmpty) {
        state = [
          ...state.where((element) => element.serialNo != serialNo),
        ];
      } else {
        final toUpdateIndex = state.indexOf(toUpdate);
        final newState = List<MissingIcon>.from(state);
        newState[toUpdateIndex] = updated;
        state = newState;
      }
    }
  }

  List<ScrcpyApp> getMissingAppForDevice(String serialNo) {
    final toGet = state.firstWhereOrNull(
      (element) => element.serialNo == serialNo,
    );
    if (toGet != null) {
      return toGet.apps;
    } else {
      return [];
    }
  }
}

final missingIconProvider =
    StateNotifierProvider<MissingIconNotifier, List<MissingIcon>>((ref) {
  return MissingIconNotifier([]);
});

final showMissingIconProvider = StateProvider.autoDispose<bool>((ref) => false);
