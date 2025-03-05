import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../utils/color_utils.dart';

class PgDivider extends StatelessWidget {
  const PgDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: MyColor.scaffold(context).getContrastColor().withAlpha(50),
    );
  }
}
