import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';

class ConfigDropdownEnum<T extends StringEnum> extends ConsumerWidget {
  final List<T> items;
  final String title;
  final String? subtitle;

  final T? initialValue;
  final ValueChanged<T?>? onSelected;
  final bool toTitleCase;

  const ConfigDropdownEnum({
    super.key,
    required this.items,
    required this.title,
    this.subtitle,
    this.initialValue,
    this.onSelected,
    this.toTitleCase = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = FluentTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          title: Text(title).textStyle(theme.typography.body),
          trailing: ComboBox(
            value: initialValue,
            onChanged: onSelected,
            items: items
                .map((e) => ComboBoxItem(
                    value: e,
                    child: Text(toTitleCase
                        ? e.value.toString().toTitleCase
                        : e.value.toString())))
                .toList(),
          ),
        ),
        if (subtitle != null)
          Card(
            margin: const EdgeInsets.fromLTRB(16, 0, 14, 10),
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 4, 2),
              child: Row(
                spacing: 8,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      FluentIcons.info,
                      size: theme.typography.caption!.fontSize! - 2,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$subtitle',
                      style: theme.typography.caption!.copyWith(
                          color:
                              theme.typography.caption!.color!.withAlpha(150)),
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}

class ConfigDropdownOthers extends ConsumerWidget {
  final List<ComboBoxItem> items;
  final String label;
  final String? subtitle;
  final Widget? placeholder;
  final Object? initialValue;
  final ValueChanged? onSelected;
  final String? tooltipMessage;

  const ConfigDropdownOthers({
    super.key,
    required this.items,
    required this.label,
    this.placeholder,
    this.subtitle,
    this.initialValue,
    this.onSelected,
    this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = FluentTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          title: Text(label).textStyle(theme.typography.body),
          trailing: ComboBox(
            placeholder: placeholder,
            value: initialValue,
            onChanged: onSelected,
            items: items,
          ),
        ),
        if (subtitle != null)
          Card(
            margin: const EdgeInsets.fromLTRB(16, 0, 14, 10),
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 4, 2),
              child: Row(
                spacing: 8,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      FluentIcons.info,
                      size: theme.typography.caption!.fontSize! - 2,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$subtitle',
                      style: theme.typography.caption!.copyWith(
                          color:
                              theme.typography.caption!.color!.withAlpha(150)),
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}

class ConfigUserInput extends ConsumerWidget {
  final String label;
  final String? subtitle;
  final TextEditingController controller;
  final String? unit;
  final ValueChanged<String> onChanged;
  final Function()? onTap;

  const ConfigUserInput({
    super.key,
    required this.label,
    required this.controller,
    this.subtitle,
    this.unit,
    required this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = FluentTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          title: Text(label).textStyle(theme.typography.body),
          trailing: SizedBox(
            width: 100,
            child: TextBox(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              suffix: Text(unit != null ? '$unit ' : ''),
              textAlign: TextAlign.center,
              controller: controller,
              onChanged: onChanged,
              onTap: onTap,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        if (subtitle != null)
          Card(
            margin: const EdgeInsets.fromLTRB(16, 0, 14, 10),
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 4, 2),
              child: Row(
                spacing: 8,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      FluentIcons.info,
                      size: theme.typography.caption!.fontSize! - 2,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$subtitle',
                      style: theme.typography.caption!.copyWith(
                          color:
                              theme.typography.caption!.color!.withAlpha(150)),
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}

class ConfigCustom extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final BoxConstraints? boxConstraints;
  final Color? childBackgroundColor;
  final double? padRight;

  const ConfigCustom({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.boxConstraints,
    this.childBackgroundColor,
    this.padRight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = FluentTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          title: Text(title).textStyle(theme.typography.body),
          trailing: child,
        ),
        if (subtitle != null)
          Card(
            margin: const EdgeInsets.fromLTRB(16, 0, 14, 10),
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 4, 2),
              child: Row(
                spacing: 8,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      FluentIcons.info,
                      size: theme.typography.caption!.fontSize! - 2,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$subtitle',
                      style: theme.typography.caption!.copyWith(
                          color:
                              theme.typography.caption!.color!.withAlpha(150)),
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
