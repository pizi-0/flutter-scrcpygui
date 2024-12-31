import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/screens/main_screen/small.dart';

class MainScreenNavbar extends ConsumerWidget {
  const MainScreenNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final page = ref.watch(mainScreenPage);

    return BottomNavigationBar(
      selectedItemColor: theme.colorScheme.primary,
      onTap: (page) =>
          ref.read(mainScreenPage.notifier).update((state) => state = page),
      currentIndex: page,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wifi_find_rounded),
          label: 'Wireless ADB',
        ),
      ],
    );
  }
}
