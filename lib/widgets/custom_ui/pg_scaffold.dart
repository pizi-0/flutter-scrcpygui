import 'package:flutter/material.dart' show kToolbarHeight;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PgScaffold extends ConsumerWidget {
  final List<Widget> children;
  final List<Widget> footers;
  final List<Widget> appBarTrailing;
  final bool showLoading;
  final Function()? onBack;

  final String title;
  const PgScaffold({
    super.key,
    required this.children,
    required this.title,
    this.footers = const [],
    this.appBarTrailing = const [],
    this.onBack,
    this.showLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      loadingProgressIndeterminate: showLoading,
      headers: [
        ConstrainedBox(
          constraints: const BoxConstraints(
              maxHeight: kToolbarHeight + 5, minHeight: kToolbarHeight + 5),
          child: AppBar(
            leading: [
              if (onBack != null)
                IconButton.ghost(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
            ],
            trailing: appBarTrailing,
            padding: const EdgeInsets.all(8),
            title: Text(title).xLarge().bold().underline(),
            // backgroundColor: theme.colorScheme.muted,
          ),
        )
      ],
      footers: footers,
      child: showLoading
          ? const Center(
              child: Text('Getting device info'),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: children,
                ),
              ),
            ),
    );
  }
}
