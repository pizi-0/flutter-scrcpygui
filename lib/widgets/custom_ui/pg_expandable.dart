import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PgExpandable extends ConsumerWidget {
  final bool expand;
  final Widget child;
  final Widget? title;

  const PgExpandable(
      {super.key, required this.expand, required this.child, this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        if (title != null)
          Row(
            children: [
              title!,
            ],
          ),
        AnimatedSize(
          duration: 200.milliseconds,
          child: SizedBox(
            height: expand ? null : 0,
            child: child,
          ),
        ),
      ],
    );
  }
}
