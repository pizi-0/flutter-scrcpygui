import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PgScaffold extends ConsumerWidget {
  final List<Widget> children;
  final List<Widget> footers;
  final List<Widget>? appBarTrailing;
  final List<Widget>? leading;
  final bool padBottom;
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
    this.padBottom = false,
    this.showLoading = false,
    this.wrap = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      loadingProgressIndeterminate: showLoading,
      floatingHeader: true,
      headers: [
        Container(
          height: 47,
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.border,
              width: 1,
            ),
          )),
          child: OutlinedContainer(
            surfaceBlur: theme.surfaceBlur,
            surfaceOpacity: theme.surfaceOpacity,
            borderRadius: BorderRadius.all(Radius.zero),
            padding: EdgeInsets.symmetric(horizontal: 3),
            borderStyle: BorderStyle.none,
            child: Row(
              children: [
                if (onBack == null) Gap(2),
                ...[
                  if (onBack != null)
                    IconButton.ghost(
                      onPressed: onBack,
                      onSecondaryTapUp: (details) {
                        ref
                            .read(settingsProvider.notifier)
                            .changeShowOnbackWarning(value: true);
                        Db.saveAppSettings(ref.read(settingsProvider));
                      },
                      icon: Icon(Icons.arrow_back,
                          color: onBack == null ? Colors.transparent : null),
                    ),
                  Gap(3),
                  ...leading ?? []
                ],
                Expanded(
                    child: Padding(
                  padding: onBack == null
                      ? const EdgeInsets.symmetric(horizontal: 6.0)
                      : EdgeInsets.zero,
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ).xLarge().bold(),
                )),
                Gap(3),
                ...appBarTrailing ??
                    [
                      IconButton.ghost(
                        onPressed: null,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.transparent,
                        ),
                      ),
                    ]
              ],
            ),
          ),
        ),
        // Container(
        //   height: 47,
        //   decoration: BoxDecoration(
        //       border: Border(
        //     bottom: BorderSide(
        //       color: theme.colorScheme.border,
        //       width: 1,
        //     ),
        //   )),
        //   child: AppBar(
        //     surfaceBlur: theme.surfaceBlur,
        //     surfaceOpacity: theme.surfaceOpacity,
        //     leading: leading ??
        //         [
        //           IconButton.ghost(
        //             onPressed: onBack,
        //             icon: Icon(Icons.arrow_back,
        //                 color: onBack == null ? Colors.transparent : null),
        //           ),
        //         ],
        //     trailing: appBarTrailing ??
        //         [
        //           IconButton.ghost(
        //             onPressed: null,
        //             icon: Icon(
        //               Icons.arrow_back,
        //               color: Colors.transparent,
        //             ),
        //           ),
        //         ],
        //     padding: const EdgeInsets.all(4),
        //     title: Row(
        //       children: [
        //         Expanded(
        //             child: Center(
        //                 child: FittedBox(
        //                     child: Text(title).xLarge().bold().underline()))),
        //       ],
        //     ),
        //     // backgroundColor: theme.colorScheme.muted,
        //   ),
        // )
      ],
      footers: footers,
      child: showLoading
          ? const Center(
              child: Text('Getting device info'),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Gap(52),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: children,
                  ),
                  Gap(padBottom ? 50 : 8)
                ],
              )),
            ),
    );
  }
}

class PgScaffoldCustom extends ConsumerWidget {
  final Widget scaffoldBody;
  final List<Widget> footers;
  final List<Widget>? appBarTrailing;
  final List<Widget>? leading;
  final bool padTop;

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
    this.padTop = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      loadingProgressIndeterminate: showLoading,
      headers: [
        Container(
          height: 47,
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.border,
              width: 1,
            ),
          )),
          child: OutlinedContainer(
            surfaceBlur: theme.surfaceBlur,
            surfaceOpacity: theme.surfaceOpacity,
            borderRadius: BorderRadius.all(Radius.zero),
            padding: EdgeInsets.symmetric(horizontal: 3),
            borderStyle: BorderStyle.none,
            child: Row(
              children: [
                ...[
                  if (onBack != null) ...[
                    IconButton.ghost(
                      onSecondaryTapUp: (details) => ref
                          .read(settingsProvider.notifier)
                          .changeShowOnbackWarning(value: true),
                      onPressed: onBack,
                      icon: Icon(Icons.arrow_back,
                          color: onBack == null ? Colors.transparent : null),
                    ),
                    Gap(3),
                  ],
                  ...leading ?? []
                ],
                Expanded(
                    child: Padding(
                  padding: onBack == null
                      ? const EdgeInsets.symmetric(horizontal: 11.0)
                      : EdgeInsets.zero,
                  child: title,
                )),
                Gap(3),
                ...appBarTrailing ?? []
              ],
            ),
          ),
        ),
      ],
      footers: footers,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: scaffoldBody,
      ),
    );
  }
}
