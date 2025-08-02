abstract interface class SimpleStringEnum {
  final String value;

  const SimpleStringEnum(this.value);
}

enum AutoArrangeOrigin {
  off,
  topLeft,
  topRight,
  centerLeft,
  centerRight,
  bottomLeft,
  bottomRight,
}
