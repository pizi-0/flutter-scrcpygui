// ignore_for_file: use_build_context_synchronously

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/utils/extension.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutTab extends ConsumerStatefulWidget {
  static const String route = '/about';
  const AboutTab({super.key});

  @override
  ConsumerState<AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends ConsumerState<AboutTab> {
  String? latest;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLatest();
    });
  }

  Future<void> _getLatest() async {
    loading = true;
    setState(() {});

    final current = ref.read(appVersionProvider);

    try {
      latest = await AppUtils.getLatestAppVersion();

      if (latest!.parseVersionToInt()! > current.parseVersionToInt()!) {
        showToast(
          context: context,
          showDuration: 1.5.seconds,
          location: ToastLocation.bottomCenter,
          builder: (context, overlay) => SurfaceCard(
            child: Basic(
              title: Text(el.scrcpyManagerLoc.updater.label),
              trailing: Icon(Icons.new_releases_outlined, color: Colors.lime),
            ),
          ),
        );
      } else {
        showToast(
          context: context,
          showDuration: 1.5.seconds,
          location: ToastLocation.bottomCenter,
          builder: (context, overlay) => SurfaceCard(
            child: Basic(
              title: Text(el.scrcpyManagerLoc.infoPopup.noUpdate),
              trailing:
                  Icon(Icons.check_circle_outline_rounded, color: Colors.lime),
            ),
          ),
        );
      }
    } on Exception catch (_) {
      loading = false;
      setState(() {});

      showToast(
        context: context,
        showDuration: 1.5.seconds,
        location: ToastLocation.bottomCenter,
        builder: (context, overlay) => SurfaceCard(
          child: Basic(
            title: Text(el.scrcpyManagerLoc.infoPopup.error),
            trailing: Icon(Icons.error_outline_rounded, color: Colors.red),
          ),
        ),
      );
    }

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(settingsProvider.select((sett) => sett.behaviour.languageCode));
    final appversion = ref.watch(appVersionProvider);

    return PgScaffold(
      title: el.aboutLoc.title,
      appBarTrailing: [
        IconButton.ghost(
          icon: loading
              ? const CircularProgressIndicator(size: 20)
              : const Icon(Icons.refresh),
          onPressed: _getLatest,
        ),
      ],
      children: [
        if (latest != null &&
            latest!.parseVersionToInt()! > appversion.parseVersionToInt()!)
          PgSectionCard(
            label: el.scrcpyManagerLoc.updater.newVersion,
            children: [
              ConfigCustom(
                dimTitle: false,
                title: el.buttonLabelLoc.update,
                child: OutlineButton(
                  trailing: Icon(Icons.open_in_new),
                  child: Text('Github'),
                  onPressed: () => launchUrl(Uri.parse('$guiGit/releases')),
                ),
              ),
            ],
          ),
        PgSectionCard(
          label: 'Scrcpy GUI',
          children: [
            Basic(
              leading: Image.asset('assets/logo.png', height: 100),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text('${el.aboutLoc.version}: $appversion'),
                  Text('${el.aboutLoc.author}: pizi-0'),
                ],
              ),
              content: Row(
                spacing: 4,
                children: [
                  Tooltip(
                    tooltip: (context) => TooltipContainer(
                      child: Text(guiGit),
                    ),
                    child: Button.outline(
                      onPressed: () {
                        launchUrl(Uri.parse(guiGit));
                      },
                      leading: Icon(BootstrapIcons.github).iconXSmall(),
                      child: Text('Github'),
                    ),
                  ),
                  Tooltip(
                    tooltip: (context) =>
                        TooltipContainer(child: Text(guiDiscord)),
                    child: Button.outline(
                      onPressed: () => launchUrl(Uri.parse(guiDiscord)),
                      leading: Icon(BootstrapIcons.discord).iconXSmall(),
                      child: Text('Discord'),
                    ),
                  ),
                ],
              ).paddingOnly(top: 8),
            )
          ],
        ),
        PgSectionCard(
          label: el.aboutLoc.credits,
          children: [
            Basic(
              title: Text('scrcpy'),
              trailing: Tooltip(
                tooltip: (context) => TooltipContainer(child: Text(scrcpyGit)),
                child: Button.outline(
                  onPressed: () {
                    launchUrl(Uri.parse(scrcpyGit));
                  },
                  leading: Icon(BootstrapIcons.github).iconXSmall(),
                  child: Text('Github'),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

const String guiGit = 'https://github.com/pizi-0/flutter-scrcpygui';
const String guiDiscord = 'https://discord.gg/ZdV5DAxd8Y';
const String scrcpyGit = 'https://github.com/Genymobile/scrcpy';
