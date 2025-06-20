import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_config_pair.dart';

class AppConfigPairsNotifier extends Notifier<List<AppConfigPair>> {
  @override
  build() {
    return [];
  }

  void setPairs(List<AppConfigPair> pairs) {
    state = pairs;
  }

  void addOrEditPair(AppConfigPair pair) {
    if (!state.contains(pair)) {
      state = [...state, pair];
    }
  }

  void removePair(AppConfigPair pair) {
    state = [...state.where((p) => p != pair)];
  }
}

final appConfigPairProvider =
    NotifierProvider<AppConfigPairsNotifier, List<AppConfigPair>>(
        () => AppConfigPairsNotifier());
