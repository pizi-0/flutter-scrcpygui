import 'package:flutter/material.dart';

class TransparentSquareClipper extends CustomClipper<Path> {
  final double radius;
  TransparentSquareClipper({this.radius = 10});

  @override
  Path getClip(Size size) {
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final squareRect = RRect.fromLTRBAndCorners(
      1,
      1,
      size.width,
      size.height,
      topLeft: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );

    path.addRRect(squareRect);

    path.fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // Returning `false` is efficient as the shape does not change.
    return true;
  }
}
