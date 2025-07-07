// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../db/db.dart';
import '../../../providers/adb_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../utils/adb_utils.dart';
import '../../1.home_tab/widgets/home/widgets/connection_error_dialog.dart';

class IPConnect extends ConsumerStatefulWidget {
  final TextEditingController controller;
  const IPConnect({super.key, required this.controller});

  @override
  ConsumerState<IPConnect> createState() => _IPConnectState();
}

class _IPConnectState extends ConsumerState<IPConnect>
    with AutomaticKeepAliveClientMixin {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: TextField(
            filled: true,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.:]')),
              FilteringTextInputFormatter.deny('..')
            ],
            placeholder:
                Text('Ip:port(${el.commonLoc.default$.toLowerCase()}=5555)'),
            controller: widget.controller,
            onSubmitted: (value) => _connect(widget.controller.text),
          ),
        ),
        loading
            ? const CircularProgressIndicator()
            : PrimaryButton(
                onPressed:
                    loading ? null : () => _connect(widget.controller.text),
                child: Text(el.connectLoc.withIp.connect),
              ),
      ],
    );
  }

  Future<void> _connect(String ipport) async {
    loading = true;
    setState(() {});

    try {
      final workDir = ref.read(execDirProvider);
      final res = await AdbUtils.connectWithIp(workDir, ipport: ipport);

      if (res.success) {
        ref.read(ipHistoryProvider.notifier).update((state) {
          if (state.length == 10) {
            state.removeLast();
          }
          return [ipport, ...state.where((ip) => ip != ipport)];
        });

        await Db.saveWirelessHistory(ref.read(ipHistoryProvider));
        showToast(
          showDuration: 1.5.seconds,
          context: context,
          location: ToastLocation.bottomCenter,
          builder: (context, overlay) => SurfaceCard(
              child: Basic(
            title: Text(el.connectLoc.withIp.connected(to: ipport)),
            trailing: const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.green,
            ),
          )),
        );
      }

      if (!res.success) {
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => ErrorDialog(
            title: el.statusLoc.error,
            content: [
              Text(
                res.errorMessage.replaceAtIndex(
                    index: 0,
                    replacement: res.errorMessage.substring(0, 1).capitalize),
              ),
            ],
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        loading = false;
        setState(() {});
      }

      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
            title: el.statusLoc.error, content: [Text(e.toString())]),
      );
    }

    if (mounted) {
      loading = false;
      setState(() {});
    }
  }

  @override
  bool get wantKeepAlive => true;
}
