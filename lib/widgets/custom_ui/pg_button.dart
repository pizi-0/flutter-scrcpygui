import 'package:shadcn_flutter/shadcn_flutter.dart';

class PgDestructiveButton extends StatelessWidget {
  final ButtonDensity density;
  final Widget child;
  final Function()? onPressed;

  const PgDestructiveButton({
    super.key,
    this.density = ButtonDensity.normal,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Button(
      style: ButtonStyle.destructive(density: density)
          .withBackgroundColor(
            color: brightness == Brightness.dark
                ? Colors.red[900]
                : Colors.red[500],
            hoverColor: Colors.red[800],
          )
          .withForegroundColor(color: Colors.white),
      onPressed: onPressed,
      child: child,
    );
  }
}

abstract class PgButtonVariance implements AbstractButtonStyle {
  static const AbstractButtonStyle destructive =
      ComponentThemeButtonStyle<DestructiveButtonTheme>(
    fallback: ButtonVariance(
      decoration: _buttonDestructiveDecoration,
      mouseCursor: _buttonMouseCursor,
      padding: _buttonPadding,
      textStyle: _buttonDestructiveTextStyle,
      iconTheme: _buttonDestructiveIconTheme,
      margin: _buttonZeroMargin,
    ),
  );
}

Decoration _buttonDestructiveDecoration(
    BuildContext context, Set<WidgetState> states) {
  var themeData = Theme.of(context);
  if (states.contains(WidgetState.disabled)) {
    return BoxDecoration(
      color: themeData.colorScheme.primaryForeground,
      borderRadius: BorderRadius.circular(themeData.radiusMd),
    );
  }
  if (states.contains(WidgetState.hovered)) {
    return BoxDecoration(
      color: themeData.colorScheme.destructive.scaleAlpha(0.8),
      borderRadius: BorderRadius.circular(themeData.radiusMd),
    );
  }
  return BoxDecoration(
    color: themeData.colorScheme.destructive.scaleAlpha(.9),
    borderRadius: BorderRadius.circular(themeData.radiusMd),
  );
}

TextStyle _buttonDestructiveTextStyle(
    BuildContext context, Set<WidgetState> states) {
  var themeData = Theme.of(context);
  return themeData.typography.small.merge(themeData.typography.medium).copyWith(
        color: states.contains(WidgetState.disabled)
            ? themeData.colorScheme.mutedForeground
            : Colors
                .white, // yeah ik, its straight up white regardless light or dark mode
      );
}

IconThemeData _buttonDestructiveIconTheme(
    BuildContext context, Set<WidgetState> states) {
  var themeData = Theme.of(context);
  return IconThemeData(
    color: states.contains(WidgetState.disabled)
        ? themeData.colorScheme.mutedForeground
        : Colors.white,
  );
}

EdgeInsets _buttonZeroMargin(BuildContext context, Set<WidgetState> states) {
  return EdgeInsets.zero;
}

MouseCursor _buttonMouseCursor(BuildContext context, Set<WidgetState> states) {
  return states.contains(WidgetState.disabled)
      ? SystemMouseCursors.basic
      : SystemMouseCursors.click;
}

EdgeInsets _buttonPadding(BuildContext context, Set<WidgetState> states) {
  final theme = Theme.of(context);
  return EdgeInsets.symmetric(
    horizontal: theme.scaling * 16,
    vertical: theme.scaling * 8,
  );
}
