import 'package:flutter/material.dart' show kToolbarHeight;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PgScaffold extends ConsumerWidget {
  final List<Widget> children;
  final List<Widget> footers;
  final List<Widget>? appBarTrailing;
  final List<Widget>? leading;

  final bool showLoading;
  final bool wrap;
  final Function()? onBack;

  final String title;
  const PgScaffold({
    super.key,
    required this.children,
    required this.title,
    this.footers = const [],
    this.leading,
    this.appBarTrailing,
    this.onBack,
    this.showLoading = false,
    this.wrap = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      loadingProgressIndeterminate: showLoading,
      headers: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: kToolbarHeight + 5, minHeight: kToolbarHeight + 5),
          child: AppBar(
            leading: leading ??
                [
                  IconButton.ghost(
                    onPressed: onBack,
                    icon: Icon(Icons.arrow_back, color: onBack == null ? theme.colorScheme.background : null),
                  ),
                ],
            trailing: appBarTrailing ??
                [
                  IconButton.ghost(
                    onPressed: null,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ],
            padding: const EdgeInsets.all(8),
            title: Row(
              children: [
                Expanded(child: Center(child: FittedBox(child: Text(title).xLarge().bold().underline()))),
              ],
            ),
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
                child: wrap
                    ? Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
                        children: children,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children,
                      ),
              ),
            ),
    );
  }
}

class PgScaffoldCustom extends ConsumerWidget {
  final Widget scaffoldBody;
  final List<Widget> footers;
  final List<Widget>? appBarTrailing;
  final List<Widget>? leading;

  final bool showLoading;
  final bool wrap;
  final Function()? onBack;

  final Widget title;
  const PgScaffoldCustom({
    super.key,
    required this.scaffoldBody,
    required this.title,
    this.footers = const [],
    this.leading,
    this.appBarTrailing,
    this.onBack,
    this.showLoading = false,
    this.wrap = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      loadingProgressIndeterminate: showLoading,
      headers: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: kToolbarHeight + 5, minHeight: kToolbarHeight + 5),
          child: AppBar(
            leading: leading ??
                [
                  IconButton.ghost(
                    onPressed: onBack,
                    icon: Icon(Icons.arrow_back, color: onBack == null ? theme.colorScheme.background : null),
                  ),
                ],
            trailing: appBarTrailing ??
                [
                  IconButton.ghost(
                    onPressed: null,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ],
            padding: const EdgeInsets.all(8),
            title: Row(
              children: [
                Expanded(child: Center(child: FittedBox(child: title))),
              ],
            ),
            // backgroundColor: theme.colorScheme.muted,
          ),
        )
      ],
      footers: footers,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: scaffoldBody,
      ),
    );
  }
}
