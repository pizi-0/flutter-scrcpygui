import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/body_container.dart';
import '../../../widgets/clear_preferences_dialog.dart';

class DataSection extends ConsumerStatefulWidget {
  const DataSection({super.key});

  @override
  ConsumerState<DataSection> createState() => _DataSectionState();
}

class _DataSectionState extends ConsumerState<DataSection> {
  @override
  Widget build(BuildContext context) {
    final colorSheme = Theme.of(context).colorScheme;
    return BodyContainer(
      headerTitle: 'Data',
      children: [
        BodyContainerItem(
          title: 'Clear preferences',
          trailing: IconButton(
            onPressed: () async {
              showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return const ClearPreferencesDialog();
                },
              );
            },
            icon: Icon(
              Icons.delete_rounded,
              color: colorSheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }
}
