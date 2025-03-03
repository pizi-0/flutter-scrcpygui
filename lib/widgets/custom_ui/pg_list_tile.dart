// ignore_for_file: avoid_unnecessary_containers

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PgListTile extends ConsumerWidget {
  final BoxConstraints? trailingConstraints;
  final String title;
  final String? titleBadge;
  final bool showSubtitle;
  final bool showSubtitleLeading;
  final String? subtitle;
  final Icon? leading;
  final Widget? trailing;

  const PgListTile({
    super.key,
    this.trailingConstraints,
    this.leading,
    this.trailing,
    this.showSubtitle = false,
    this.showSubtitleLeading = true,
    required this.title,
    this.titleBadge,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Row(
      spacing: 8,
      children: [
        if (leading != null) leading!.iconMedium(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 4,
            children: [
              Basic(
                leadingAlignment: Alignment.center,
                title: Row(
                  spacing: 8,
                  children: [
                    Text(title),
                    if (titleBadge != null)
                      PrimaryBadge(child: Text(titleBadge!))
                  ],
                ),
                trailing: ConstrainedBox(
                  constraints: trailingConstraints ??
                      const BoxConstraints(minWidth: 150, minHeight: 30),
                  child: trailing,
                ).showIf(trailing != null),
              ),
              if (showSubtitle && subtitle != null)
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 2),
                    child: Row(
                      spacing: 4,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (showSubtitleLeading)
                          const Icon(Icons.info_outline_rounded)
                              .iconXSmall()
                              .iconMutedForeground(),
                        Expanded(child: Text(subtitle!).xSmall().muted()),
                      ],
                    ),
                  ),
                ).withRoundCorners(
                    backgroundColor: theme.colorScheme.muted,
                    radius: theme.radiusXs)
            ],
          ),
        ),
      ],
    );
  }
}
