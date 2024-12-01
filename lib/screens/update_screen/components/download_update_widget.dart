import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/utils/const.dart';

class DownloadUpdate extends ConsumerStatefulWidget {
  const DownloadUpdate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DownloadUpdateState();
}

class _DownloadUpdateState extends ConsumerState<DownloadUpdate> {
  bool updating = false;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(settingsProvider).looks;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            maxWidth: appWidth, maxHeight: 30, minHeight: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: 200.milliseconds,
              width: updating ? appWidth - 125 : 0,
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: LinearProgressIndicator(
                  minHeight: 30,
                  color: Colors.green,
                  // value: progress,
                  borderRadius:
                      BorderRadius.circular(appTheme.widgetRadius * 0.6),
                ),
              ),
            ),
            Expanded(
              child: Container(
                clipBehavior: Clip.hardEdge,
                height: 40,
                decoration: BoxDecoration(
                    color: updating ? Colors.red : Colors.green,
                    borderRadius:
                        BorderRadius.circular(appTheme.widgetRadius * 0.6)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        updating = !updating;
                      });
                    },
                    child: updating
                        ? const Icon(Icons.cancel_outlined, color: Colors.black)
                        : Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.download,
                                          color: Colors.black, size: 18)
                                      .paddingOnly(right: 4),
                                  const Text('Update')
                                      .textColor(Colors.black)
                                      .bold(),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
