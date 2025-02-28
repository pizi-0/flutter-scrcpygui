// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/screens/3.scrcpy_manager_tab/widgets/download_update_widget.dart';
import 'package:scrcpygui/utils/directory_utils.dart';
import 'package:scrcpygui/utils/setup.dart';
import 'package:scrcpygui/utils/update_utils.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';

class ScrcpyManagerTab extends ConsumerStatefulWidget {
  static const route = '/scrcpy-manager';
  const ScrcpyManagerTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScrcpyManagerTabState();
}

class _ScrcpyManagerTabState extends ConsumerState<ScrcpyManagerTab>
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
                child: InfoLabel(label: el.scrcpyManagerLoc.infoPopup.error)));
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
                child:
                    InfoLabel(label: el.scrcpyManagerLoc.infoPopup.noUpdate)));
      }
    } else {
      displayInfoBar(context,
          builder: (context, close) => Card(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: InfoLabel(label: el.scrcpyManagerLoc.infoPopup.noUpdate)));
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

    return ScaffoldPage.withPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      header: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: PageHeader(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(el.scrcpyManagerLoc.title),
            Tooltip(
              message: el.scrcpyManagerLoc.check,
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
          ConfigCustom(
              title: el.scrcpyManagerLoc.current.label,
              child: const SizedBox()),
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
                                        ? '${ins.version} (${el.commonLoc.bundled})'
                                        : ins.version),
                                  ))
                              .toList(),
                          label: latest == scrcpyVersion
                              ? '${el.scrcpyManagerLoc.current.inUse} (${el.statusLoc.latest})'
                              : el.scrcpyManagerLoc.current.inUse,
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
                          title: el.scrcpyManagerLoc.current.inUse,
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
                    title: el.scrcpyManagerLoc.exec.label,
                    subtitle: el.scrcpyManagerLoc.exec.info,
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
            ConfigCustom(title: el.scrcpyManagerLoc.updater.label),
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
                    title: el.scrcpyManagerLoc.updater.newVersion,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('v$latest'),
                      ],
                    ),
                  ),
                  const Divider(),
                  const DownloadUpdate(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
