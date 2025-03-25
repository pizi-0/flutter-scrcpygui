import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/providers/version_provider.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_scaffold.dart';
import 'package:scrcpygui/widgets/custom_ui/pg_section_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutTab extends ConsumerWidget {
  static const String route = '/about';
  const AboutTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appversion = ref.watch(appVersionProvider);
    return PgScaffold(
      title: el.aboutLoc.title,
      children: [
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
                      leading: Icon(FontAwesomeIcons.github).iconXSmall(),
                      child: Text('Github'),
                    ),
                  ),
                  // Tooltip(
                  //   tooltip: (context) => TooltipContainer(child: Text('wip')),
                  //   child: Button.outline(
                  //     onPressed: null,
                  //     leading: Icon(FontAwesomeIcons.discord).iconXSmall(),
                  //     child: Text('Discord'),
                  //   ),
                  // ),
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
                  leading: Icon(FontAwesomeIcons.github).iconXSmall(),
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
const String scrcpyGit = 'https://github.com/Genymobile/scrcpy';
