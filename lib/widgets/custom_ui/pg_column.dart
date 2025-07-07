import 'package:flutter/material.dart';

class LeftColumn extends StatelessWidget {
  final Widget child;
  final Alignment alignment;

  const LeftColumn(
      {super.key, required this.child, this.alignment = Alignment.topRight});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Align(
      alignment: alignment,
      child: child,
    ));
  }
}

class RightColumn extends StatelessWidget {
  final Widget child;
  final Alignment alignment;

  const RightColumn(
      {super.key, required this.child, this.alignment = Alignment.topLeft});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Align(
      alignment: alignment,
      child: child,
    ));
  }
}
