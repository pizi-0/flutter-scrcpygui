import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../utils/const.dart';

class OverrideDialog extends ConsumerWidget {
  final bool isEdit;
  final List<Widget> overrideWidget;
  const OverrideDialog(
      {super.key, required this.overrideWidget, this.isEdit = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: isEdit
          ? const Text('Edit disabled:')
          : const Text('Incompatible flags:'),
      content: ConstrainedBox(
        constraints:
            const BoxConstraints(minWidth: appWidth, maxWidth: appWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: overrideWidget,
        ),
      ),
      actions: [
        SecondaryButton(
          onPressed: context.pop,
          child: Text(el.buttonLabelLoc.close),
        ),
      ],
    );
  }
}
