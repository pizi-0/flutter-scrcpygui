// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/adb_devices.dart';
import 'package:scrcpygui/models/result/wireless_connect_result.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/providers/toast_providers.dart';
import 'package:scrcpygui/utils/adb_utils.dart';
import 'package:scrcpygui/widgets/device_icon_hx.dart';
import 'package:scrcpygui/widgets/section_button.dart';
import 'package:scrcpygui/widgets/simple_toast/simple_toast_item.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:tray_manager/tray_manager.dart';

import '../providers/settings_provider.dart';
import '../utils/const.dart';
import '../utils/tray_utils.dart';
import 'device_icon.dart';

class ConnectedDevicesView extends ConsumerStatefulWidget {
  const ConnectedDevicesView({super.key});

  @override
  ConsumerState<ConnectedDevicesView> createState() =>
      _ConnectedDevicesViewState();
}

class _ConnectedDevicesViewState extends ConsumerState<ConnectedDevicesView> {
  Timer? t;
  bool wifiAdb = false;
  bool loading = false;
  bool error = false;
  double currentPage = 1;
  double currentWirelessPage = 0;

  PageController page = PageController(initialPage: 1);
  PageController wirelessPage = PageController(initialPage: 0);
  TextEditingController ip = TextEditingController(text: '192.168.');
  late AnimationController anim;

  @override
  void initState() {
    super.initState();
    ref.read(adbProvider.notifier).ref.listenSelf(
      (previous, next) async {
        if (!listEquals(previous, next)) {
          await trayManager.destroy();
          await TrayUtils.initTray(ref, context);
        }
      },
    );
  }

  @override
  void dispose() {
    t?.cancel();
    page.dispose();
    wirelessPage.dispose();
    ip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adbDevices = ref.watch(adbProvider);
    final wirelessHx = ref.watch(wirelessDevicesHistoryProvider);
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: SizedBox(
        height: 148,
        width: appWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildSectionTitle(),
                const Spacer(),
                _buildHxButton(wirelessHx),
                _buildWirelessConnectToggle(context)
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(appTheme.widgetRadius),
              child: Container(
                height: 108,
                width: appWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(appTheme.widgetRadius),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Stack(
                  children: [
                    PageView(
                      scrollDirection: Axis.vertical,
                      controller: page,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _connectWirelessDevicePage(context, wirelessHx),
                        _deviceListPage(ref, adbDevices, context),
                      ],
                    ),
                    if (loading)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.8),
                              borderRadius: BorderRadius.circular(
                                  appTheme.widgetRadius * 0.8),
                            ),
                            child: const Center(
                                child: CircularProgressIndicator())),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _connectWirelessDevicePage(BuildContext context, List<AdbDevices> hx) {
    final connected = ref.watch(adbProvider);
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: wirelessPage,
      children: [
        _enterIpPage(ref, context),
        _deviceHxPage(ref, context, hx, connected),
      ],
    );
  }

  Padding _deviceHxPage(WidgetRef ref, BuildContext context,
      List<AdbDevices> hx, List<AdbDevices> connected) {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(appTheme.widgetRadius * 0.8),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: SizedBox.expand(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: hx
                  .map(
                    (e) => DeviceHistoryIcon(
                        device: e,
                        hxOntap: () async {
                          ip.text = e.id;
                          error = false;
                          if (connected.where((d) => d.id == e.id).isEmpty) {
                            _connect();
                            await wirelessPage.previousPage(
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.linear);

                            currentWirelessPage = wirelessPage.page!;
                          } else {
                            await page.nextPage(
                              duration: 100.milliseconds,
                              curve: Curves.linear,
                            );

                            currentPage = page.page!;
                            currentWirelessPage = 0;
                          }

                          setState(() {});
                        }),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Padding _enterIpPage(WidgetRef ref, BuildContext context) {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(appTheme.widgetRadius * 0.8),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: Center(
          child: _enterIpTextBox(ref, context),
        ),
      ),
    );
  }

  Widget _buildWirelessConnectToggle(BuildContext context) {
    return SectionButton(
      tooltipmessage:
          currentPage == 0 ? 'Connected devices' : 'Connect wireless ADB',
      icondata: currentPage == 0 ? Icons.close : Icons.wifi_rounded,
      iconColor: currentPage == 0
          ? Colors.red
          : Theme.of(context).colorScheme.inverseSurface,
      ontap: () async {
        if (currentPage == 0) {
          await page.nextPage(
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        } else {
          await page.previousPage(
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }

        setState(() {
          currentPage = page.page!;
          currentWirelessPage = 0;
        });
      },
    );
  }

  Widget _buildSectionTitle() {
    String title = '';

    if (currentPage == 1) {
      title = 'Connected devices';
    }

    if (currentPage == 0 && currentWirelessPage == 0) {
      title = 'Connect wireless ADB';
    }

    if (currentPage == 0 && currentWirelessPage == 1) {
      title = 'Wireless device history';
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
      ),
    );
  }

  AnimatedSwitcher _deviceListPage(
      WidgetRef ref, List<AdbDevices> adbDevices, BuildContext context) {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final saved = ref.watch(savedAdbDevicesProvider);

    // print(
    //     "[Saved] Connected devices view: ${saved.map((s) => '${s.name}(${s.modelName})').toList()}");
    // print(
    //     "[Connected] Connected devices view: ${adbDevices.map((s) => s.modelName).toList()}");

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: adbDevices.isEmpty
          ? Container(
              margin: const EdgeInsets.all(4),
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius:
                    BorderRadius.circular(appTheme.widgetRadius * 0.8),
              ),
              child: const Center(child: Text('No ADB devices detected')),
            )
          : Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox.expand(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: adbDevices
                        .map((e) => DeviceIcon(
                              device: saved.firstWhere((d) => d.id == e.id,
                                  orElse: () => e),
                              key: ValueKey(e.id),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _enterIpTextBox(WidgetRef ref, BuildContext context) {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Tooltip(
            message:
                '1. Set static IP for easier connection.\n2. Port default to 5555 if not specifed.\n3. Auto listen to 5555 for new device on connect.',
            child: Icon(Icons.info),
          ),
          const SizedBox(width: 10),
          const Text('IP:Port: ').textColor(colorScheme.inverseSurface),
          ShakeX(
            controller: (p0) => anim = p0,
            duration: 200.milliseconds,
            curve: Curves.linear,
            from: 5,
            manualTrigger: true,
            child: Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(appTheme.widgetRadius * 0.8),
                color: colorScheme.primaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextField(
                    cursorColor: colorScheme.inverseSurface,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.:]")),
                    ],
                    controller: ip,
                    onSubmitted: (t) async {
                      if (t.isIpv4) {
                        await _connect();
                      } else {
                        anim.reset();
                        anim.forward();
                      }
                    },
                    onChanged: (a) {
                      setState(() => error = false);
                    },
                    style: TextStyle(
                        fontSize: 14, color: colorScheme.inverseSurface),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration.collapsed(hintText: ''),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          error
              ? const Tooltip(
                  message: 'Failed to connect',
                  child: Icon(Icons.error_rounded, color: Colors.redAccent),
                )
              : SectionButton(
                  ontap: _connect,
                  icondata: Icons.send_rounded,
                )
        ],
      ),
    );
  }

  Widget _buildHxButton(List<AdbDevices> hx) {
    if (hx.isNotEmpty) {
      return SectionButton(
        tooltipmessage: currentWirelessPage == 1
            ? 'Connect wireless ADB'
            : 'Wireless device history',
        icondata: currentWirelessPage == 1
            ? Icons.arrow_back_rounded
            : Icons.history_rounded,
        ontap: () async {
          if (currentWirelessPage == 0.0) {
            await page.animateToPage(
              0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
            );
            await wirelessPage.nextPage(
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
            );
          } else {
            await wirelessPage.previousPage(
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
            );
          }

          setState(() {
            currentPage = page.page!;
            currentWirelessPage = wirelessPage.page!;
          });
        },
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _connect() async {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));

    setState(() {
      loading = true;
    });
    WiFiResult wiFiResult = await AdbUtils.connectWifiDebugging(ip: ip.text);
    error = !wiFiResult.success;
    String message = wiFiResult.errorMessage;

    if (error == false) {
      await AdbUtils.saveWirelessDeviceHistory(ref, ip.text);
      final toConnect = _getLatestConnectedDevice();
      ref.read(selectedDeviceProvider.notifier).state = ref
          .read(savedAdbDevicesProvider)
          .firstWhere((sav) => sav.id == toConnect.id, orElse: () => toConnect);
      await page.animateToPage(
        1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );

      setState(() {
        currentPage = 1;
        ip.text = '192.168.';
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      if (message.contains('authenticate')) {
        bool done = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(appTheme.widgetRadius)),
                  title: const Text('Check your phone'),
                  content: const Text('Allow debugging.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Done'),
                    )
                  ],
                );
              },
            ) ??
            false;

        if (done) {
          setState(() {
            error = false;
          });
          await _connect();
        } else {
          ref.read(toastProvider.notifier).addToast(
                SimpleToastItem(
                  message: message.capitalizeFirst.trim(),
                  toastStyle: SimpleToastStyle.error,
                  key: UniqueKey(),
                ),
              );
        }
      } else {
        ref.read(toastProvider.notifier).addToast(
              SimpleToastItem(
                message: message.capitalizeFirst.trim(),
                toastStyle: SimpleToastStyle.error,
                key: UniqueKey(),
              ),
            );
      }
    }
  }

  AdbDevices _getLatestConnectedDevice() {
    return ref.read(adbProvider).firstWhere((d) {
      if (!ip.text.contains(':')) {
        return d.id == ip.text.append(':5555');
      } else if (d.id.contains(':5555')) {
        return d.id == ip.text.replaceAll(RegExp(r':\d+$'), ':5555');
      } else {
        return d.id == ip.text;
      }
    });
  }
}
