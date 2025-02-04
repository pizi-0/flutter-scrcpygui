import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../models/scrcpy_related/scrcpy_info/scrcpy_info.dart';
import '../../../providers/settings_provider.dart';

class InfoContainer extends ConsumerWidget {
  final ScrcpyInfo info;
  const InfoContainer({super.key, required this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.read(settingsProvider).looks;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: 200.milliseconds,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(appTheme.widgetRadius * 0.85),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Build version: ${info.buildVersion}'),
            Text(
                'ID: ${info.device.serialNo.removeFirstAndLastEqual('.$adbMdns')}'),
            Text('Model name: ${info.device.modelName}'),
            const Text('\nScrcpy details: '),
            const Text('\nDisplays:'),
            ...info.displays.map((e) => Row(
                  children: [
                    const Text('- '),
                    Expanded(child: Text(e.toString())),
                  ],
                )),
            const Text('\nCamera:'),
            ...info.cameras.map((e) => Row(
                  children: [
                    const Text('- '),
                    Text(e.toString()),
                  ],
                )),
            const Text('\nAudio encoder:'),
            ...info.audioEncoder.map((e) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('- '),
                    Expanded(child: Text(e.toString())),
                  ],
                )),
            const Text('\nVideo encoder:'),
            ...info.videoEncoders.map((e) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('- '),
                    Expanded(child: Text(e.toString())),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
