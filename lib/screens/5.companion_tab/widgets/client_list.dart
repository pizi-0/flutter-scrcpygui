import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/models/companion_server/authenticated_client.dart';
import 'package:scrcpygui/models/companion_server/server_payload.dart';
import 'package:scrcpygui/providers/companion_server_state_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../db/db.dart';
import '../../../models/companion_server/data/error_payload.dart';
import '../../../providers/server_settings_provider.dart';
import '../../../widgets/custom_ui/pg_list_tile.dart';
import '../../../widgets/custom_ui/pg_section_card.dart';

class ClientList extends ConsumerStatefulWidget {
  final bool expandContent;
  const ClientList({super.key, this.expandContent = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClientListState();
}

class _ClientListState extends ConsumerState<ClientList> {
  bool showBlocked = false;

  @override
  Widget build(BuildContext context) {
    final companionSettings = ref.watch(companionServerProvider);
    final serverState = ref.watch(companionServerStateProvider);
    final clients = serverState.clients;
    final blocked = companionSettings.blocklist;

    return PgSectionCardNoScroll(
      label: showBlocked
          ? el.companionLoc.client.blocked(count: '${blocked.length}')
          : el.companionLoc.client.clients(count: '${clients.length}'),
      labelTrail: Toggle(
        style: ButtonStyle.ghost(density: ButtonDensity.dense),
        value: showBlocked,
        child: showBlocked
            ? Row(
                spacing: 4,
                children: [
                  Icon(Icons.link_rounded).iconSmall(),
                  Text(el.companionLoc.client
                      .clients(count: '${clients.length}'))
                ],
              )
            : Row(
                spacing: 4,
                children: [
                  Icon(Icons.block_rounded).iconSmall(),
                  Text(el.companionLoc.client
                      .blocked(count: '${blocked.length}'))
                ],
              ),
        onChanged: (value) => setState(() {
          showBlocked = value;
        }),
      ),
      expandContent: widget.expandContent,
      content: widget.expandContent
          ? ClientListBig(showBlocked: showBlocked)
          : ClientListSmall(showBlocked: showBlocked),
    );
  }
}

class ClientListSmall extends ConsumerWidget {
  final bool showBlocked;
  const ClientListSmall({super.key, this.showBlocked = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companionSettings = ref.watch(companionServerProvider);
    final serverState = ref.watch(companionServerStateProvider);
    final clients = serverState.clients;

    return Column(
      children: showBlocked
          ? [
              if (companionSettings.blocklist.isNotEmpty)
                ...companionSettings.blocklist.mapIndexed(
                  (idx, blocked) => FadeIn(
                    duration: 100.milliseconds,
                    child: Column(
                      spacing: 8,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            Expanded(
                              child: PgListTile(
                                title:
                                    '${blocked.deviceName} / ${blocked.deviceModel}',
                                subtitle: blocked.clientAddress,
                                showSubtitle: true,
                                showSubtitleLeading: false,
                              ),
                            ),
                            Tooltip(
                              tooltip:
                                  TooltipContainer(child: Text('Unblock')).call,
                              child: IconButton.ghost(
                                icon: Icon(Icons.delete_rounded),
                                onPressed: () async {
                                  ref
                                      .read(companionServerProvider.notifier)
                                      .removeFromBlocklist(blocked);

                                  await Db.saveCompanionServerSettings(
                                      ref.read(companionServerProvider));
                                },
                              ),
                            ),
                          ],
                        ),
                        if (idx != companionSettings.blocklist.length - 1)
                          Divider()
                      ],
                    ),
                  ),
                )
              else
                FadeIn(
                    duration: 100.milliseconds,
                    child: Center(
                        child: Text(el.companionLoc.client.noBlocked)
                            .textSmall
                            .muted))
            ]
          : [
              if (clients.isNotEmpty)
                ...clients.mapIndexed(
                  (idx, authd) => FadeIn(
                    duration: 100.milliseconds,
                    child: Column(
                      spacing: 8,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            Expanded(
                              child: PgListTile(
                                title:
                                    '${authd.authPayload.deviceName} / ${authd.authPayload.deviceModel}',
                                subtitle: authd.socket.remoteAddress.address,
                                showSubtitle: true,
                                showSubtitleLeading: false,
                              ),
                            ),
                            Tooltip(
                              tooltip:
                                  TooltipContainer(child: Text('Block')).call,
                              child: IconButton.ghost(
                                icon: Icon(Icons.block),
                                onPressed: () async {
                                  authd.socket.write(
                                    '${ServerPayload(type: ServerPayloadType.error, payload: ErrorPayload(type: ErrorType.blocked, message: 'You have been blocked.').toJson()).toJson()}\n',
                                  );
                                  await authd.socket.close();
                                  ref
                                      .read(companionServerProvider.notifier)
                                      .addToBlocklist(
                                        BlockedClient(
                                          clientAddress: authd.clientAddress,
                                          deviceName:
                                              authd.authPayload.deviceName,
                                          deviceModel:
                                              authd.authPayload.deviceModel,
                                        ),
                                      );

                                  await Db.saveCompanionServerSettings(
                                      ref.read(companionServerProvider));
                                },
                              ),
                            ),
                          ],
                        ),
                        if (idx != clients.length - 1) Divider()
                      ],
                    ),
                  ),
                )
              else
                FadeIn(
                    duration: 100.milliseconds,
                    child: Center(
                        child: Text(el.companionLoc.client.noClient)
                            .textSmall
                            .muted))
            ],
    );
  }
}

class ClientListBig extends ConsumerWidget {
  final bool showBlocked;
  const ClientListBig({super.key, this.showBlocked = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSwitcher(
      duration: 200.milliseconds,
      child: showBlocked ? BlockedList() : ConnectedList(),
    );
  }
}

class BlockedList extends ConsumerWidget {
  const BlockedList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companionSettings = ref.watch(companionServerProvider);

    return CustomScrollView(
      slivers: [
        if (companionSettings.blocklist.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Text(el.companionLoc.client.noBlocked).textSmall.muted,
            ),
          )
        else
          SliverList.builder(
            itemCount: companionSettings.blocklist.length,
            itemBuilder: (context, index) {
              final blocked = companionSettings.blocklist[index];
              return Column(
                spacing: 8,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: PgListTile(
                          title:
                              '${blocked.deviceName} / ${blocked.deviceModel}',
                          subtitle: blocked.clientAddress,
                          showSubtitle: true,
                          showSubtitleLeading: false,
                        ),
                      ),
                      Tooltip(
                        tooltip: TooltipContainer(child: Text('Unblock')).call,
                        child: IconButton.ghost(
                          icon: Icon(Icons.delete_rounded),
                          onPressed: () async {
                            ref
                                .read(companionServerProvider.notifier)
                                .removeFromBlocklist(blocked);

                            await Db.saveCompanionServerSettings(
                                ref.read(companionServerProvider));
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider()
                ],
              );
            },
          )
      ],
    );
  }
}

class ConnectedList extends ConsumerWidget {
  const ConnectedList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverState = ref.watch(companionServerStateProvider);
    final clients = serverState.clients;
    return CustomScrollView(
      slivers: [
        if (clients.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Text(el.companionLoc.client.noClient).textSmall.muted,
            ),
          )
        else
          SliverList.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final authd = clients[index];
              return Column(
                spacing: 8,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: PgListTile(
                          title:
                              '${authd.authPayload.deviceName} / ${authd.authPayload.deviceModel}',
                          subtitle: authd.socket.remoteAddress.address,
                          showSubtitle: true,
                          showSubtitleLeading: false,
                        ),
                      ),
                      Tooltip(
                        tooltip: TooltipContainer(child: Text('Block')).call,
                        child: IconButton.ghost(
                          icon: Icon(Icons.block),
                          onPressed: () async {
                            authd.socket.write(
                              '${ServerPayload(type: ServerPayloadType.error, payload: ErrorPayload(type: ErrorType.blocked, message: 'You have been blocked.').toJson()).toJson()}\n',
                            );
                            await authd.socket.close();
                            ref
                                .read(companionServerProvider.notifier)
                                .addToBlocklist(
                                  BlockedClient(
                                    clientAddress: authd.clientAddress,
                                    deviceName: authd.authPayload.deviceName,
                                    deviceModel: authd.authPayload.deviceModel,
                                  ),
                                );

                            await Db.saveCompanionServerSettings(
                                ref.read(companionServerProvider));
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider()
                ],
              );
            },
          )
      ],
    );
  }
}
