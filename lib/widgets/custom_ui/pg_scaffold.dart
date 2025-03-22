import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

class PgScaffold extends ConsumerWidget {
  final List<Widget> children;
  final Widget? footers;
  final List<Widget>? appBarTrailing;
  final bool showLoading;
  final bool wrap;
  final Function()? onBack;
  final bool shouldScroll;

  final String title;
  const PgScaffold({
    super.key,
    required this.children,
    required this.title,
    this.footers,
    this.appBarTrailing,
    this.onBack,
    this.showLoading = false,
    this.wrap = true,
    this.shouldScroll = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FScaffold(
      header: FHeader.nested(
        prefixActions: [
          if (onBack != null)
            FButton.icon(
              onPress: onBack,
              child: FIcon(FAssets.icons.arrowLeft),
            )
        ],
        suffixActions: appBarTrailing ?? [],
        title: Text(title),
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: shouldScroll
            ? SingleChildScrollView(
                primary: false,
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
              )
            : wrap
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
      footer: footers,

      // headers: [
      //   ConstrainedBox(
      //     constraints: const BoxConstraints(
      //         maxHeight: kToolbarHeight + 5, minHeight: kToolbarHeight + 5),
      //     child: AppBar(
      //       leading: [
      //         IconButton.ghost(
      //           onPressed: onBack,
      //           icon: Icon(Icons.arrow_back,
      //               color:
      //                   onBack == null ? theme.colorScheme.background : null),
      //         ),
      //       ],
      //       trailing: appBarTrailing ??
      //           [
      //             IconButton.ghost(
      //               onPressed: null,
      //               icon: Icon(
      //                 Icons.arrow_back,
      //                 color: Theme.of(context).colorScheme.background,
      //               ),
      //             ),
      //           ],
      //       padding: const EdgeInsets.all(8),
      //       title: Row(
      //         children: [
      //           Expanded(
      //               child: Center(
      //                   child: FittedBox(
      //                       child: Text(title).xLarge().bold().underline()))),
      //         ],
      //       ),
      //       // backgroundColor: theme.colorScheme.muted,
      //     ),
      //   )
      // ],
      // footers: footers,
    );
  }
}
