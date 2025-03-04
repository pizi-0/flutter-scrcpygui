import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class TitleBarButton extends ConsumerWidget {
  const TitleBarButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
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
          icon: const Padding(
              padding: EdgeInsets.all(4.0), child: Icon(Icons.square_outlined)),
          onPressed: () {
            AppUtils.onAppMaximizeRequested();
          },
        ),
        IconButton(
          variance: ButtonVariance.ghost,
          size: ButtonSize.small,
          icon: const Padding(
              padding: EdgeInsets.all(4.0), child: Icon(Icons.close)),
          onPressed: () {
            AppUtils.onAppCloseRequested(ref, context);
          },
        ),
      ],
    );
  }
}
