import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';

class KeyEvent {
  List<String> power() => ['keyevent', '26'];
}

extension AdbCommandExtension on AdbDevices {
  static sendKeyEvent(WidgetRef ref, AdbDevices dev) async {
    print(dev.id);
  }
}
