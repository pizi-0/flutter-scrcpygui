// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keymap/keymap.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/screens/3.scrcpy_manager_tab/widgets/download_update_widget.dart';
import 'package:scrcpygui/utils/directory_utils.dart';
import 'package:scrcpygui/utils/setup.dart';
import 'package:scrcpygui/utils/update_utils.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';

class ScrcpyManager extends ConsumerStatefulWidget {
  const ScrcpyManager({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScrcpyManagerState();
}

class _ScrcpyManagerState extends ConsumerState<ScrcpyManager>
    with AutomaticKeepAliveClientMixin {
  String latest = BUNDLED_VERSION;
  bool checkingForUpdate = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((a) async {
      final installed = await UpdateUtils.listInstalledScrcpy();
      ref.read(installedScrcpyProvider.notifier).setInstalled(installed);

      try {
        await _checkForUpdate();
      } on Exception catch (e) {
        debugPrint(e.toString());
        displayInfoBar(context,
            builder: (context, close) => Card(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: InfoLabel(label: 'Error checking for update')));
      }
    });
  }

  _checkForUpdate() async {
    checkingForUpdate = true;
    setState(() {});

    final res = await UpdateUtils.checkForScrcpyUpdate(ref);

    if (res != null) {
      latest = res;
      if (res == ref.read(scrcpyVersionProvider)) {
        displayInfoBar(context,
            builder: (context, close) => Card(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: InfoLabel(label: 'No update available')));
      }
    } else {
      displayInfoBar(context,
          builder: (context, close) => Card(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: InfoLabel(label: 'No update available')));
    }

    if (mounted) {
      checkingForUpdate = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final scrcpyVersion = ref.watch(scrcpyVersionProvider);
    final scrcpyDir = ref.watch(execDirProvider);
    final theme = FluentTheme.of(context);
    final installed = ref.watch(installedScrcpyProvider);

    return KeyboardWidget(
      bindings: [
        KeyAction(LogicalKeyboardKey.f5, 'check for update ', _checkForUpdate)
      ],
      child: ScaffoldPage.withPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        header: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: PageHeader(
              title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Scrcpy Manager'),
              Tooltip(
                message: '(F5) Check for update',
                child: IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: checkingForUpdate
                        ? SizedBox.square(
                            dimension: theme.iconTheme.size! - 4,
                            child: const ProgressRing())
                        : const Icon(FluentIcons.update_restore),
                  ),
                  onPressed: () async {
                    try {
                      await _checkForUpdate();
                    } on Exception catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                ),
              )
            ],
          )),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ConfigCustom(title: 'Current', child: SizedBox()),
            Card(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    installed.length > 1
                        ? ConfigDropdownOthers(
                            initialValue: installed
                                .firstWhere((i) => i.version == scrcpyVersion),
                            items: installed
                                .map((ins) => ComboBoxItem(
                                      value: ins,
                                      child: Text(ins.version == BUNDLED_VERSION
                                          ? '${ins.version} (Bundled)'
                                          : ins.version),
                                    ))
                                .toList(),
                            label: latest == scrcpyVersion
                                ? 'In-use (latest)'
                                : 'In-use',
                            onSelected: (value) async {
                              await SetupUtils.saveCurrentScrcpyVersion(
                                  value.version);
                              ref.read(execDirProvider.notifier).state =
                                  value.path;
                              ref.read(scrcpyVersionProvider.notifier).state =
                                  value.version;
                            },
                          )
                        : ConfigCustom(
                            padRight: 8,
                            childBackgroundColor: Colors.transparent,
                            title: 'In-use',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('v$scrcpyVersion'),
                              ],
                            ),
                          ),
                    const Divider(),
                    ConfigCustom(
                      childBackgroundColor: Colors.transparent,
                      title: 'Open executable location',
                      subtitle:
                          'avoid from manually modifying content of executable folder',
                      showinfo: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Tooltip(
                            message: scrcpyDir.split(scrcpyVersion).first,
                            child: Button(
                              child: const Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Icon(FluentIcons.folder_horizontal),
                              ),
                              onPressed: () async {
                                await DirectoryUtils.openFolder(
                                    scrcpyDir.split(scrcpyVersion).first);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            if (!checkingForUpdate &&
                latest != scrcpyVersion &&
                installed.where((i) => i.version == latest).isEmpty)
              const SizedBox(height: 10),
            if (!checkingForUpdate &&
                latest != scrcpyVersion &&
                installed.where((i) => i.version == latest).isEmpty)
              const Text('New'),
            if (!checkingForUpdate &&
                latest != scrcpyVersion &&
                installed.where((i) => i.version == latest).isEmpty)
              Card(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ConfigCustom(
                      padRight: 6,
                      childBackgroundColor: Colors.transparent,
                      title: 'New version',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('v$latest'),
                        ],
                      ),
                    ),
                    const DownloadUpdate(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
