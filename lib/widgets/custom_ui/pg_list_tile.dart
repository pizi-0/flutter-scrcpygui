// ignore_for_file: avoid_unnecessary_containers

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_expandable.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PgListTile extends ConsumerWidget {
  final BoxConstraints? trailingConstraints;
  final String title;
  final bool dimTitle;
  final bool titleOverflow;
  final bool? showBadge;
  final bool showSubtitle;
  final bool showSubtitleLeading;
  final String? subtitle;
  final Icon? leading;
  final Widget? trailing;
  final Widget? content;

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
    this.showBadge = false,
    this.subtitle,
    this.content,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final expand = subtitle != null && showSubtitle;

    return PgExpandable.vertical(
      fillWidth: true,
      expand: expand,
      title: Row(
        spacing: 8,
        children: [
          if (leading != null) leading!.iconMedium(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: expand ? 4 : 0,
              children: [
                Basic(
                  leadingAlignment: Alignment.center,
                  title: Row(
                    spacing: 8,
                    children: titleOverflow
                        ? [
                            Expanded(
                              child: OverflowMarquee(
                                  duration: 2.seconds,
                                  delayDuration: 1.seconds,
                                  child: dimTitle
                                      ? Text(title).muted()
                                      : Text(title)),
                            ),
                          ]
                        : [
                            Expanded(
                                child: dimTitle
                                    ? Text(title).muted()
                                    : Text(title)),
                          ],
                  ),
                  content: content,
                  trailing: trailing,
                ),
                SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
      child: Container(
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
              if (subtitle != null)
                Expanded(child: Text(subtitle!).xSmall().muted()),
            ],
          ).showIf(subtitle != null && expand),
        ),
      ).withRoundCorners(
          backgroundColor: theme.colorScheme.muted, radius: theme.radiusXs),
    );
  }
}
