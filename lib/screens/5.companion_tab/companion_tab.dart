import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/utils/server_utils.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../providers/server_settings_provider.dart';

class CompanionTab extends ConsumerStatefulWidget {
  static const route = '/companion';
  const CompanionTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CompanionTabState();
}

class _CompanionTabState extends ConsumerState<CompanionTab> {
  final serverUtils = ServerUtils();

  @override
  Widget build(BuildContext context) {
    final isServerRunning = serverUtils.isServerRunning();
    final companionSettings = ref.watch(companionServerProvider);
    final companionSettingsNotifier =
        ref.read(companionServerProvider.notifier);

    return PgScaffold(
      title: 'Companion',
      children: [
        PgSectionCard(
          label: 'Setup server',
          labelTrail: Button(
              style: ButtonStyle.ghost(),
              leading: isServerRunning
                  ? Icon(Icons.stop_rounded)
                  : Icon(Icons.play_arrow_rounded),
              onPressed: () async {
                if (isServerRunning) {
                  await serverUtils.stop();
                } else {
                  await serverUtils.startServer(ref,
                      port: int.tryParse(companionSettings.port) ?? 8080);

                  companionSettingsNotifier
                      .setPort(serverUtils.boundPort.toString());

                  companionSettingsNotifier
                      .setEndpoint(serverUtils.ipAddress?.address ?? '0.0.0.0');
                }
                setState(() {});
              },
              child: isServerRunning ? Text('Stop') : Text('Start')),
          children: [
            ConfigCustom(
              title: 'Status',
              dimTitle: false,
              childExpand: false,
              child: Text(isServerRunning ? 'Running' : 'Stopped').textSmall,
            ),
            Divider(),
            ConfigCustom(
              title: 'Start server on launch',
              childExpand: false,
              onPressed: () async {
                companionSettingsNotifier.setStartOnLaunch();
                await Db.saveCompanionServerSettings(
                    ref.read(companionServerProvider));
              },
              child: Checkbox(
                state: companionSettings.startOnLaunch
                    ? CheckboxState.checked
                    : CheckboxState.unchecked,
                onChanged: (v) async {
                  companionSettingsNotifier.setStartOnLaunch();
                  await Db.saveCompanionServerSettings(
                      ref.read(companionServerProvider));
                },
              ),
            ),
            if (isServerRunning) Divider(),
            if (isServerRunning)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 10,
                  children: [
                    Text('Scan the QR code from Scrcpy GUI companion app')
                        .textSmall
                        .muted,
                    SizedBox.square(
                      dimension: 200,
                      child: QrImageView(
                        data: companionSettings.toQrJson(),
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ],
    );
  }
}
