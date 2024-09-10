import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pg_scrcpy/providers/scrcpy_provider.dart';
import 'package:pg_scrcpy/providers/toast_providers.dart';
import 'package:pg_scrcpy/widgets/config_screen_sections/preview_and_test.dart';
import 'package:pg_scrcpy/widgets/config_visualizer.dart';
import 'package:pg_scrcpy/widgets/section_button.dart';
import 'package:pg_scrcpy/widgets/simple_toast/simple_toast_item.dart';
import 'package:pg_scrcpy/widgets/start_stop_button.dart';

import '../models/scrcpy_related/scrcpy_running_instance.dart';
import '../providers/adb_provider.dart';
import '../utils/const.dart';
import '../utils/scrcpy_utils.dart';

class InstanceList extends ConsumerStatefulWidget {
  const InstanceList({super.key});

  @override
  ConsumerState<InstanceList> createState() => _InstanceListState();
}

class _InstanceListState extends ConsumerState<InstanceList> {
  bool collapse = false;

  @override
  Widget build(BuildContext context) {
    final runningInstance = ref.watch(scrcpyInstanceProvider);
    if (runningInstance.length <= 1) {
      collapse = false;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.hardEdge,
        duration: const Duration(milliseconds: 300),
        width: appWidth,
        height: collapse && runningInstance.isNotEmpty
            ? 110 + 44
            : runningInstance.isNotEmpty
                ? (runningInstance.length * 110) + 44
                : 0,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: appWidth,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child:
                            Text('Running servers (${runningInstance.length})')
                                .textColor(Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                      ),
                      const Spacer(),
                      SectionButton(
                        tooltipmessage: collapse ? 'Expand' : 'Collapse',
                        icondata: collapse
                            ? Icons.expand_more_rounded
                            : Icons.expand_less_rounded,
                        ontap: runningInstance.length > 1
                            ? () {
                                setState(() {
                                  collapse = !collapse;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  width: appWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const Padding(padding: EdgeInsets.only(bottom: 4)),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: runningInstance.length,
                      itemBuilder: (context, index) {
                        return InstanceListItem(
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
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InstanceListItem extends ConsumerStatefulWidget {
  final ScrcpyRunningInstance instance;
  final AsyncCallback? close;
  const InstanceListItem(
      {super.key, required this.instance, required this.close});

  @override
  ConsumerState<InstanceListItem> createState() => _InstanceListItemState();
}

class _InstanceListItemState extends ConsumerState<InstanceListItem> {
  List<String> logs = [];
  // StreamSubscription<String>? out;
  // StreamSubscription<String>? err;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    // out ??=
    //     widget.instance.process.stdout.transform(utf8.decoder).listen((out) {
    //   var thisLog = ref.read(scrcpyInstanceLogsProvider).firstWhere(
    //       (e) => e.pid == widget.instance.scrcpyPID,
    //       orElse: () =>
    //           ScrcpyInstanceLogs(pid: widget.instance.scrcpyPID, logs: []));

    //   thisLog = thisLog.copyWith(logs: [...thisLog.logs, out]);

    //   ref.read(scrcpyInstanceLogsProvider.notifier).log(thisLog);
    // });
    // err ??=
    //     widget.instance.process.stderr.transform(utf8.decoder).listen((err) {
    //   var thisLog = ref.read(scrcpyInstanceLogsProvider).firstWhere(
    //       (e) => e.pid == widget.instance.scrcpyPID,
    //       orElse: () =>
    //           ScrcpyInstanceLogs(pid: widget.instance.scrcpyPID, logs: []));

    //   thisLog = thisLog.copyWith(logs: [...thisLog.logs, err]);

    //   ref.read(scrcpyInstanceLogsProvider.notifier).log(thisLog);
    // });

    WidgetsBinding.instance.addPostFrameCallback((a) {
      if (widget.instance != ref.watch(testInstanceProvider)) {
        timer = Timer.periodic(1.seconds, (a) => _isStillRunning());
      }
    });
  }

  _isStillRunning() async {
    await Future.delayed(500.milliseconds);
    if (mounted) {
      final res = await ScrcpyUtils.getRunningScrcpy(ref.read(appPidProvider));

      if (!res.contains(widget.instance.scrcpyPID)) {
        if (mounted) {
          ref.read(toastProvider.notifier).addToast(
                SimpleToastItem(
                  message:
                      'Server: ${widget.instance.instanceName} (${widget.instance.scrcpyPID}) killed',
                  key: UniqueKey(),
                ),
              );
          ref
              .read(scrcpyInstanceProvider.notifier)
              .removeInstance(widget.instance);
        }
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    // out?.cancel();
    // err?.cancel();
    debugPrint('Scrcpy with PID:${widget.instance.scrcpyPID} killed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final device = ref.watch(savedAdbDevicesProvider).firstWhere(
        (d) => d.serialNo == widget.instance.device.serialNo,
        orElse: () => widget.instance.device);
    return Container(
      width: appWidth,
      height: 106,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.onPrimary),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'PID: ${widget.instance.scrcpyPID}',
                      ),
                      Text(
                        'Config: ${widget.instance.instanceName}',
                      ),
                      Row(
                        children: [
                          Text(
                            'Device: ${device.name?.toUpperCase() ?? device.modelName.toUpperCase()} ',
                          ),
                          Icon(
                            widget.instance.device.id.contains('.')
                                ? Icons.wifi_rounded
                                : Icons.usb_rounded,
                            size: 15,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StopButton(
                      onTap: widget.close,
                      icon: const Icon(
                        Icons.stop_rounded,
                        color: Colors.redAccent,
                        size: 35,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    // const SizedBox(height: 5),
                    // TextButton(
                    //   style: ButtonStyle(
                    //     padding: const WidgetStatePropertyAll(EdgeInsets.all(0)),
                    //     shape: WidgetStatePropertyAll(
                    //       RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(6),
                    //         side: BorderSide(
                    //             color: Theme.of(context).colorScheme.inversePrimary,
                    //             width: 4),
                    //       ),
                    //     ),
                    //   ),
                    //   onPressed: () {
                    //     Navigator.push(
                    //         context,
                    //         PageTransition(
                    //             child: LogScreen(pid: widget.instance.scrcpyPID),
                    //             type: PageTransitionType.rightToLeft));
                    //   },
                    //   child: const Text('Log'),
                    // )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: ConfigVisualizer(instance: widget.instance)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
