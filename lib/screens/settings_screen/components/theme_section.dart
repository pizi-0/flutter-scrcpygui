import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/settings_provider.dart';
import 'package:scrcpygui/utils/app_utils.dart';
import 'package:scrcpygui/widgets/config_tiles.dart';

class ThemeSection extends ConsumerStatefulWidget {
  const ThemeSection({super.key});

  @override
  ConsumerState<ThemeSection> createState() => _ThemeSectionState();
}

class _ThemeSectionState extends ConsumerState<ThemeSection> {
  @override
  Widget build(BuildContext context) {
    final looks = ref.watch(settingsProvider.select((sett) => sett.looks));

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ConfigCustom(title: 'Looks', child: SizedBox()),
        Card(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ConfigCustom(
                childBackgroundColor: Colors.transparent,
                title: 'Theme mode',
                child: ComboBox(
                  value: looks.themeMode,
                  onChanged: (ThemeMode? mode) async {
                    ref.read(settingsProvider.notifier).changeThememode(mode!);
                    await AppUtils.saveAppSettings(ref.read(settingsProvider));
                  },
                  items: const [
                    ComboBoxItem(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                    ComboBoxItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    ComboBoxItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ConfigCustom(
                childBackgroundColor: Colors.transparent,
                title: 'Accent color',
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(FluentIcons.reset),
                      onPressed: () async {
                        ref
                            .read(settingsProvider.notifier)
                            .changeAccentColor(Colors.blue);

                        await AppUtils.saveAppSettings(
                            ref.read(settingsProvider));
                      },
                    ),
                    Button(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(looks.accentColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(looks.accentColor.hex.toUpperCase())
                            .textColor(looks.accentColor.basedOnLuminance()),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => ContentDialog(
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                colorSpectrumShape: ColorSpectrumShape.box,
                                isMoreButtonVisible: false,
                                isAlphaEnabled: false,
                                isAlphaSliderVisible: false,
                                isAlphaTextInputVisible: false,
                                isColorChannelTextInputVisible: false,
                                isColorPreviewVisible: false,
                                color: looks.accentColor,
                                onChanged: (color) async {
                                  ref
                                      .read(settingsProvider.notifier)
                                      .changeAccentColor(color.toAccentColor());

                                  await AppUtils.saveAppSettings(
                                      ref.read(settingsProvider));
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              ConfigCustom(
                childBackgroundColor: Colors.transparent,
                title: 'Tint level',
                child: Row(
                  children: [
                    Tooltip(
                      message: 'Default: 90',
                      child: IconButton(
                        icon: const Icon(FluentIcons.reset),
                        onPressed: () async {
                          ref
                              .read(settingsProvider.notifier)
                              .changeTintLevel(90);

                          await AppUtils.saveAppSettings(
                              ref.read(settingsProvider));
                        },
                      ),
                    ),
                    Slider(
                      min: 50,
                      value: looks.accentTintLevel,
                      label: looks.accentTintLevel.toStringAsFixed(0),
                      onChanged: (val) async {
                        ref
                            .read(settingsProvider.notifier)
                            .changeTintLevel(val);
                      },
                      onChangeEnd: (value) async {
                        await AppUtils.saveAppSettings(
                            ref.read(settingsProvider));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
