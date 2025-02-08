import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/installed_scrcpy.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/screens/update_screen/components/download_update_widget.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/setup.dart';
import 'package:scrcpygui/utils/update_utils.dart';
import 'package:scrcpygui/widgets/body_container.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/section_button.dart';

import '../../utils/const.dart';

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

      setState(() {
        checkingForUpdate = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final scrcpyVersion = ref.watch(scrcpyVersionProvider);
    final scrcpyDir = ref.watch(execDirProvider);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.pop(context),
      },
      child: Focus(
        autofocus: true,
        child: ScaffoldPage(
          content: Center(
            child: SizedBox(
              width: appWidth,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (checkingForUpdate)
                        const Center(child: CupertinoActivityIndicator()),
                      if (!checkingForUpdate && latest != scrcpyVersion)
                        BodyContainer(
                          headerTitle: 'Update available!',
                          spacing: 4,
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
                      BodyContainer(
                        headerTitle: 'Scrcpy version',
                        spacing: 4,
                        children: [
                          installed.length > 1
                              ? ConfigDropdownOthers(
                                  initialValue: installed.firstWhere(
                                      (i) => i.version == scrcpyVersion),
                                  items: installed
                                      .map((ins) => ComboBoxItem(
                                            value: ins,
                                            child: Text(
                                                ins.version == BUNDLED_VERSION
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
                                    ref
                                        .read(scrcpyVersionProvider.notifier)
                                        .state = value.version;
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
