import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/screens/update_screen/components/download_update_widget.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';
import 'package:scrcpygui/widgets/body_container.dart';
import 'package:scrcpygui/widgets/section_button.dart';

import '../../providers/settings_provider.dart';
import '../../utils/const.dart';

class UpdateScreen extends ConsumerStatefulWidget {
  const UpdateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends ConsumerState<UpdateScreen> {
  String latest = BUNDLED_VERSION;
  bool checkingForUpdate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) async {
      setState(() {
        checkingForUpdate = true;
      });

      final res = await ScrcpyUtils.checkForScrcpyUpdate();

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
    final colorScheme = Theme.of(context).colorScheme;
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final scrcpyVersion = ref.watch(scrcpyVersionProvider);
    final scrcpyDir = ref.watch(execDirProvider);

    final buttonStyle = ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.widgetRadius))));

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.pop(context),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: colorScheme.surface,
            scrolledUnderElevation: 0,
            leading: IconButton(
              style: buttonStyle,
              tooltip: 'ESC',
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: colorScheme.inverseSurface,
              ),
            ),
            title: Text(
              'Update',
              style: TextStyle(color: colorScheme.inverseSurface),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Center(
            child: SizedBox(
              width: appWidth,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (latest == scrcpyVersion)
                        BodyContainer(
                          headerTitle: 'Update available!',
                          children: [
                            BodyContainerItem(
                              title: 'New version',
                              trailing: Text('v $latest'),
                            ),
                            const DownloadUpdate(),
                          ],
                        ),
                      BodyContainer(
                        headerTitle: 'Scrcpy version',
                        children: [
                          BodyContainerItem(
                            title: 'Current version',
                            trailing: Text('v $scrcpyVersion'),
                          ),
                          BodyContainerItem(
                            title: 'Open executable location',
                            trailingPadding: false,
                            trailing: SectionButton(
                              icondata: Icons.folder_rounded,
                              tooltipmessage: scrcpyDir,
                              ontap: () async {
                                await ScrcpyUtils.openFolder(
                                    scrcpyDir.split(scrcpyVersion).first);
                                // await ScrcpyUtils.checkForScrcpyUpdate();
                              },
                            ),
                          ),
                        ],
                      )
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
