import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/screens/main_screen/widgets/small/home_small.dart';
import 'package:scrcpygui/screens/main_screen/widgets/main_screen_navbar.dart';
import 'package:scrcpygui/screens/main_screen/widgets/small/wifi_adb_small.dart';

final mainScreenPage = StateProvider((ref) => 0);

class MainScreenSmall extends ConsumerWidget {
  const MainScreenSmall({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(mainScreenPage);

    return Scaffold(
      bottomNavigationBar: const MainScreenNavbar(),
      body: IndexedStack(
        index: page,
        children: const [
          HomeTabSmall(),
          WifiAdbSmall(),
        ],
      ),
    );
  }
}
