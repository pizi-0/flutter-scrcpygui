// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:encrypt_decrypt_plus/encrypt_decrypt/xor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:scrcpygui/utils/server_utils_ws.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/server_settings_provider.dart';

class CompanionTab extends ConsumerStatefulWidget {
  static const route = '/companion';
  const CompanionTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CompanionTabState();
}

class _CompanionTabState extends ConsumerState<CompanionTab> {
  final serverUtils = ServerUtilsWs();
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
    ref.watch(settingsProvider.select((s) => s.behaviour.languageCode));
    final isServerRunning = serverUtils.isServerRunning;
    final companionSettings = ref.watch(companionServerProvider);

    return PgScaffold(
      title: el.companionLoc.title,
      children: [
        PgSectionCard(
          label: el.companionLoc.server.label,
          labelTrail: Button(
              style: ButtonStyle.ghost(),
              leading: isServerRunning
                  ? Icon(Icons.stop_rounded, color: Colors.red)
                  : Icon(Icons.play_arrow_rounded, color: Colors.green),
              onPressed: () => _toggleServer(isServerRunning),
              child: isServerRunning
                  ? Text(el.buttonLabelLoc.stop)
                  : Text(el.configLoc.start)),
          children: [
            ConfigCustom(
              title: el.companionLoc.server.status,
              dimTitle: false,
              childExpand: false,
              child: Text(isServerRunning
                      ? el.statusLoc.running
                      : el.statusLoc.stopped)
                  .textColor(isServerRunning ? Colors.green : Colors.red)
                  .textSmall,
            ),
            Divider(),
            ConfigCustom(
              title: el.companionLoc.server.name.label,
              dimTitle: false,
              child: TextField(
                enabled: !isServerRunning,
                controller: nameController,
                filled: !isServerRunning,
                placeholder: Text(el.companionLoc.server.name.info),
              ),
            ),
            Divider(),
            ConfigCustom(
              title: el.companionLoc.server.port.label,
              dimTitle: false,
              child: TextField(
                enabled: !isServerRunning,
                controller: portController,
                filled: !isServerRunning,
                placeholder: Text(el.companionLoc.server.port.info),
              ),
            ),
            Divider(),
            ConfigCustom(
              title: el.companionLoc.server.secret.label,
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
              ),
            ),
            Divider(),
            ConfigCustom(
              title: el.companionLoc.server.autoStart.label,
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
                      data: XOR().xorEncode(companionSettings.toQrJson()),
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(4),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: 8,
                      children: [
                        Text(el.companionLoc.qr)
                            .textAlignment(TextAlign.center)
                            .textSmall
                            .muted,
                        Tooltip(
                          tooltip: TooltipContainer(
                                  child: Text(
                                      'https://github.com/pizi-0/flutter_scrcpygui_companion'))
                              .call,
                          child: OutlineButton(
                            leading: Icon(BootstrapIcons.github).iconSmall(),
                            onPressed: () {
                              launchUrl(Uri.parse(
                                  'https://github.com/pizi-0/flutter_scrcpygui_companion'));
                            },
                            child: Text('Github'),
                          ),
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
    final companionSettingsNotifier =
        ref.read(companionServerProvider.notifier);

    obscurePass = true;

    if (isServerRunning) {
      await serverUtils.stopServer();
    } else {
      final agree = (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(el.serverDisclaimerLoc.title),
              content: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: appWidth, minWidth: appWidth),
                child: Text(
                  el.serverDisclaimerLoc.contents,
                ),
              ),
              actions: [
                Button.primary(
                  child: Text(el.buttonLabelLoc.serverAgree),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
                Button.destructive(
                  child: Text(el.buttonLabelLoc.cancel),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ],
            ),
          )) ??
          false;

      if (!agree) return;

      try {
        await serverUtils.startServer(ref);
        companionSettingsNotifier.setPort(serverUtils.port.toString());

        portController.text = serverUtils.port.toString();

        companionSettingsNotifier.setEndpoint(
            serverUtils.serverSocket?.address.address ?? '0.0.0.0');

        await Db.saveCompanionServerSettings(ref.read(companionServerProvider));
      } on Exception catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: Text(el.statusLoc.error),
              content: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: appWidth, minWidth: appWidth),
                child: Text(
                    'Failed to start companion server.\n\n${e.toString()}'),
              ),
              actions: [
                Button.secondary(
                  onPressed: () => context.pop(),
                  child: Text(el.buttonLabelLoc.close),
                )
              ]),
        );
      }
    }
  }

  _toggleAutoStart() async {
    final companionSettingsNotifier =
        ref.read(companionServerProvider.notifier);

    companionSettingsNotifier.setStartOnLaunch();
    await Db.saveCompanionServerSettings(ref.read(companionServerProvider));
  }
}
