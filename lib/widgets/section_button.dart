import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

class SectionButton extends ConsumerWidget {
  final String? tooltipmessage;
  final Function()? ontap;
  final IconData icondata;
  final Color? iconColor;
  final Color? nullColor;
  const SectionButton({
    super.key,
    required this.icondata,
    required this.ontap,
    this.nullColor,
    this.iconColor,
    this.tooltipmessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

    final buttonStyle = ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.widgetRadius),
          ),
        ),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero));

    return IconButton(
      style: buttonStyle,
      tooltip: ontap == null ? '' : tooltipmessage,
      onPressed: ontap,
      icon: Icon(
        icondata,
        color: ontap == null
            ? nullColor ?? Colors.transparent
            : iconColor ?? colorScheme.inverseSurface,
      ),
    );
  }
}
