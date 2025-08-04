abstract interface class SimpleStringEnum {
  final String value;

  const SimpleStringEnum(this.value);
}

enum AutoArrangeOrigin implements SimpleStringEnum {
  off('off'),
  topLeft('top left'),
  topRight('top right'),
  centerLeft('center left'),
  centerRight('center right'),
  bottomLeft('bottom left'),
  bottomRight('bottom right');

  @override
  final String value;
  const AutoArrangeOrigin(this.value);
}
