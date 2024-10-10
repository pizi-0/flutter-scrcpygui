import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/dependencies.dart';

final dependenciesProvider = StateProvider<Dependencies>(
    (ref) => Dependencies(adb: false, scrcpy: false));
