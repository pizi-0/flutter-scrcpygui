import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/installed_scrcpy.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/screens/update_screen/components/download_update_widget.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/setup.dart';
import 'package:scrcpygui/utils/update_utils.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/section_button.dart';

class UpdateScreen extends ConsumerStatefulWidget {
  const UpdateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends ConsumerState<UpdateScreen> {
  String latest = BUNDLED_VERSION;
  bool checkingForUpdate = false;
  List<InstalledScrcpy> installed = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((a) async {
      installed = await UpdateUtils.listInstalledScrcpy();
      setState(() {
        checkingForUpdate = true;
      });

      final res = await UpdateUtils.checkForScrcpyUpdate(ref);

      if (res != null) {
        latest = res;
      }

      if (mounted) {
        setState(() {
          checkingForUpdate = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scrcpyVersion = ref.watch(scrcpyVersionProvider);
    final scrcpyDir = ref.watch(execDirProvider);
    final theme = FluentTheme.of(context);

    return ScaffoldPage.withPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      header: PageHeader(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Scrcpy Manager'),
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: checkingForUpdate
                  ? SizedBox.square(
                      dimension: theme.iconTheme.size! - 4,
                      child: const ProgressRing())
                  : const Icon(FluentIcons.update_restore),
            ),
            onPressed: () {},
          )
        ],
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          const Text('Current'),
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
                  ConfigCustom(
                    childBackgroundColor: Colors.transparent,
                    title: 'Open executable location',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SectionButton(
                          icondata: FluentIcons.folder_horizontal,
                          tooltipmessage: scrcpyDir,
                          ontap: () async {
                            await AppUtils.openFolder(
                                scrcpyDir.split(scrcpyVersion).first);
                            // await ScrcpyUtils.checkForScrcpyUpdate();
                          },
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
    );
  }
}
