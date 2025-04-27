import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/utils/const.dart';
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
  bool obscurePass = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController secretController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = ref.read(companionServerProvider).name;
    nameController.addListener(() {
      if (nameController.text.isEmpty) {
        ref.read(companionServerProvider.notifier).setServerName('Scrcpy GUI');
        return;
      }

      ref
          .read(companionServerProvider.notifier)
          .setServerName(nameController.text);
    });

    portController.text = ref.read(companionServerProvider).port;
    portController.addListener(() {
      if (portController.text.isEmpty) {
        ref.read(companionServerProvider.notifier).setPort('8080');
        return;
      }

      ref.read(companionServerProvider.notifier).setPort(portController.text);
    });

    secretController.text = ref.read(companionServerProvider).secret;
    secretController.addListener(() {
      if (secretController.text.isEmpty) {
        ref
            .read(companionServerProvider.notifier)
            .setSecret('scrcpygui-is-okay');
        return;
      }

      ref
          .read(companionServerProvider.notifier)
          .setSecret(secretController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    portController.dispose();
    secretController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isServerRunning = serverUtils.isServerRunning();
    final companionSettings = ref.watch(companionServerProvider);

    return PgScaffold(
      title: 'Companion',
      children: [
        PgSectionCard(
          label: 'Setup server',
          labelTrail: Button(
              style: ButtonStyle.ghost(),
              leading: isServerRunning
                  ? Icon(Icons.stop_rounded, color: Colors.red)
                  : Icon(Icons.play_arrow_rounded, color: Colors.green),
              onPressed: () => _toggleServer(isServerRunning),
              child: isServerRunning ? Text('Stop') : Text('Start')),
          children: [
            ConfigCustom(
              title: 'Status',
              dimTitle: false,
              childExpand: false,
              child: Text(isServerRunning ? 'Running' : 'Stopped')
                  .textColor(isServerRunning ? Colors.green : Colors.red)
                  .textSmall,
            ),
            Divider(),
            ConfigCustom(
              title: 'Server name',
              dimTitle: false,
              child: TextField(
                enabled: !isServerRunning,
                controller: nameController,
                filled: !isServerRunning,
                placeholder: Text('Default: Scrcpy GUI'),
              ),
            ),
            Divider(),
            ConfigCustom(
              title: 'Server port',
              dimTitle: false,
              child: TextField(
                enabled: !isServerRunning,
                controller: portController,
                filled: !isServerRunning,
                placeholder: Text('Default: 8080'),
              ),
            ),
            Divider(),
            ConfigCustom(
              title: 'Server secret',
              dimTitle: false,
              child: TextField(
                enabled: !isServerRunning,
                controller: secretController,
                obscureText: obscurePass,
                filled: !isServerRunning,
                features: [
                  InputFeature.trailing(IconButton.ghost(
                    density: ButtonDensity.iconDense,
                    icon: Icon(obscurePass
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded)
                        .iconXSmall(),
                    onPressed: () {
                      setState(() {
                        obscurePass = !obscurePass;
                      });
                    },
                  ))
                ],
                placeholder: Text('Default: 8080'),
              ),
            ),
            Divider(),
            ConfigCustom(
              title: 'Start server on launch',
              childExpand: false,
              onPressed: _toggleAutoStart,
              child: Checkbox(
                state: companionSettings.startOnLaunch
                    ? CheckboxState.checked
                    : CheckboxState.unchecked,
                onChanged: (v) => _toggleAutoStart(),
              ),
            ),
            if (isServerRunning) Divider(),
            if (isServerRunning)
              Row(
                spacing: 10,
                children: [
                  SizedBox.square(
                    dimension: 150,
                    child: QrImageView(
                      data: companionSettings.toQrJson(),
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(4),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: 8,
                      children: [
                        Text('Scan the QR code from the companion app')
                            .textAlignment(TextAlign.center)
                            .textSmall
                            .muted,
                        OutlineButton(
                          leading: Icon(BootstrapIcons.github).iconSmall(),
                          onPressed: () {},
                          child: Text('Github'),
                        )
                      ],
                    ),
                  ),
                ],
              )
          ],
        ),
      ],
    );
  }

  _toggleServer(bool isServerRunning) async {
    final companionSettings = ref.read(companionServerProvider);
    final companionSettingsNotifier =
        ref.read(companionServerProvider.notifier);

    if (isServerRunning) {
      await serverUtils.stop();
    } else {
      final agree = (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Disclaimer'),
              content: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: appWidth, minWidth: appWidth),
                child: Text(
                  'Security Warning: The companion server uses an unencrypted connection (HTTP).\n\n'
                  'Only start the server if you are connected to a private network you trust, such as your home Wi-Fi.',
                ),
              ),
              actions: [
                Button.primary(
                  child: Text('I understand, start server'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
                Button.destructive(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ],
            ),
          )) ??
          false;

      if (!agree) return;

      await serverUtils.startServer(ref,
          port: int.tryParse(companionSettings.port) ?? 8080);

      companionSettingsNotifier.setPort(serverUtils.boundPort.toString());

      portController.text = serverUtils.boundPort.toString();

      companionSettingsNotifier
          .setEndpoint(serverUtils.ipAddress?.address ?? '0.0.0.0');

      await Db.saveCompanionServerSettings(ref.read(companionServerProvider));
    }
    setState(() {});
  }

  _toggleAutoStart() async {
    final companionSettingsNotifier =
        ref.read(companionServerProvider.notifier);

    companionSettingsNotifier.setStartOnLaunch();
    await Db.saveCompanionServerSettings(ref.read(companionServerProvider));
  }
}
