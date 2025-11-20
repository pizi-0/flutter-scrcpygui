import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/icon_extractor_progress.dart';
import '../models/missing_icon_model.dart';
import '../models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';

final apkExtractProgressProvider = StateProvider<String>((ref) => '');

final shouldExtractIconProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final iconsToExtractProvider =
    NotifierProvider<IconsToExtractorNotifier, List<MissingIcon>>(() {
  return IconsToExtractorNotifier();
});

class IconsToExtractorNotifier extends Notifier<List<MissingIcon>> {
  @override
  build() {
    return [];
  }

  void addMissing(MissingIcon missing) {
    final currentMissing =
        state.firstWhereOrNull((st) => st.serialNo == missing.serialNo);

    if (currentMissing == null) {
      state = [
        ...state,
        missing,
      ];
    } else {
      if (listEquals(currentMissing.apps, missing.apps)) {
        return;
      } else {
        final differenceApps = missing.apps
            .where((app) => !currentMissing.apps.contains(app))
            .toList();

        for (final app in differenceApps) {
          currentMissing.addApp(app);
        }

        final toUpdateIndex = state.indexWhere(
          (element) => element.serialNo == missing.serialNo,
        );
        final newState = List<MissingIcon>.from(state);
        newState[toUpdateIndex] = currentMissing;
        state = newState;
      }
    }
  }

  void removeApp(ScrcpyApp app) {
    List<String> shouldRemove = [];
    for (final missing in state) {
      if (missing.apps.contains(app)) {
        final updated = missing.removeApp(app);
        if (updated.apps.isEmpty) {
          shouldRemove.add(missing.serialNo);
        } else {
          final toUpdateIndex = state.indexOf(missing);
          final newState = List<MissingIcon>.from(state);
          newState[toUpdateIndex] = updated;
          state = newState;
        }
      }
    }

    state = [
      ...state.where((element) => !shouldRemove.contains(element.serialNo)),
    ];
  }
}

final iconExtractorProgressProvider = AutoDisposeNotifierProvider<
    IconExtractorProgressNotifier, IconExtractorProgress>(() {
  return IconExtractorProgressNotifier();
});

class IconExtractorProgressNotifier
    extends AutoDisposeNotifier<IconExtractorProgress> {
  @override
  build() {
    return IconExtractorProgress(
      remaining: 0,
      currentDevice: '',
      currentApp: '',
      failed: [],
      successful: [],
    );
  }

  void updateCurrent(String device, String app) {
    state = state.copyWith(
      currentDevice: device,
      currentApp: app,
    );
  }

  void updateSuccessful(ScrcpyApp app) {
    final updatedSuccessful = [...state.successful, app];
    state = state.copyWith(
      successful: updatedSuccessful,
    );
  }

  void updateFailed(ScrcpyApp app, String reason) {
    final updatedFailed = [...state.failed, (app, reason)];

    state = state.copyWith(
      failed: updatedFailed,
    );
  }

  void resetProgress() {
    state = state.copyWith(
      currentApp: '',
      currentDevice: '',
      failed: [],
      successful: [],
    );
  }
}
