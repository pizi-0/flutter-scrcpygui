import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/screens/config_screen/config_screen.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/widgets/section_button.dart';

import '../../../models/scrcpy_related/scrcpy_config.dart';
import '../../../providers/adb_provider.dart';
import '../../../utils/scrcpy_utils.dart';
import '../../../widgets/config_visualizer.dart';
import 'small/home_small.dart';

class ConfigListTile extends ConsumerStatefulWidget {
  final int index;
  final ScrcpyConfig config;
  const ConfigListTile({super.key, required this.config, required this.index});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfigListTileState();
}

class _ConfigListTileState extends ConsumerState<ConfigListTile> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final selectedDevice = ref.watch(selectedDeviceProvider);
    final devices = ref.watch(adbProvider);

    return ListTile(
      enabled: !loading,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      dense: true,
      leading: Text('${widget.index + 1}')
          .textStyle(Theme.of(context).textTheme.bodyMedium),
      title: Text(widget.config.configName),
      subtitle: Row(
        children: [
          ConfigVisualizer(conf: widget.config),
        ],
      ),
      trailing: loading
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: CupertinoActivityIndicator(),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!defaultConfigs.contains(widget.config))
                  SectionButton(
                    ontap: () async {
                      if (selectedDevice == null) {
                        if (devices.length == 1 && devices.isNotEmpty) {
                          ref.read(selectedDeviceProvider.notifier).state =
                              devices.first;
                          await ScrcpyUtils.newInstance(ref,
                              selectedConfig: widget.config);
                        } else {
                          ref.read(homeDeviceAttention.notifier).state = true;

                          loading = false;
                          setState(() {});

                          await Future.delayed(2.seconds, () {
                            ref.read(homeDeviceAttention.notifier).state =
                                false;
                          });
                        }
                      } else {
                        ref.read(configScreenConfig.notifier).state =
                            widget.config;
                        await AppUtils.push(context, const ConfigScreen());

                        await Future.delayed(1.seconds);

                        ref.read(configScreenConfig.notifier).state = null;
                      }
                    },
                    icondata: Icons.edit_rounded,
                  ),
                SectionButton(
                  ontap: () async {
                    loading = true;
                    setState(() {});

                    if (selectedDevice == null) {
                      if (devices.length == 1 && devices.isNotEmpty) {
                        ref.read(selectedDeviceProvider.notifier).state =
                            devices.first;
                        await ScrcpyUtils.newInstance(ref,
                            selectedConfig: widget.config);
                      } else {
                        ref.read(homeDeviceAttention.notifier).state = true;

                        loading = false;
                        setState(() {});

                        await Future.delayed(2.seconds, () {
                          ref.read(homeDeviceAttention.notifier).state = false;
                        });
                      }
                    } else {
                      await ScrcpyUtils.newInstance(ref,
                          selectedConfig: widget.config);
                    }

                    if (loading) {
                      loading = false;
                      setState(() {});
                    }
                  },
                  icondata: Icons.play_circle_fill_rounded,
                ),
              ],
            ),
    );
  }
}
