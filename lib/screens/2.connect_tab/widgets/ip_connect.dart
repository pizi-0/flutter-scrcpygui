// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../db/db.dart';
import '../../../providers/adb_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../utils/adb_utils.dart';
import '../../1.home_tab/widgets/home/widgets/connection_error_dialog.dart';

class IPConnect extends ConsumerStatefulWidget {
  const IPConnect({super.key});

  @override
  ConsumerState<IPConnect> createState() => _IPConnectState();
}

class _IPConnectState extends ConsumerState<IPConnect>
    with AutomaticKeepAliveClientMixin {
  TextEditingController ipInput = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    ipInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ipHistory = ref.watch(ipHistoryProvider);
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));

    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: AutoComplete(
            suggestions: ipHistory,
            child: TextField(
              filled: true,
              placeholder:
                  Text('Ip:port(${el.commonLoc.default$.toLowerCase()}=5555)'),
              controller: ipInput,
              onSubmitted: (value) => _connect(),
            ),
          ),
        ),
        loading
            ? const CircularProgressIndicator()
            : PrimaryButton(
                onPressed: loading ? null : _connect,
                child: Text(el.connectLoc.withIp.connect),
              ),
      ],
    );
  }

  _connect() async {
    loading = true;
    setState(() {});

    try {
      final res = await AdbUtils.connectWithIp(ref, ipport: ipInput.text);

      if (res.success) {
        ref.read(ipHistoryProvider.notifier).update((state) => [
              ...state.where(
                (ip) => !ip.contains(ipInput.text.split(':').first),
              ),
              ipInput.text.trim(),
            ]);

        await Db.saveWirelessHistory(ref.read(ipHistoryProvider));
        showToast(
          showDuration: 1.5.seconds,
          context: context,
          builder: (context, overlay) => Basic(
            title: Text(el.connectLoc.withIp.connected(to: ipInput.text)),
          ),
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
