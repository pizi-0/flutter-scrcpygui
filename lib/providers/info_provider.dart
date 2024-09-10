import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pg_scrcpy/models/scrcpy_related/scrcpy_info.dart';

class InfoNotifier extends Notifier<List<ScrcpyInfo>> {
  @override
  build() {
    return [];
  }

  addInfo(ScrcpyInfo info) {
    if (state.contains(info)) {
      state = [
        for (var i in state)
          if (i != info) i
      ];
    } else {
      state = [...state, info];
    }
  }

  removeInfo(ScrcpyInfo info) {
    state = [
      for (var i in state)
        if (i != info) i
    ];
  }
}

final infoProvider =
    NotifierProvider<InfoNotifier, List<ScrcpyInfo>>(() => InfoNotifier());
