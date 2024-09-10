import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pg_scrcpy/widgets/simple_toast/simple_toast_item.dart';

class ToastNotifier extends Notifier<List<SimpleToastItem>> {
  @override
  List<SimpleToastItem> build() {
    return [];
  }

  addToast(SimpleToastItem item) {
    if (ref.read(toastEnabledProvider)) {
      if (state.length >= 5) {
        var newList = state;

        newList.removeLast();
        newList.insert(0, item);

        state = [...newList];
      } else {
        var newList = state;
        newList.insert(0, item);

        state = [...newList];
      }
    }
  }

  removeToast(SimpleToastItem item) {
    var current = state;
    current.remove(item);
    state = [...current];
  }
}

final toastProvider = NotifierProvider<ToastNotifier, List<SimpleToastItem>>(
    () => ToastNotifier());

final toastEnabledProvider = StateProvider<bool>((ref) => true);
