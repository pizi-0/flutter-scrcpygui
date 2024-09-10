import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pg_scrcpy/providers/toast_providers.dart';

import '../../utils/const.dart';

class SimpleToastItem extends ConsumerStatefulWidget {
  final SimpleToastStyle? toastStyle;
  final IconData? icon;
  final String message;

  const SimpleToastItem(
      {super.key,
      this.toastStyle = SimpleToastStyle.info,
      this.icon,
      required this.message});

  @override
  ConsumerState<SimpleToastItem> createState() => _SimpleToastItemState();
}

class _SimpleToastItemState extends ConsumerState<SimpleToastItem>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((t) async {
      await Future.delayed(3.seconds);
      if (mounted) {
        await animationController.reverse();
        ref.read(toastProvider.notifier).removeToast(
            ref.read(toastProvider).firstWhere((e) => e.key == widget.key));
      }
    });
  }

  _toastColor() {
    switch (widget.toastStyle) {
      case SimpleToastStyle.success:
        return Colors.green;
      case SimpleToastStyle.error:
        return Colors.red;

      default:
        return Theme.of(context).colorScheme.inverseSurface;
    }
  }

  // _toastTextColor() {
  //   switch (widget.toastStyle) {
  //     case SimpleToastStyle.success:
  //       return Colors.black;
  //     case SimpleToastStyle.error:
  //       return Colors.white;

  //     default:
  //       return Colors.white;
  //   }
  // }

  _toastIcon() {
    switch (widget.toastStyle) {
      case SimpleToastStyle.success:
        return const Icon(
          Icons.check_circle_outline_rounded,
          // color: _toastTextColor(),
        );
      case SimpleToastStyle.error:
        return const Icon(
          Icons.error_outline_rounded,
          // color: _toastTextColor(),
        );

      default:
        return const Icon(
          Icons.info_outline_rounded,
          // color: _toastTextColor(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: 300.milliseconds,
      controller: (controller) => animationController = controller,
      child: MouseRegion(
        onEnter: (event) {
          ref.read(toastProvider.notifier).removeToast(
              ref.read(toastProvider).firstWhere((e) => e.key == widget.key));
        },
        opaque: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 50,
                maxWidth: appWidth,
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: _toastColor(), width: 2)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 15,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _toastColor(),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(2),
                          topLeft: Radius.circular(2),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widget.icon != null
                                ? Icon(
                                    widget.icon,
                                  )
                                : _toastIcon(),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.message,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum SimpleToastStyle { success, info, error }
