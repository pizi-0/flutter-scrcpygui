import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/update_utils.dart';

class DownloadUpdate extends ConsumerStatefulWidget {
  const DownloadUpdate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DownloadUpdateState();
}

class _DownloadUpdateState extends ConsumerState<DownloadUpdate> {
  bool updating = false;
  late Dio dio;

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(downloadPercentageProvider);
    final status = ref.watch(updateStatusProvider);
    final theme = FluentTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (updating)
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProgressBar(
                    strokeWidth: 5,
                    value: progress,
                  ),
                  Center(
                      child: Text(status).textStyle(theme.typography.caption)),
                ],
              ),
            ),
          ),
        Expanded(
          child: Button(
            style: ButtonStyle(
              padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
              backgroundColor: WidgetStatePropertyAll(
                  updating ? Colors.errorPrimaryColor : theme.accentColor),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
            ),
            onPressed: () async {
              if (!updating) {
                dio = Dio();
                updating = true;
                setState(() {});

                await UpdateUtils.startUpdateProcess(ref, dio);
              }
              if (mounted) {
                updating = false;
                setState(() {});
              }
              dio.close(force: true);
            },
            child: updating
                ? const Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Icon(FluentIcons.cancel),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(FluentIcons.download),
                      const Text('Update')
                          .textStyle(theme.typography.caption!)
                          .textColor(Colors.white),
                    ],
                  ),
          ),
        )
      ],
    );
  }
}
