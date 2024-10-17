import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/const.dart';

final settingsProvider = StateProvider((ref) => defaultSettings);

final advancedThemingVisible = StateProvider<bool>((ref) => false);
