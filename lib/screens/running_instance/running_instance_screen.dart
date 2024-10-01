import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/scrcpy_provider.dart';
import '../../providers/toast_providers.dart';
import '../../utils/scrcpy_utils.dart';
import '../../widgets/instance_list.dart';
import '../../widgets/simple_toast/simple_toast_item.dart';

class RunningInstanceScreen extends ConsumerStatefulWidget {
  const RunningInstanceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RunningInstanceScreenState();
}

class _RunningInstanceScreenState extends ConsumerState<RunningInstanceScreen> {
  @override
  Widget build(BuildContext context) {
    final runningInstance = ref.watch(scrcpyInstanceProvider);
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.pop(context)
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ),
          body: ListView.separated(
            separatorBuilder: (context, index) =>
                const Padding(padding: EdgeInsets.only(bottom: 4)),
            shrinkWrap: true,
            primary: false,
            itemCount: runningInstance.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InstanceListItem(
                  instance: runningInstance[index],
                  close: () async {
                    final appPID = ref.read(appPidProvider);
                    await ScrcpyUtils.killServer(
                        runningInstance[index], appPID);
                    ref.read(toastProvider.notifier).addToast(
                          SimpleToastItem(
                            message:
                                'Server: ${runningInstance[index].instanceName} (${runningInstance[index].scrcpyPID}) killed',
                            key: UniqueKey(),
                          ),
                        );
                    ref
                        .read(scrcpyInstanceProvider.notifier)
                        .removeInstance(runningInstance[index]);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
