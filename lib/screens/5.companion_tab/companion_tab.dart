import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/server_utils.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final serverLogProvider = StateProvider<List<String>>((ref) => []);

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
              onPressed: () {
                if (isServerRunning) {
                  serverUtils.stop();
                } else {
                  serverUtils.startServer(ref);
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
            )
          ],
        ),
      ],
    );
  }
}
