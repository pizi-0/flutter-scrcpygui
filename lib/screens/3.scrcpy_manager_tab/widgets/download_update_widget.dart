import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/utils/update_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

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
                  LinearProgressIndicator(
                    value: progress,
                  ),
                  Center(child: Text(status)),
                ],
              ),
            ),
          ),
        Expanded(
          child: PrimaryButton(
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
                    child: Icon(Icons.cancel),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.download),
                      Text(el.buttonLabelLoc.update),
                    ],
                  ),
          ),
        )
      ],
    );
  }
}
