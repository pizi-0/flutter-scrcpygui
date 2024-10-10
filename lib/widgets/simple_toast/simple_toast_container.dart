import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/providers/toast_providers.dart';
// import 'package:scrcpygui/providers/toast_providers.dart';

class SimpleToastContainer extends ConsumerStatefulWidget {
  const SimpleToastContainer({super.key});

  @override
  ConsumerState<SimpleToastContainer> createState() =>
      _SimpleToastContainerState();
}

class _SimpleToastContainerState extends ConsumerState<SimpleToastContainer> {
  @override
  Widget build(BuildContext context) {
    var children = ref.watch(toastProvider);

    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}
