abstract interface class SimpleStringEnum {
  final String value;

  const SimpleStringEnum(this.value);
}

enum AutoArrangeStatus implements SimpleStringEnum {
  off('off'),
  fromLeft('from left'),
  fromRight('from right');

  @override
  final String value;
  const AutoArrangeStatus(this.value);
}
