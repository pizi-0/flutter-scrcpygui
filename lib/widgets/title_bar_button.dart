import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/app_utils.dart';

class TitleBarButton extends ConsumerWidget {
  const TitleBarButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        IconButton(
          icon: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(FluentIcons.calculator_subtract),
          ),
          onPressed: () {
            AppUtils.onAppMinimizeRequested(ref, context);
          },
        ),
        IconButton(
          icon: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(FluentIcons.square_shape),
          ),
          onPressed: () {
            AppUtils.onAppMaximizeRequested();
          },
        ),
        IconButton(
          icon: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(FluentIcons.cancel),
          ),
          onPressed: () {
            AppUtils.onAppCloseRequested(ref, context);
          },
        ),
      ],
    );
  }
}
