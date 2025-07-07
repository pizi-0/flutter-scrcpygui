// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/screens/3.scrcpy_manager_tab/widgets/download_update_widget.dart';
import 'package:scrcpygui/utils/directory_utils.dart';
import 'package:scrcpygui/utils/setup.dart';
import 'package:scrcpygui/utils/update_utils.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_column.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../models/installed_scrcpy.dart';
import '../../providers/settings_provider.dart';

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
      installed.sort(
        (a, b) => a.version.compareTo(b.version),
      );
      ref.read(installedScrcpyProvider.notifier).setInstalled(installed);

      try {
        await _checkForUpdate();
      } on Exception catch (e) {
        checkingForUpdate = false;
        setState(() {});

        debugPrint(e.toString());

        showToast(
          showDuration: 1.5.seconds,
          context: context,
          location: ToastLocation.bottomCenter,
          builder: (context, overlay) => SurfaceCard(
              child: Basic(
            title: Text(el.scrcpyManagerLoc.infoPopup.error),
            trailing: const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
            ),
          )),
        );
      }
    });
  }

  Future<void> _checkForUpdate() async {
    checkingForUpdate = true;
    setState(() {});

    final res = await UpdateUtils.checkForScrcpyUpdate(ref);

    if (res != null) {
      latest = res;
      if (res == ref.read(scrcpyVersionProvider)) {
        showToast(
          showDuration: 1.5.seconds,
          context: context,
          location: ToastLocation.bottomCenter,
          builder: (context, overlay) => SurfaceCard(
            child: Basic(
              title: Text(el.scrcpyManagerLoc.infoPopup.noUpdate),
              trailing: const Icon(
                Icons.check_circle_outline,
                color: Colors.lime,
              ),
            ),
          ),
        );
      }
    } else {
      showToast(
        showDuration: 1.5.seconds,
        context: context,
        location: ToastLocation.bottomCenter,
        builder: (context, overlay) => SurfaceCard(
            child: Basic(
          title: Text(el.scrcpyManagerLoc.infoPopup.error),
          trailing: const Icon(
            Icons.error_outline_rounded,
            color: Colors.red,
          ),
        )),
      );
    }

    if (mounted) {
      checkingForUpdate = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    final scrcpyVersion = ref.watch(scrcpyVersionProvider);
    final scrcpyDir = ref.watch(execDirProvider);
    final installed = ref.watch(installedScrcpyProvider);

    return PgScaffoldCustom(
      appBarTrailing: [
        IconButton.ghost(
          icon: Padding(
            padding: const EdgeInsets.all(3.0),
            child: checkingForUpdate
                ? const CircularProgressIndicator(size: 20)
                : const Icon(Icons.refresh),
          ),
          onPressed: () async {
            try {
              await _checkForUpdate();
            } on Exception catch (e) {
              debugPrint(e.toString());
            }
          },
        ),
      ],
      title: Text(el.scrcpyManagerLoc.title).bold().underline,
      scaffoldBody: ResponsiveBuilder(
        builder: (context, sizeInfo) {
          return AnimatedSwitcher(
            duration: 200.milliseconds,
            child: sizeInfo.isMobile || sizeInfo.isTablet
                ? ManagerTabSmall(
                    latest: latest,
                    installed: installed,
                    scrcpyVersion: scrcpyVersion,
                    scrcpyDir: scrcpyDir,
                    checkingForUpdate: checkingForUpdate,
                  )
                : ManagerTabBig(
                    latest: latest,
                    installed: installed,
                    scrcpyVersion: scrcpyVersion,
                    scrcpyDir: scrcpyDir,
                    checkingForUpdate: checkingForUpdate,
                  ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ManagerTabSmall extends ConsumerWidget {
  final String latest;
  final List<InstalledScrcpy> installed;
  final String scrcpyVersion;
  final String scrcpyDir;
  final bool checkingForUpdate;

  const ManagerTabSmall(
      {super.key,
      required this.latest,
      required this.installed,
      required this.scrcpyVersion,
      required this.scrcpyDir,
      required this.checkingForUpdate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        PgSectionCard(
          label: el.scrcpyManagerLoc.current.label,
          children: [
            installed.length > 1
                ? ConfigCustom(
                    dimTitle: false,
                    title: latest == scrcpyVersion
                        ? '${el.scrcpyManagerLoc.current.inUse} (${el.statusLoc.latest})'
                        : el.scrcpyManagerLoc.current.inUse,
                    child: Select(
                      filled: true,
                      value: installed
                          .firstWhere((ins) => ins.version == scrcpyVersion),
                      onChanged: (value) async {
                        await SetupUtils.saveCurrentScrcpyVersion(
                            value!.version);
                        ref.read(execDirProvider.notifier).state = value.path;
                        ref.read(scrcpyVersionProvider.notifier).state =
                            value.version;
                      },
                      popup: SelectPopup(
                        items: SelectItemList(
                            children: installed
                                .map((ins) => SelectItemButton(
                                      value: ins,
                                      child: Text(ins.version == BUNDLED_VERSION
                                          ? '${ins.version} (${el.commonLoc.bundled})'
                                          : ins.version),
                                    ))
                                .toList()),
                      ).call,
                      itemBuilder: (context, value) => Text(value.version),
                    ),
                  )
                : ConfigCustom(
                    dimTitle: false,
                    padRight: 8,
                    childBackgroundColor: Colors.transparent,
                    title: el.scrcpyManagerLoc.current.inUse,
                    childExpand: false,
                    child: Text('v$scrcpyVersion').small(),
                  ),
            const Divider(),
            ConfigCustom(
              dimTitle: false,
              childBackgroundColor: Colors.transparent,
              title: el.scrcpyManagerLoc.exec.label,
              subtitle: el.scrcpyManagerLoc.exec.info,
              showinfo: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    variance: ButtonVariance.ghost,
                    icon: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(Icons.folder),
                    ),
                    onPressed: () async {
                      await DirectoryUtils.openFolder(
                          scrcpyDir.split(scrcpyVersion).first);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!checkingForUpdate &&
            latest != scrcpyVersion &&
            installed.where((i) => i.version == latest).isEmpty)
          PgSectionCard(
            label: el.scrcpyManagerLoc.updater.label,
            children: [
              ConfigCustom(
                dimTitle: false,
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
      ],
    );
  }
}

class ManagerTabBig extends ConsumerWidget {
  final String latest;
  final List<InstalledScrcpy> installed;
  final String scrcpyVersion;
  final String scrcpyDir;
  final bool checkingForUpdate;

  const ManagerTabBig(
      {super.key,
      required this.latest,
      required this.installed,
      required this.scrcpyVersion,
      required this.scrcpyDir,
      required this.checkingForUpdate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool hasLatest = !checkingForUpdate &&
        latest != scrcpyVersion &&
        installed.where((i) => i.version == latest).isEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        LeftColumn(
          alignment: hasLatest ? Alignment.topRight : Alignment.topCenter,
          child: PgSectionCard(
            label: el.scrcpyManagerLoc.current.label,
            children: [
              installed.length > 1
                  ? ConfigCustom(
                      dimTitle: false,
                      title: latest == scrcpyVersion
                          ? '${el.scrcpyManagerLoc.current.inUse} (${el.statusLoc.latest})'
                          : el.scrcpyManagerLoc.current.inUse,
                      child: Select(
                        filled: true,
                        value: installed
                            .firstWhere((ins) => ins.version == scrcpyVersion),
                        onChanged: (value) async {
                          await SetupUtils.saveCurrentScrcpyVersion(
                              value!.version);
                          ref.read(execDirProvider.notifier).state = value.path;
                          ref.read(scrcpyVersionProvider.notifier).state =
                              value.version;
                        },
                        popup: SelectPopup(
                          items: SelectItemList(
                              children: installed
                                  .map((ins) => SelectItemButton(
                                        value: ins,
                                        child: Text(ins.version ==
                                                BUNDLED_VERSION
                                            ? '${ins.version} (${el.commonLoc.bundled})'
                                            : ins.version),
                                      ))
                                  .toList()),
                        ).call,
                        itemBuilder: (context, value) => Text(value.version),
                      ),
                    )
                  : ConfigCustom(
                      dimTitle: false,
                      padRight: 8,
                      childBackgroundColor: Colors.transparent,
                      title: el.scrcpyManagerLoc.current.inUse,
                      childExpand: false,
                      child: Text('v$scrcpyVersion').small(),
                    ),
              const Divider(),
              ConfigCustom(
                dimTitle: false,
                childBackgroundColor: Colors.transparent,
                title: el.scrcpyManagerLoc.exec.label,
                subtitle: el.scrcpyManagerLoc.exec.info,
                showinfo: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      variance: ButtonVariance.ghost,
                      icon: const Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Icon(Icons.folder),
                      ),
                      onPressed: () async {
                        await DirectoryUtils.openFolder(
                            scrcpyDir.split(scrcpyVersion).first);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (hasLatest)
          RightColumn(
            child: PgSectionCard(
              label: el.scrcpyManagerLoc.updater.label,
              children: [
                ConfigCustom(
                  dimTitle: false,
                  padRight: 6,
                  childBackgroundColor: Colors.transparent,
                  title: el.scrcpyManagerLoc.updater.newVersion,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('v$latest').textSmall,
                    ],
                  ),
                ),
                const Divider(),
                const DownloadUpdate(),
              ],
            ),
          ),
      ],
    );
  }
}
