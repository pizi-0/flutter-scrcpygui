import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/utils/update_utils.dart';

import '../../../providers/settings_provider.dart';

class DownloadUpdate extends ConsumerStatefulWidget {
  const DownloadUpdate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DownloadUpdateState();
}

class _DownloadUpdateState extends ConsumerState<DownloadUpdate> {
  bool updating = false;
  late Dio dio;

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(downloadPercentageProvider);
    final status = ref.watch(updateStatusProvider);
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (updating)
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                  ),
                  Center(child: Text(status)),
                ],
              ),
            ),
          ),
        Expanded(
          child: FButton(
            style: FButtonStyle.primary,
            onPress: () async {
              if (!updating) {
                dio = Dio();
                updating = true;
                setState(() {});

                await UpdateUtils.startUpdateProcess(ref, dio);
              }
              if (mounted) {
                updating = false;
                setState(() {});
              }
              dio.close(force: true);
            },
            label: updating
                ? const Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Icon(Icons.cancel),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.download),
                      Text(el.buttonLabelLoc.update),
                    ],
                  ),
          ),
        )
      ],
    );
  }
}
