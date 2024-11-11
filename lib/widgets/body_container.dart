// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

class BodyContainer extends ConsumerWidget {
  final List<Widget> children;
  final String? headerTitle;
  final Widget? headerTrailing;
  final double? height;
  const BodyContainer({
    super.key,
    required this.children,
    this.headerTitle,
    this.headerTrailing,
    this.height,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (headerTitle != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    headerTitle!,
                    style: context.textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.inverseSurface),
                  ),
                  if (headerTrailing != null) headerTrailing!,
                ],
              ),
            ),
          AnimatedContainer(
            duration: 200.milliseconds,
            width: double.maxFinite,
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(appTheme.widgetRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: children,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BodyContainerItem extends ConsumerWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  const BodyContainerItem({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: 200.milliseconds,
      height: 50,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(appTheme.widgetRadius * 0.85),
      ),
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          if (leading != null) leading!,
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title).textColor(colorScheme.inverseSurface),
          )),
          if (trailing != null)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 150),
              child: trailing!,
            )
        ],
      ),
    );
  }
}

class AddAutomationActions extends ConsumerWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget>? children;
  const AddAutomationActions({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.children,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(settingsProvider.select((s) => s.looks));
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: 200.milliseconds,
      constraints: const BoxConstraints(minHeight: 50),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(appTheme.widgetRadius * 0.85),
      ),
      margin: const EdgeInsets.only(bottom: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (leading != null) leading!,
                Expanded(
                    child: Text(title).textColor(colorScheme.inverseSurface)),
                if (trailing != null) trailing!
              ],
            ),
            if (children != null)
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(appTheme.widgetRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if (children == null) const Text('Do nothing'),
                      ...children ?? [],
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
