import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/config_provider.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/prefs_key.dart';

import '../providers/settings_provider.dart';
import '../utils/const.dart';

class ClearPreferencesDialog extends ConsumerStatefulWidget {
  const ClearPreferencesDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ClearPreferencesDialogState();
}

class _ClearPreferencesDialogState
    extends ConsumerState<ClearPreferencesDialog> {
  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(appTheme.widgetRadius),
      ),
      title: const Text('Clear preferences'),
      content: ConstrainedBox(
        constraints:
            const BoxConstraints(minWidth: appWidth, maxWidth: appWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius:
                    BorderRadius.circular(appTheme.widgetRadius * 0.8),
              ),
              child: ListTile(
                title: const Text('Appearance'),
                trailing: IconButton(
                  onPressed: () async {
                    await AppUtils.clearSharedPrefs(PKEY_APPTHEME);
                    ref.read(settingsProvider.notifier).update(
                        (state) => state = state.copyWith(looks: defaultTheme));
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius:
                    BorderRadius.circular(appTheme.widgetRadius * 0.8),
              ),
              child: ListTile(
                title: const Text('Saved config'),
                trailing: IconButton(
                  onPressed: () async {
                    await AppUtils.clearSharedPrefs(PKEY_SAVED_CONFIG);
                    await AppUtils.clearSharedPrefs(PKEY_LASTUSED_CONFIG);
                    for (final c in ref.read(configsProvider)) {
                      if (!defaultConfigs.contains(c)) {
                        ref.read(configsProvider.notifier).removeConfig(c);
                      }
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius:
                    BorderRadius.circular(appTheme.widgetRadius * 0.8),
              ),
              child: ListTile(
                title: const Text('Wireless device histories'),
                trailing: IconButton(
                  onPressed: () async {
                    await AppUtils.clearSharedPrefs(PKEY_WIRELESS_DEVICE_HX);
                    ref.read(wirelessDevicesHistoryProvider.notifier).state =
                        [];
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
