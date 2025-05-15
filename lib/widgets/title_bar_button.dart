import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class TitleBarButton extends ConsumerWidget {
  const TitleBarButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttons = [
      IconButton(
        variance: ButtonVariance.ghost,
        size: ButtonSize.small,
        icon: const Padding(
          padding: EdgeInsets.all(4.0),
          child: Icon(Icons.minimize),
        ),
        onPressed: () {
          AppUtils.onAppMinimizeRequested(ref, context);
        },
      ),
      IconButton(
        variance: ButtonVariance.ghost,
        size: ButtonSize.small,
        icon: const Padding(padding: EdgeInsets.all(4.0), child: Icon(Icons.square_outlined)),
        onPressed: () {
          AppUtils.onAppMaximizeRequested();
        },
      ),
      IconButton(
        variance: ButtonVariance.ghost,
        size: ButtonSize.small,
        icon: const Padding(padding: EdgeInsets.all(4.0), child: Icon(Icons.close)),
        onPressed: () {
          AppUtils.onAppCloseRequested(ref, context);
        },
      ),
    ];

    final buttonsMac = [
      Gap(8),
      IconButton(
        variance: ButtonVariance.ghost,
        size: ButtonSize.small,
        icon: Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          child: Center(
              child: Icon(
            Icons.close_rounded,
            color: Colors.black.withAlpha(50),
          ).iconX2Small()),
        ),
        onPressed: () {
          AppUtils.onAppCloseRequested(ref, context);
        },
      ),
      IconButton(
        variance: ButtonVariance.ghost,
        size: ButtonSize.small,
        icon: Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
          child: Center(
              child: Icon(
            Icons.remove_rounded,
            color: Colors.black.withAlpha(50),
          ).iconX2Small()),
        ),
        onPressed: () {
          AppUtils.onAppMinimizeRequested(ref, context);
        },
      ),
      IconButton(
        variance: ButtonVariance.ghost,
        size: ButtonSize.small,
        icon: Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          child: Center(
              child: Icon(
            Icons.add_rounded,
            color: Colors.black.withAlpha(50),
          ).iconX2Small()),
        ),
        onPressed: () {
          AppUtils.onAppMaximizeRequested();
        },
      ),
    ];

    return Row(
      children: Platform.isMacOS ? buttonsMac : buttons,
    );
  }
}
