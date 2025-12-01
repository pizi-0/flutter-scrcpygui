import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:scrcpygui/db/db.dart';
import 'package:scrcpygui/utils/const.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../providers/settings_provider.dart';

class IconExtractorDisclaimerDialog extends ConsumerStatefulWidget {
  const IconExtractorDisclaimerDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IconExtractorDisclaimerDialogState();
}

class _IconExtractorDisclaimerDialogState
    extends ConsumerState<IconExtractorDisclaimerDialog> {
  @override
  Widget build(BuildContext context) {
    final hideDisclaimer = ref.watch(settingsProvider
        .select((s) => s.behaviour.hideIconExtractorDisclaimer));

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: sectionWidth),
      child: AlertDialog(
        title: Text('Disclaimer'),
        content: OutlinedContainer(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text('This is an experimental feature, with sets of limitations:')
                  .bold,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- '),
                  Expanded(
                    child: Text(
                        'Pulling apk can take a long time, depending on the size of the apk.'),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- '),
                  Expanded(
                    child: Text(
                        'Adaptive icons is not supported, resulting in missing icons.'),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- '),
                  Expanded(
                    child: Text('Extracted icons may be of lower resolution.'),
                  ),
                ],
              ),
              Gap(10),
              Row(
                children: [
                  Tooltip(
                    tooltip: TooltipContainer(
                            child: Text('https://github.com/pizi-0/e.i.f.a'))
                        .call,
                    child: LinkButton(
                      density: ButtonDensity.compact,
                      onPressed: () => launchUrl(
                          Uri.parse('https://github.com/pizi-0/e.i.f.a')),
                      leading: Icon(BootstrapIcons.github).iconXSmall(),
                      child: Text('Icon extractor (e.i.f.a) repo'),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        actions: [
          Checkbox(
            state: hideDisclaimer
                ? CheckboxState.checked
                : CheckboxState.unchecked,
            leading: Text(el.buttonLabelLoc.dontShowAgain).muted,
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .changeHideIconExtractorDisclaimer();
              Db.saveAppSettings(ref.read(settingsProvider));
            },
          ),
          Spacer(),
          PrimaryButton(
            onPressed: () {
              context.pop(true);
            },
            child: Text(el.buttonLabelLoc.ok),
          ),
          SecondaryButton(
            child: Text(el.buttonLabelLoc.cancel),
            onPressed: () {
              context.pop(false);
            },
          ),
        ],
      ),
    );
  }
}
