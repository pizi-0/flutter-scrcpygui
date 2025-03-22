// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

class PgListTile extends ConsumerWidget {
  final BoxConstraints? trailingConstraints;
  final String title;
  final bool dimTitle;
  final bool titleOverflow;
  final bool showSubtitle;
  final bool showSubtitleLeading;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? content;
  final Function()? onPress;

  const PgListTile({
    super.key,
    this.trailingConstraints,
    this.leading,
    this.trailing,
    this.showSubtitle = false,
    this.showSubtitleLeading = true,
    required this.title,
    this.dimTitle = false,
    this.titleOverflow = false,
    this.subtitle,
    this.content,
    this.onPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = FTheme.of(context);

    return FTile(
      onPress: onPress,
      style: theme.tileGroupStyle.tileStyle.copyWith(
        border: Border.all(color: Colors.transparent),
        enabledHoveredBackgroundColor: theme
            .tileGroupStyle.tileStyle.enabledHoveredBackgroundColor
            .withAlpha(100),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: 16,
            children: [
              if (leading != null) leading!,
              Expanded(child: Text(title)),
              if (trailing != null) trailing!,
            ],
          ),
          if (subtitle != null)
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.muted,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
                child: Text(
                  subtitle!,
                  style: theme.typography.xs,
                ),
              ),
            )
        ],
      ),
    );
  }
}
