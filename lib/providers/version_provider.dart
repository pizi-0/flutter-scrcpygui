// ignore_for_file: constant_identifier_names

import 'package:flutter_riverpod/flutter_riverpod.dart';

const BUNDLED_VERSION = '3.0';

final appVersionProvider = StateProvider((ref) => "");

final scrcpyVersionProvider = StateProvider((ref) => BUNDLED_VERSION);

final execDirProvider = StateProvider((ref) => '');
