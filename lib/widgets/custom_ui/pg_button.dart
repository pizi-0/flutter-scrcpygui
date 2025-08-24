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
