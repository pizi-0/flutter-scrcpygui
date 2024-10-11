import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';

class SectionButton extends ConsumerWidget {
  final String? tooltipmessage;
  final Function()? ontap;
  final IconData icondata;
  final Color? nullColor;
  const SectionButton(
      {super.key,
      required this.icondata,
      required this.ontap,
      this.nullColor,
      this.tooltipmessage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeProvider);

    final buttonStyle = ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.widgetRadius))));

    return IconButton(
      style: buttonStyle,
      tooltip: ontap == null ? '' : tooltipmessage,
      onPressed: ontap,
      icon: Icon(
        icondata,
        color: ontap == null
            ? nullColor ?? Colors.transparent
            : Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
