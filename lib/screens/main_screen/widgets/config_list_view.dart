// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/screens/config_screen/config_screen.dart';
import 'package:scrcpygui/screens/main_screen/widgets/small/home_small.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/decorations.dart';
import 'package:scrcpygui/widgets/section_button.dart';
import 'package:uuid/uuid.dart';

import '../../../providers/config_provider.dart';
import '../../../providers/settings_provider.dart';
import 'config_listtile.dart';

class ConfigListView extends ConsumerStatefulWidget {
  final Animation animation;
  final AnimationController animationController;

  const ConfigListView({
    super.key,
    required this.animation,
    required this.animationController,
  });

  @override
  ConsumerState<ConfigListView> createState() => _ConfigListViewState();
}

class _ConfigListViewState extends ConsumerState<ConfigListView> {
  late ScrollController _scrollController;
  bool loading = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allConfigs = ref.watch(configsProvider);
    final theme = Theme.of(context);
    final looks = ref.watch(settingsProvider).looks;

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Configs (${allConfigs.length})')
                  .textStyle(theme.textTheme.bodyLarge),
            ),
            SectionButton(
              icondata: Icons.add_box_rounded,
              ontap: () async {
                final selectedDevice = ref.read(selectedDeviceProvider);
                final savedDevices = ref.read(savedAdbDevicesProvider);
                final allDevice = ref.read(adbProvider);

                if (selectedDevice == null) {
                  if (allDevice.isNotEmpty && allDevice.length == 1) {
                    ref.read(selectedDeviceProvider.notifier).state =
                        savedDevices.firstWhere(
                      (d) => d.id == allDevice.first.id,
                      orElse: () => allDevice.first,
                    );
                  } else {
                    ref.read(homeDeviceAttention.notifier).state = true;
                    await Future.delayed(2.seconds);
                    if (ref.read(homeDeviceAttention)) {
                      ref.read(homeDeviceAttention.notifier).state = false;
                    }
                  }
                } else {
                  ref.read(configScreenConfig.notifier).state =
                      newConfig.copyWith(id: const Uuid().v4());
                  await AppUtils.push(context, const ConfigScreen());
                  await Future.delayed(1.seconds);
                  ref.read(configScreenConfig.notifier).state = null;
                }
              },
            ),
          ],
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (widget.animation.value < 750) {
                widget.animationController.forward();
              }
            },
            child: Listener(
              onPointerSignal: (event) {
                if (widget.animation.value < 750) {
                  widget.animationController.forward();
                }
              },
              child: MouseRegion(
                onExit: (event) {
                  _scrollController.jumpTo(0);
                  widget.animationController.reverse();
                },
                child: Container(
                  decoration:
                      Decorations.secondaryContainer(theme.colorScheme, looks),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        scrollbars: widget.animationController.isCompleted,
                      ),
                      child: ListView.separated(
                        physics: widget.animation.value < 750
                            ? const NeverScrollableScrollPhysics()
                            : null,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          final config = (allConfigs)[index];

                          return ConfigListTile(index: index, config: config);
                        },
                        separatorBuilder: (context, index) => Divider(
                          color: theme.colorScheme.primaryContainer,
                        ),
                        itemCount: (allConfigs).length,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
