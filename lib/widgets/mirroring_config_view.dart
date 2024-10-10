import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';
import '../utils/const.dart';

class MirroringConfigView extends ConsumerStatefulWidget {
  const MirroringConfigView({super.key});

  @override
  ConsumerState<MirroringConfigView> createState() =>
      _MirroringConfigViewState();
}

class _MirroringConfigViewState extends ConsumerState<MirroringConfigView> {
  List<String> mirrorMode = ['both', 'audio', 'video'];
  late String currentMirrorMode = mirrorMode[0];

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appThemeProvider);

    return Center(
      child: SizedBox(
        width: appWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            mode(context),
            const SizedBox(height: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Bit rate'),
                ),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(settings.widgetRadius),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text('Audio'),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Video'),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Column mode(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text('Mirror mode'),
              const Spacer(),
              currentMirrorMode == mirrorMode[1]
                  ? const Text('[ --no-video ]')
                  : currentMirrorMode == mirrorMode[2]
                      ? const Text('[ --no-audio ]')
                      : const Text('[ ]')
            ],
          ),
        ),
      ],
    );
  }
}
