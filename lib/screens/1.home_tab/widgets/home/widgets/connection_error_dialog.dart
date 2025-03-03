import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ErrorDialog extends ConsumerWidget {
  final String title;
  final List<Widget> content;
  const ErrorDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(title),
      content: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: appWidth, minWidth: appWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: content,
        ),
      ),
      actions: [
        SecondaryButton(
          child: Text(el.buttonLabelLoc.close),
          onPressed: () => context.pop(),
        )
      ],
    );
  }
}
