import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PgSectionCard extends ConsumerWidget {
  final String? label;
  final Widget? labelTrail;
  final Widget? labelButton;
  final EdgeInsetsGeometry? cardPadding;
  final Color? borderColor;
  final List<Widget> children;
  final BoxConstraints? constraints;

  const PgSectionCard(
      {super.key,
      this.label,
      this.labelButton,
      this.labelTrail,
      this.cardPadding = const EdgeInsets.all(8),
      this.borderColor,
      this.constraints = const BoxConstraints(maxWidth: sectionWidth),
      required this.children});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: constraints!,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (label != null)
            Label(
                trailing: labelTrail,
                child: Row(
                  children: [
                    Text(label!).small.firstP.paddingSymmetric(vertical: 8),
                    if (labelButton != null) labelButton!,
                  ],
                )),
          if (constraints!.maxHeight == double.infinity)
            Card(
              padding: cardPadding,
              borderColor: borderColor,
              borderRadius: theme.borderRadiusMd,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: children,
                ),
              ),
            ),
          if (constraints!.maxHeight != double.infinity)
            Expanded(
              child: Card(
                padding: cardPadding,
                borderColor: borderColor,
                borderRadius: theme.borderRadiusMd,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: children,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PgSectionCardNoScroll extends ConsumerWidget {
  final String? label;
  final Widget? labelTrail;
  final Widget? labelButton;
  final EdgeInsetsGeometry? cardPadding;
  final Color? borderColor;
  final Widget content;
  final BoxConstraints? constraints;
  final bool expandContent;

  const PgSectionCardNoScroll({
    super.key,
    this.label,
    this.labelButton,
    this.labelTrail,
    this.cardPadding = const EdgeInsets.all(8),
    this.borderColor,
    required this.content,
    this.constraints = const BoxConstraints(maxWidth: sectionWidth),
    this.expandContent = false,
    // required this.children,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: constraints!,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (label != null)
            Label(
                trailing: labelTrail,
                child: Row(
                  children: [
                    Text(label!).small.firstP.paddingSymmetric(vertical: 8),
                    if (labelButton != null) labelButton!,
                  ],
                )),
          if (expandContent) ...[
            Expanded(
              child: Card(
                padding: cardPadding,
                borderColor: borderColor,
                borderRadius: theme.borderRadiusMd,
                child: content,
              ),
            )
          ] else ...[
            Card(
              padding: cardPadding,
              borderColor: borderColor,
              borderRadius: theme.borderRadiusMd,
              child: content,
            )
          ]
        ],
      ),
    );
  }
}
