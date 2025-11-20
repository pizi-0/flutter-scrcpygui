import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/app_icon_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../providers/icon_extractor_provider.dart';

class ExtractorIndicator extends ConsumerStatefulWidget {
  const ExtractorIndicator({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExtractorIndicatorState();
}

class _ExtractorIndicatorState extends ConsumerState<ExtractorIndicator> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      IconExtractor.runner(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final missings = ref.watch(iconsToExtractProvider);
    final toExtractCount = missings.expand((dev) => dev.apps).length;
    ref.watch(iconExtractorProgressProvider);

    return MouseRegion(
      onEnter: (event) => showPopover(
        context: context,
        alignment: AlignmentGeometry.center,
        builder: (context) => const ProgressPopover(),
      ),
      child: Button(
        style: ButtonStyle.ghost(density: ButtonDensity.compact),
        onPressed: () {
          showPopover(
            context: context,
            alignment: AlignmentGeometry.center,
            builder: (context) => const ProgressPopover(),
          );
        },
        child: SizedBox.square(
          dimension: 40,
          child: Stack(
            children: [
              Center(
                child: CircularProgressIndicator(
                  size: 20,
                ),
              ),
              Center(
                child: Text(toExtractCount.toString()).muted.xSmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressPopover extends ConsumerStatefulWidget {
  const ProgressPopover({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProgressPopoverState();
}

class _ProgressPopoverState extends ConsumerState<ProgressPopover> {
  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(iconExtractorProgressProvider);
    final theme = Theme.of(context);

    return ModalContainer(
      borderRadius: theme.borderRadiusMd,
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status').bold.small,
            Text('Device: ${progress.currentDevice}').muted.xSmall,
            Text('App: ${progress.currentApp}').muted.xSmall,
            Text('Successful: ${progress.successful.length}').muted.xSmall,
            Text('Failed: ${progress.failed.length}').muted.xSmall,
          ],
        ),
      ),
    );
  }
}
