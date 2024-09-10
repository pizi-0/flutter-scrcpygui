import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pg_scrcpy/models/dependencies.dart';

final dependenciesProvider = StateProvider<Dependencies>(
    (ref) => Dependencies(adb: false, scrcpy: false));
