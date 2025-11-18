import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/utils/app_icon_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ExtractorIndicator extends ConsumerStatefulWidget {
  const ExtractorIndicator({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExtractorIndicatorState();
}

class _ExtractorIndicatorState extends ConsumerState<ExtractorIndicator> {
  @override
  void initState() {
    super.initState();
    IconExtractor.runner(ref);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
        dimension: 40, child: Center(child: CircularProgressIndicator()));
  }
}
