import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ErrorDialog extends ConsumerWidget {
  final String title;
  final List<Widget> content;
  const ErrorDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ContentDialog(
      title: Text(title),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: content,
      ),
      actions: [
        Button(
          child: const Text('Close'),
          onPressed: () => context.pop(),
        )
      ],
    );
  }
}
