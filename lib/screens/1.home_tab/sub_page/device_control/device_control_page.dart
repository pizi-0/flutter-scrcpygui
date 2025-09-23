import 'package:awesome_extensions/awesome_extensions.dart' show NumExtension;
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scrcpygui/providers/adb_provider.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../providers/device_info_provider.dart';
import 'widgets/big_control_page.dart';
import 'widgets/small_control_page.dart';

final FocusNode controlPageKeyboardListenerNode =
    FocusNode(debugLabel: 'keyboard-listener');

class DeviceControlPage extends ConsumerStatefulWidget {
  static const route = 'device-control';

  const DeviceControlPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeviceControlPageState();
}

class _DeviceControlPageState extends ConsumerState<DeviceControlPage> {
  @override
  Widget build(BuildContext context) {
    final device = ref.watch(selectedDeviceProvider);

    if (device == null) {
      return PgScaffoldCustom(
          onBack: context.pop,
          scaffoldBody: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Text('Device disconnected').small().muted(),
              PrimaryButton(
                onPressed: context.pop,
                child: Text(el.buttonLabelLoc.close),
              )
            ],
          ),
          title: Text('Device disconnected').bold().xLarge());
    }

    return KeyboardListener(
      focusNode: controlPageKeyboardListenerNode,
      autofocus: true,
      onKeyEvent: (value) async {
        if (value.physicalKey == PhysicalKeyboardKey.slash) {
          if (!searchBoxFocusNode.hasFocus) {
            await Future.delayed(10.milliseconds);
            searchBoxFocusNode.requestFocus();
          }
        }

        if (value.physicalKey == PhysicalKeyboardKey.escape) {
          controlPageKeyboardListenerNode.requestFocus();
        }
      },
      child: GestureDetector(
        onTap: () => controlPageKeyboardListenerNode.requestFocus(),
        child: PgScaffoldCustom(
            onBack: context.pop,
            title: LoungeTItle(),
            scaffoldBody: ResponsiveBuilder(
              builder: (context, sizingInfo) {
                return AnimatedSwitcher(
                  duration: 200.milliseconds,
                  child: sizingInfo.isMobile || sizingInfo.isTablet
                      ? SmallControlPage(device: device)
                      : BigControlPage2(device: device),
                );
              },
            )),
      ),
    );
  }
}

class LoungeTItle extends ConsumerWidget {
  const LoungeTItle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(selectedDeviceProvider)!;
    final connected = ref.watch(adbProvider);

    final deviceInfo = ref
        .watch(infoProvider)
        .firstWhereOrNull((info) => info.serialNo == device.serialNo);

    return Row(
      spacing: 8,
      children: [
        Text('Lounge').bold.xLarge,
        Text('/'),
        if (connected.length > 1) ...[
          Select(
            filled: true,
            onChanged: (value) {
              ref.read(selectedDeviceProvider.notifier).state = value;
            },
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            value: device,
            popupWidthConstraint: PopoverConstraint.intrinsic,
            popup: SelectPopup.noVirtualization(
              items: SelectItemList(
                  children: connected.map((e) {
                final info = ref.read(infoProvider).firstWhereOrNull(
                      (info) => info.serialNo == e.serialNo,
                    );

                return SelectItemButton(
                  value: e,
                  child: Basic(
                    leading: isWireless(e.id)
                        ? Icon(Icons.wifi_rounded).iconSmall()
                        : Icon(Icons.usb_rounded).iconSmall(),
                    title: Text(info?.deviceName ?? e.modelName),
                    leadingAlignment: AlignmentGeometry.center,
                    subtitle: Text(e.id),
                  ),
                );
              }).toList()),
            ).call,
            itemBuilder: (context, dev) {
              final info = ref.read(infoProvider).firstWhereOrNull(
                    (info) => info.serialNo == dev.serialNo,
                  );
              return Row(
                spacing: 4,
                children: [
                  isWireless(dev.id)
                      ? Icon(Icons.wifi_rounded)
                      : Icon(Icons.usb_rounded),
                  Text(
                    info?.deviceName ?? dev.modelName,
                    overflow: TextOverflow.ellipsis,
                  ).bold.xLarge,
                ],
              );
            },
          ),
        ] else ...[
          Row(
            spacing: 4,
            children: [
              isWireless(device.id)
                  ? Icon(Icons.wifi_rounded)
                  : Icon(Icons.usb_rounded),
              Text(deviceInfo?.deviceName ?? device.modelName).bold.xLarge,
            ],
          )
        ]
      ],
    );
  }
}
