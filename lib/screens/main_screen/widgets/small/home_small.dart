import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/const.dart';
import '../config_list_view.dart';
import '../connected_devices_view.dart';

final homeDeviceAttention = StateProvider((ref) => false);

class HomeTabSmall extends ConsumerStatefulWidget {
  const HomeTabSmall({super.key});

  @override
  ConsumerState<HomeTabSmall> createState() => _HomeTabSmallState();
}

class _HomeTabSmallState extends ConsumerState<HomeTabSmall>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  int deviceFlex = 300;
  int configFlex = 200;

  bool configAutoExpand = false;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: 200.milliseconds,
        reverseDuration: 200.milliseconds,
        vsync: this);
    _animation = IntTween(begin: 200, end: 750).animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: appWidth,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: deviceFlex,

                    // child! == ConnectedDeviceView()
                    child: child!,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: _animation.value,
                    child: ConfigListView(
                      animation: _animation,
                      animationController: _animationController,
                    ),
                  ),
                ],
              );
            },
            child: const ConnectedDevicesView(),
          ),
        ),
      ),
    );
  }
}
