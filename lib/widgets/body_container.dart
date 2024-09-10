// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';

class BodyContainer extends StatelessWidget {
  final List<Widget> children;
  final String? headerTitle;
  const BodyContainer({super.key, required this.children, this.headerTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (headerTitle != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                headerTitle!,
                style: context.textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: Column(
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BodyContainerItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(bottom: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            if (leading != null) leading!,
            Expanded(child: Text(title)),
            if (trailing != null) trailing!
          ],
        ),
      ),
    );
  }
}
