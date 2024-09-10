import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pg_scrcpy/models/scrcpy_related/scrcpy_flag_check_result.dart';
import 'package:pg_scrcpy/providers/adb_provider.dart';
import 'package:pg_scrcpy/providers/scrcpy_provider.dart';
import 'package:pg_scrcpy/utils/const.dart';
import 'package:pg_scrcpy/utils/scrcpy_utils.dart';

class StartButton extends ConsumerStatefulWidget {
  final Icon icon;
  final AsyncCallback? onTap;
  final Color? backgroundColor;
  const StartButton(
      {super.key, required this.icon, this.backgroundColor, this.onTap});

  @override
  ConsumerState<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends ConsumerState<StartButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          children: [
            IconButton.filled(
              padding: const EdgeInsets.all(0),
              splashColor: Theme.of(context).splashColor,
              hoverColor: Theme.of(context).hoverColor,
              highlightColor: Theme.of(context).highlightColor,
              style: ButtonStyle(
                // elevation: const WidgetStatePropertyAll(1),
                shadowColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.shadow),
                backgroundColor: WidgetStatePropertyAll(widget.backgroundColor),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() => loading = true);
                final res = ScrcpyUtils.checkForIncompatibleFlags(ref);

                bool proceed = res.where((r) => !r.ok).isEmpty;

                if (proceed == false) {
                  proceed = (await showDialog(
                        context: context,
                        builder: (context) => OverrideDialog(
                            offendingFlags: res.where((r) => !r.ok).toList()),
                      )) ??
                      false;
                }
                if (proceed == true) {
                  await widget.onTap!();
                }
                setState(() => loading = false);
              },
              icon: widget.icon,
            ),
            loading
                ? Container(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    child: SizedBox.expand(
                      child: Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

class StopButton extends ConsumerStatefulWidget {
  final Icon icon;
  final AsyncCallback? onTap;
  final Color? backgroundColor;
  const StopButton(
      {super.key, required this.icon, this.backgroundColor, this.onTap});

  @override
  ConsumerState<StopButton> createState() => _StopButtonState();
}

class _StopButtonState extends ConsumerState<StopButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          children: [
            IconButton.filled(
              padding: const EdgeInsets.all(0),
              splashColor: Theme.of(context).splashColor,
              hoverColor: Theme.of(context).hoverColor,
              highlightColor: Theme.of(context).highlightColor,
              style: ButtonStyle(
                // elevation: const WidgetStatePropertyAll(1),
                shadowColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.shadow),
                backgroundColor: WidgetStatePropertyAll(widget.backgroundColor),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() => loading = true);
                await widget.onTap!();
                if (mounted) setState(() => loading = false);
              },
              icon: widget.icon,
            ),
            loading
                ? Container(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    child: SizedBox.expand(
                      child: Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

class MainScreenFAB extends ConsumerStatefulWidget {
  final ScrollController scroll;
  const MainScreenFAB({super.key, required this.scroll});

  @override
  ConsumerState<MainScreenFAB> createState() => _MainScreenFABState();
}

class _MainScreenFABState extends ConsumerState<MainScreenFAB> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final runningInstance = ref.watch(scrcpyInstanceProvider);
    final selectedDevice = ref.watch(selectedDeviceProvider);

    bool running = runningInstance.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        child: selectedDevice != null
            ? Row(
                children: [
                  const Spacer(),
                  running
                      ? Tooltip(
                          message: 'New instance',
                          child: StartButton(
                            onTap: () async {
                              await ScrcpyUtils.newInstance(ref);
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              widget.scroll.animateTo(
                                  widget.scroll.position.extentTotal,
                                  duration: const Duration(milliseconds: 1000),
                                  curve: Curves.ease);
                            },
                            icon: Icon(
                              Icons.add_rounded,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    width: 10,
                  ),
                  Tooltip(
                    message: runningInstance.isEmpty
                        ? 'Start server'
                        : 'Stop all servers',
                    child: StartButton(
                      onTap: () async {
                        await ScrcpyUtils.runCommand(ref);
                        await Future.delayed(const Duration(milliseconds: 200));
                        widget.scroll.animateTo(
                            widget.scroll.position.extentTotal,
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.ease);
                      },
                      backgroundColor: running
                          ? Colors.redAccent
                          : Theme.of(context).colorScheme.primaryContainer,
                      icon: Icon(
                        running ? Icons.stop_rounded : Icons.play_arrow_rounded,
                        color: running
                            ? Colors.white
                            : Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                      ),
                    ),
                  )
                ],
              )
            : nil,
      ),
    );
  }
}

class OverrideDialog extends ConsumerWidget {
  final bool isEdit;
  final List<FlagCheckResult> offendingFlags;
  const OverrideDialog(
      {super.key, required this.offendingFlags, this.isEdit = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: appWidth,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: isEdit
            ? const Text('Edit disabled:')
            : const Text('Incompatible flags:'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...offendingFlags.map((f) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(f.errorMessage!),
                ))
          ],
        ),
      ),
    );
  }
}
