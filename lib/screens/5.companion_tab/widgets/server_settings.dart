// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:encrypt_decrypt_plus/encrypt_decrypt/xor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scrcpygui/utils/server_utils_ws.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../db/db.dart';
import '../../../providers/companion_server_state_provider.dart';
import '../../../providers/server_settings_provider.dart';
import '../../../utils/const.dart';
import '../../../widgets/config_tiles.dart';
import '../../../widgets/custom_ui/pg_section_card.dart';

class ServerSettings extends ConsumerStatefulWidget {
  final bool expandContent;
  const ServerSettings({super.key, this.expandContent = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServerSettingsState();
}

class _ServerSettingsState extends ConsumerState<ServerSettings> {
  bool obscurePass = true;
  bool showBlocked = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController ipController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController secretController = TextEditingController();
  final serverUtils = ServerUtilsWs();
  List<NetworkInterface> interfaces = [];

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

    WidgetsBinding.instance.addPostFrameCallback((t) async {
      await _setIp();
      setState(() {});
    });
  }

  Future<void> _setIp() async {
    interfaces = await getInterfaces();
    ipController.text = await getEffectiveIp(ref);
  }

  @override
  void dispose() {
    nameController.dispose();
    ipController.dispose();
    portController.dispose();
    secretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverState = ref.watch(companionServerStateProvider);
    final companionSettings = ref.watch(companionServerProvider);
    final isServerRunning = serverState.isRunning;
    final theme = Theme.of(context);

    return PgSectionCardNoScroll(
      cardPadding: EdgeInsets.all(0),
      label: el.companionLoc.server.label,
      labelTrail: Button(
          style: ButtonStyle.ghost(density: ButtonDensity.dense),
          leading: isServerRunning
              ? Icon(Icons.stop_rounded, color: Colors.red)
              : Icon(Icons.play_arrow_rounded, color: Colors.green),
          onPressed: () => _toggleServer(isServerRunning),
          child: isServerRunning
              ? Text(el.buttonLabelLoc.stop)
              : Text(el.configLoc.start)),
      expandContent: widget.expandContent,
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 8,
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
                title: 'Network adapter',
                dimTitle: false,
                child: Row(
                  spacing: 2,
                  children: [
                    Expanded(
                      child: Select(
                        onChanged: (value) => _onChangeAdapter(value),
                        filled: !isServerRunning,
                        enabled: interfaces.isNotEmpty && !isServerRunning,
                        padding: _adjustedPadding(isServerRunning),
                        value: companionSettings.adapter == ''
                            ? interfaces
                                    .firstWhereOrNull((i) =>
                                        i.addresses.first.address ==
                                        companionSettings.endpoint)
                                    ?.name ??
                                ''
                            : companionSettings.adapter,
                        popup: SelectPopup(
                          items: SelectItemBuilder(
                            childCount: interfaces.length,
                            builder: (context, index) => SelectItemButton(
                                value: interfaces[index].name,
                                child: Text(interfaces[index].name)),
                          ),
                        ).call,
                        itemBuilder: (context, value) => Text(value),
                      ),
                    ),
                    Button(
                      style:
                          ButtonStyle.ghost(density: ButtonDensity.iconDense),
                      onPressed: () async {
                        interfaces = await getInterfaces();
                        setState(() {});
                      },
                      child: Icon(Icons.refresh_rounded),
                    )
                  ],
                ),
              ),
              Divider(),
              ConfigCustom(
                title: el.companionLoc.server.endpoint.label,
                dimTitle: false,
                child: OutlinedContainer(
                  borderRadius: theme.borderRadiusMd,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Text(
                      companionSettings.endpoint,
                      style: theme.typography.small,
                    ),
                  ),
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
        ),
      ),
    );
  }

  EdgeInsetsGeometry _adjustedPadding(bool isServerRunning) {
    return EdgeInsets.fromLTRB(
        isServerRunning ? 11 : 12,
        isServerRunning ? 7 : 8,
        isServerRunning ? 7 : 8,
        isServerRunning ? 8 : 9);
  }

  Future<void> _toggleServer(bool isServerRunning) async {
    final companionSettingsNotifier =
        ref.read(companionServerProvider.notifier);

    obscurePass = true;

    if (isServerRunning) {
      await serverUtils.stopServer(ref);
    } else {
      final agree = (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(el.serverDisclaimerLoc.title),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: sectionWidth, minWidth: sectionWidth),
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
        if (ipController.text.isEmpty) {
          throw Exception('Endpoint cannot be empty.');
        }

        if (!ipController.text.isIpv4) {
          throw Exception('Invalid endpoint.');
        }

        await serverUtils.startServer(ref,
            ipAddress: ipController.text.isNotEmpty && ipController.text.isIpv4
                ? InternetAddress(ipController.text)
                : null);
        final port = ref.read(companionServerStateProvider).port;

        companionSettingsNotifier.setPort(port);

        portController.text = port;

        companionSettingsNotifier.setEndpoint(
            serverUtils.serverSocket?.address.address ?? '0.0.0.0');

        await Db.saveCompanionServerSettings(ref.read(companionServerProvider));
      } on Exception catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: Text(el.statusLoc.error),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: sectionWidth, minWidth: sectionWidth),
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

  void _onChangeAdapter(String? value) {
    final adapterIp = interfaces
            .firstWhereOrNull(
                (iface) => iface.name == value && iface.addresses.isNotEmpty)
            ?.addresses
            .first
            .address ??
        '0.0.0.0';

    ref.read(companionServerProvider.notifier)
      ..setEndpoint(adapterIp)
      ..setAdapter(value ?? '');

    ipController.text = adapterIp;
    setState(() {});
  }

  Future<void> _toggleAutoStart() async {
    final companionSettingsNotifier =
        ref.read(companionServerProvider.notifier);

    companionSettingsNotifier.setStartOnLaunch();
    await Db.saveCompanionServerSettings(ref.read(companionServerProvider));
  }
}
