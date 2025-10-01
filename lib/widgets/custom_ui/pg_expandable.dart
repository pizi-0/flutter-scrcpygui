import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PgExpandable extends ConsumerWidget {
  final bool expand;
  final Widget child;
  final Widget? title;
  final Axis direction;
  final AlignmentGeometry alignment;
  final MainAxisAlignment childMainAxisAlignment;
  final bool fillWidth;
  final bool fillHeight;

  const PgExpandable({
    required this.alignment,
    required this.expand,
    required this.child,
    required this.direction,
    required this.childMainAxisAlignment,
    this.fillHeight = false,
    this.fillWidth = false,
    this.title,
    super.key,
  });

  const PgExpandable.vertical({
    required this.expand,
    required this.child,
    this.title,
    this.alignment = AlignmentGeometry.topCenter,
    this.childMainAxisAlignment = MainAxisAlignment.start,
    this.fillWidth = false,
    super.key,
  })  : direction = Axis.vertical,
        fillHeight = false;

  const PgExpandable.horizontal({
    required this.expand,
    required this.child,
    this.title,
    this.alignment = AlignmentGeometry.centerLeft,
    this.childMainAxisAlignment = MainAxisAlignment.start,
    this.fillHeight = false,
    super.key,
  })  : direction = Axis.horizontal,
        fillWidth = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (direction) {
      case Axis.vertical:
        return Column(
          mainAxisAlignment: childMainAxisAlignment,
          children: [
            if (title != null)
              Row(
                children: [
                  Expanded(child: title!),
                ],
              ),
            AnimatedSize(
              alignment: Alignment.topCenter,
              duration: 200.milliseconds,
              child: SizedBox(
                height: expand ? null : 0,
                width: fillWidth ? double.maxFinite : null,
                child: child,
              ),
            ),
          ],
        );
      case Axis.horizontal:
        return Row(
          mainAxisAlignment: childMainAxisAlignment,
          children: [
            if (title != null)
              Row(
                children: [
                  Expanded(child: title!),
                ],
              ),
            AnimatedSize(
              duration: 200.milliseconds,
              alignment: alignment,
              child: SizedBox(
                width: expand ? null : 0,
                child: child,
              ),
            ),
          ],
        );
    }
  }
}
