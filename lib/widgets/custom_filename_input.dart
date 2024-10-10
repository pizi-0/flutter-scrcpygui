import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/providers/scrcpy_provider.dart';
import 'package:scrcpygui/utils/scrcpy_utils.dart';

import '../providers/theme_provider.dart';
import '../utils/const.dart';

class CustomFileName extends ConsumerStatefulWidget {
  const CustomFileName({super.key});

  @override
  ConsumerState<CustomFileName> createState() => _CustomFileNameState();
}

class _CustomFileNameState extends ConsumerState<CustomFileName> {
  TextEditingController name = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedConfig = ref.watch(selectedConfigProvider);
    final settings = ref.watch(appThemeProvider);
    final style =
        TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer);

    return SizedBox(
      width: appWidth,
      height: 96,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: selectedConfig.isRecording
                  ? Text('File name / window title: (default: {configname})',
                      style: style)
                  : Text('Window title: (default: {configname})', style: style),
            ),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(settings.widgetRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(
                              settings.widgetRadius * 0.8),
                        ),
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextField(
                                      controller: name,
                                      onChanged: (a) {
                                        ref
                                            .read(customNameProvider.notifier)
                                            .state = a;
                                      },
                                      decoration: InputDecoration.collapsed(
                                          hintText: selectedConfig.isRecording
                                              ? 'Custom name'
                                              : 'Title'),
                                    ),
                                  ),
                                ),
                                name.text.isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          name.clear();
                                          ref
                                              .read(customNameProvider.notifier)
                                              .state = '';
                                        },
                                        icon: const Icon(Icons.close),
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    selectedConfig.isRecording
                        ? Tooltip(
                            message: 'Open save folder',
                            child: IconButton(
                              onPressed: () {
                                ScrcpyUtils.openFolder(
                                    selectedConfig.savePath!);
                              },
                              icon: const Icon(
                                Icons.folder_open_rounded,
                              ),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
