import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_extensions/string_extensions.dart';

import 'package:pg_scrcpy/models/scrcpy_related/scrcpy_enum.dart';

const double _minWidth = 100;

class ConfigDropdownEnum<T extends StringEnum> extends StatelessWidget {
  final List<T> items;
  final String label;
  final T? initialValue;
  final ValueChanged<T?>? onSelected;
  final bool toTitleCase;

  const ConfigDropdownEnum({
    super.key,
    required this.items,
    required this.label,
    this.initialValue,
    this.onSelected,
    this.toTitleCase = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(6),
      ),
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          children: [
            const SizedBox(width: 5),
            Expanded(
                child: Text(
              label.toTitleCase,
              style: Theme.of(context).textTheme.bodyMedium,
            )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: _minWidth),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton(
                        borderRadius: BorderRadius.circular(6),
                        style: Theme.of(context).textTheme.bodyMedium,
                        focusColor: Theme.of(context).colorScheme.onPrimary,
                        value: initialValue,
                        onChanged: onSelected,
                        items: items
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(toTitleCase
                                      ? e.value.toString().toTitleCase
                                      : e.value.toString()),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfigDropdownOthers extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final String label;
  final Object? initialValue;
  final ValueChanged? onSelected;
  final String? tooltipMessage;

  const ConfigDropdownOthers({
    super.key,
    required this.items,
    required this.label,
    this.initialValue,
    this.onSelected,
    this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(6),
      ),
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          children: [
            const SizedBox(width: 5),
            Expanded(
                child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            )),
            if (onSelected == null)
              Tooltip(
                message: tooltipMessage ?? '',
                preferBelow: false,
                child: const Icon(Icons.info, size: 20),
              ),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: _minWidth),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<dynamic>(
                        style: Theme.of(context).textTheme.bodyMedium,
                        value: initialValue,
                        onChanged: onSelected,
                        items: items,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfigUserInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String unit;
  final ValueChanged<String> onChanged;
  final Function()? onTap;

  const ConfigUserInput({
    super.key,
    required this.label,
    required this.controller,
    required this.unit,
    required this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(6),
      ),
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          children: [
            const SizedBox(width: 5),
            Expanded(
                child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: _minWidth,
                  maxWidth: _minWidth,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textAlign: TextAlign.center,
                            controller: controller,
                            decoration:
                                const InputDecoration.collapsed(hintText: ''),
                            onChanged: onChanged,
                            onTap: onTap,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(unit,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfigCustom extends StatelessWidget {
  final String label;
  final Widget child;
  final BoxConstraints? boxConstraints;
  final Color? childBackgroundColor;

  const ConfigCustom({
    super.key,
    required this.label,
    required this.child,
    this.boxConstraints,
    this.childBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(6),
      ),
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          children: [
            const SizedBox(width: 5),
            Expanded(
                flex: 4,
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ConstrainedBox(
                constraints:
                    boxConstraints ?? const BoxConstraints(minWidth: _minWidth),
                child: Container(
                  decoration: BoxDecoration(
                    color: childBackgroundColor ??
                        Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
