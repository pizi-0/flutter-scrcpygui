import 'package:flutter/material.dart';

class SectionButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return IconButton(
      style: const ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
      ),
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
