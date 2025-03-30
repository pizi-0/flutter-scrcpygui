import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:string_extensions/string_extensions.dart';

import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';

import 'custom_ui/pg_list_tile.dart';

class ConfigDropdownEnum<T extends StringEnum> extends ConsumerWidget {
  final List<T> items;
  final String title;
  final String? subtitle;
  final bool showinfo;
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
    this.showinfo = false,
    this.toTitleCase = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PgListTile(
      title: title,
      subtitle: subtitle,
      showSubtitle: subtitle != null && showinfo,
      trailing: ConstrainedBox(
        constraints:
            const BoxConstraints(minWidth: 180, maxWidth: 180, minHeight: 30),
        child: Select(
          filled: true,
          itemBuilder: (context, value) => OverflowMarquee(
              child: Text(toTitleCase ? value.value.toTitleCase : value.value)),
          value: initialValue,
          onChanged: onSelected,
          popup: SelectPopup(
              items: SelectItemList(
            children: items
                .map((e) => SelectItemButton(
                    value: e,
                    child: OverflowMarquee(
                      child: Text(toTitleCase
                          ? e.value.toString().toTitleCase
                          : e.value.toString()),
                    )))
                .toList(),
          )).call,
        ),
      ),
    );
  }
}

class ConfigDropdownOthers extends StatefulWidget {
  final List<Widget> items;
  final String label;
  final String? subtitle;
  final Widget? placeholder;
  final Object? initialValue;
  final PopoverConstraint? popupWidthConstraint;
  final ValueChanged? onSelected;
  final String? tooltipMessage;
  final bool showinfo;
  final SelectValueBuilder? itemBuilder;

  const ConfigDropdownOthers({
    super.key,
    required this.items,
    required this.label,
    this.showinfo = false,
    this.placeholder,
    this.subtitle,
    this.initialValue,
    this.onSelected,
    this.tooltipMessage,
    this.popupWidthConstraint,
    this.itemBuilder,
  });

  @override
  State<ConfigDropdownOthers> createState() => _ConfigDropdownOthersState();
}

class _ConfigDropdownOthersState extends State<ConfigDropdownOthers> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PgListTile(
          title: widget.label,
          subtitle: widget.subtitle,
          showSubtitle: widget.subtitle != null && widget.showinfo,
          trailing: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 180, maxWidth: 180, minHeight: 30),
            child: Select(
              filled: true,
              itemBuilder: widget.itemBuilder ??
                  (context, value) => OverflowMarquee(
                        duration: 2.seconds,
                        delayDuration: 1.seconds,
                        child: Text(value.toString()),
                      ),
              placeholder: widget.placeholder,
              value: widget.initialValue,
              onChanged: widget.onSelected,
              popupWidthConstraint: widget.popupWidthConstraint ??
                  PopoverConstraint.anchorFixedSize,
              popupConstraints: const BoxConstraints(maxWidth: 300),
              popup: SelectPopup.noVirtualization(
                items: SelectItemList(
                  children: widget.items,
                ),
              ).call,
            ),
          ),
        ),
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
  final bool showinfo;
  final Widget? placeholder;
  final List<TextInputFormatter>? inputFormatters;

  const ConfigUserInput({
    super.key,
    required this.label,
    this.showinfo = false,
    required this.controller,
    this.subtitle,
    this.unit,
    required this.onChanged,
    this.onTap,
    this.placeholder,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PgListTile(
      title: label,
      subtitle: subtitle,
      showSubtitle: subtitle != null && showinfo,
      trailing: ConstrainedBox(
        constraints:
            const BoxConstraints(minWidth: 180, maxWidth: 180, minHeight: 30),
        child: TextField(
          placeholder: placeholder,
          filled: true,
          inputFormatters: inputFormatters ??
              [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
          trailing: Text(unit != null ? '$unit ' : '').xSmall(),
          textAlign: TextAlign.center,
          controller: controller,
          onChanged: onChanged,
          onTap: onTap,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

class ConfigCustom extends ConsumerWidget {
  final String title;
  final bool? dimTitle;
  final String? subtitle;
  final Widget? child;
  final bool childExpand;
  final BoxConstraints? boxConstraints;
  final Color? childBackgroundColor;
  final double? padRight;
  final bool showinfo;
  final Function()? onPressed;

  const ConfigCustom({
    super.key,
    required this.title,
    this.dimTitle,
    this.childExpand = true,
    this.child,
    this.subtitle,
    this.showinfo = false,
    this.boxConstraints,
    this.childBackgroundColor,
    this.padRight,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      cursor: onPressed == null ? MouseCursor.defer : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          color: Colors.transparent,
          child: PgListTile(
            title: title,
            dimTitle: dimTitle ?? onPressed == null,
            trailing: child != null
                ? ConstrainedBox(
                    constraints: const BoxConstraints(
                        minWidth: 180, maxWidth: 180, minHeight: 30),
                    child: Padding(
                      padding: EdgeInsets.only(right: padRight ?? 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!childExpand) child!,
                          if (childExpand) Expanded(child: child!)
                        ],
                      ),
                    ),
                  )
                : null,
            subtitle: subtitle,
            showSubtitle: subtitle != null && showinfo,
          ),
        ),
      ),
    );
  }
}
