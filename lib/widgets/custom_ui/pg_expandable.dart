import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PgExpandable extends ConsumerWidget {
  final bool expand;
  final Widget child;
  final Widget? title;
  final Axis direction;

  const PgExpandable(
      {super.key,
      required this.expand,
      required this.child,
      this.title,
      this.direction = Axis.vertical});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (direction) {
      case Axis.vertical:
        return Column(
          children: [
            if (title != null)
              Row(
                children: [
                  title!,
                ],
              ),
            AnimatedSize(
              duration: 150.milliseconds,
              child: SizedBox(
                height: expand ? null : 0,
                child: child,
              ),
            ),
          ],
        );
      case Axis.horizontal:
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (title != null)
              Row(
                children: [
                  title!,
                ],
              ),
            AnimatedSize(
              duration: 150.milliseconds,
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
