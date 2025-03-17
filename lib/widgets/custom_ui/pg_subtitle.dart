// ignore_for_file: avoid_unnecessary_containers

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PgSubtitle extends ConsumerWidget {
  final Widget child;
  final bool showSubtitle;
  final bool showSubtitleLeading;
  final String subtitle;

  const PgSubtitle({
    super.key,
    required this.child,
    this.showSubtitle = false,
    this.showSubtitleLeading = true,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 4,
      children: [
        child,
        if (showSubtitle)
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
              child: Row(
                spacing: 4,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (showSubtitleLeading)
                    const Icon(Icons.info_outline_rounded)
                        .iconXSmall()
                        .iconMutedForeground(),
                  Expanded(child: Text(subtitle).xSmall().muted()),
                ],
              ),
            ),
          ).withRoundCorners(
              backgroundColor: theme.colorScheme.muted, radius: theme.radiusXs)
      ],
    );
  }
}
