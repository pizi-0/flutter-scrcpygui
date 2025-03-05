import 'dart:ui';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class MyColor {
  static Color tinted(BuildContext context,
      {int alpha = 255, int tintlevel = 90}) {
    final scheme = Theme.of(context).colorScheme;
    final brightness = scheme.brightness;

    if (brightness == Brightness.light) {
      return scheme.primary.lighten(tintlevel).withAlpha(alpha);
    } else {
      return scheme.primary.darken(tintlevel).withAlpha(alpha);
    }
  }

  static Color scaffold(BuildContext context, {int alpha = 255}) {
    final scheme = Theme.of(context).colorScheme;
    final brightness = scheme.brightness;

    if (brightness == Brightness.light) {
      return scheme.primary.lighten(99).withAlpha(alpha);
    } else {
      return scheme.primary.darken(85).withAlpha(alpha);
    }
  }
}
