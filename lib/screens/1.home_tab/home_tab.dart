import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/screens/1.home_tab/widgets/home/home.dart';

import 'widgets/bottom_bar/home_bottom_bar.dart';

class HomeTab extends ConsumerStatefulWidget {
  static const route = '/home';
  const HomeTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      bottomBar: const HomeBottomBar(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      header: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: PageHeader(
          title: Text(el.homeLoc.title),
        ),
      ),
      content: const Home(),
    );
  }
}
