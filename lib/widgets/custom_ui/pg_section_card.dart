import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:scrcpygui/utils/const.dart';

class PgSectionCard extends ConsumerWidget {
  final String? label;
  final Widget? labelTrail;
  final EdgeInsetsGeometry? cardPadding;
  final Color? borderColor;
  final List<Widget> children;
  final BoxConstraints? constraints;
  final double childSpacing;
  final bool expandChildren;

  const PgSectionCard({
    super.key,
    this.label,
    this.labelTrail,
    this.cardPadding,
    this.borderColor,
    this.childSpacing = 8,
    this.constraints = const BoxConstraints(maxWidth: appWidth),
    required this.children,
    this.expandChildren = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = FTheme.of(context);
    return ConstrainedBox(
      constraints: constraints!,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (label != null)
            Row(
              children: [
                Expanded(child: Text(label!).paddingSymmetric(vertical: 8)),
                if (labelTrail != null) labelTrail!,
              ],
            ),
          if (expandChildren)
            Expanded(
              child: FCard(
                style: theme.cardStyle.transform((st) => st.copyWith(
                    contentStyle:
                        st.contentStyle.copyWith(padding: cardPadding))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: childSpacing,
                    children: children,
                  ),
                ),
              ),
            ),
          if (!expandChildren)
            FCard(
              style: theme.cardStyle.transform((st) => st.copyWith(
                  contentStyle:
                      st.contentStyle.copyWith(padding: cardPadding))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: childSpacing,
                  children: children,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
