import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/widgets/button.dart';
import 'package:scrcpygui/utils/app_utils.dart';

class TitleBarButton extends ConsumerWidget {
  const TitleBarButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        FButton.icon(
          style: FButtonStyle.ghost,
          child: Icon(Icons.minimize),
          onPress: () {
            AppUtils.onAppMinimizeRequested(ref, context);
          },
        ),
        FButton.icon(
          style: FButtonStyle.ghost,
          child: Icon(Icons.square_outlined),
          onPress: () {
            AppUtils.onAppMaximizeRequested();
          },
        ),
        FButton.icon(
          style: FButtonStyle.ghost,
          child: Icon(Icons.close),
          onPress: () {
            AppUtils.onAppCloseRequested(ref, context);
          },
        ),
      ],
    );
  }
}
