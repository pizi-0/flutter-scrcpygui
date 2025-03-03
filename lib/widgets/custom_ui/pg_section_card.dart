import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PgSectionCard extends ConsumerWidget {
  final String label;
  final Widget? labelTrail;
  final EdgeInsetsGeometry? cardPadding;
  final Color? borderColor;
  final List<Widget> children;

  const PgSectionCard(
      {super.key,
      required this.label,
      this.labelTrail,
      this.cardPadding,
      this.borderColor,
      required this.children});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: appWidth),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Label(
              trailing: labelTrail,
              child: Text(label).paddingSymmetric(vertical: 8)),
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
          )
        ],
      ),
    );
  }
}
