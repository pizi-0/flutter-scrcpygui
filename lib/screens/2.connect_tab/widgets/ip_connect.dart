// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../../db/db.dart';
import '../../../providers/adb_provider.dart';
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

    return Focus(
      autofocus: true,
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: AutoSuggestBox(
              autofocus: false,
              controller: ipInput,
              noResultsFoundBuilder: (context) => const SizedBox(),
              items: ipHistory
                  .map((e) => AutoSuggestBoxItem(value: e, label: e))
                  .toList(),
            ),
          ),
          Button(
            onPressed: loading ? null : _connect,
            child: loading
                ? const SizedBox.square(dimension: 22, child: ProgressRing())
                : const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text('Connect'),
                  ),
          ),
        ],
      ),
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
        displayInfoBar(context,
            builder: (context, close) =>
                InfoLabel(label: 'Connected to ${ipInput.text}'));
      }

      if (!res.success) {
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => ErrorDialog(
            title: 'Error',
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
        builder: (context) =>
            ErrorDialog(title: 'Error', content: [Text(e.toString())]),
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
