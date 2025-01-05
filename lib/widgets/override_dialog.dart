import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/scrcpy_related/scrcpy_flag_check_result.dart';
import '../providers/settings_provider.dart';
import '../utils/const.dart';

class OverrideDialog extends ConsumerWidget {
  final bool isEdit;
  final List<FlagCheckResult> offendingFlags;
  const OverrideDialog(
      {super.key, required this.offendingFlags, this.isEdit = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));

    return AlertDialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appTheme.widgetRadius)),
      title: isEdit
          ? const Text('Edit disabled:')
          : const Text('Incompatible flags:'),
      content: ConstrainedBox(
        constraints:
            const BoxConstraints(minWidth: appWidth, maxWidth: appWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...offendingFlags.map((f) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(f.errorMessage!),
                ))
          ],
        ),
      ),
    );
  }
}
