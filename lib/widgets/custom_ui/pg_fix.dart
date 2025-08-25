import 'package:shadcn_flutter/shadcn_flutter.dart';

extension PgFix on Widget {
  Widget fixDisabledStyle() {
    return ButtonStyleOverride(
      decoration: (context, states, value) {
        if (states.contains(WidgetState.disabled)) {
          final theme = Theme.of(context);
          return value.copyWithIfBoxDecoration(
            color: theme.colorScheme.muted.withAlpha(50),
          );
        }
        return value;
      },
      mouseCursor: (context, states, value) {
        if (states.contains(WidgetState.disabled)) {
          return SystemMouseCursors.forbidden;
        }
        return value;
      },
      child: this,
    );
  }
}
