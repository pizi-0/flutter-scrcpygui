import 'package:flutter/material.dart';

class LeftColumn extends StatelessWidget {
  final Widget child;
  final Alignment alignment;
  final int flex;
  final bool shouldAlign;

  const LeftColumn(
      {super.key,
      required this.child,
      this.alignment = Alignment.topRight,
      this.shouldAlign = true,
      this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: shouldAlign
          ? Align(
              alignment: alignment,
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 8),
                child: child,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 6.0, bottom: 8),
              child: child,
            ),
    );
  }
}

class RightColumn extends StatelessWidget {
  final Widget child;
  final Alignment alignment;
  final bool shouldAlign;
  final int flex;

  const RightColumn(
      {super.key,
      required this.child,
      this.alignment = Alignment.topLeft,
      this.shouldAlign = true,
      this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: shouldAlign
          ? Align(
              alignment: alignment,
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 8),
                child: child,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 6.0, bottom: 8),
              child: child,
            ),
    );
  }
}
