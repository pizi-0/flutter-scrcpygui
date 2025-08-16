import 'package:flutter/material.dart';

class TransparentSquareClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final squareRect = RRect.fromLTRBAndCorners(
      1,
      1,
      size.width,
      size.height,
      topLeft: Radius.circular(10),
      bottomLeft: Radius.circular(10),
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
