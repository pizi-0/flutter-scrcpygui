class Dependencies {
  final bool adb;
  final bool scrcpy;

  Dependencies({required this.adb, required this.scrcpy});

  Dependencies copyWith({
    bool? adb,
    bool? scrcpy,
  }) {
    return Dependencies(
      adb: adb ?? this.adb,
      scrcpy: scrcpy ?? this.scrcpy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Dependencies && other.adb == adb && other.scrcpy == scrcpy;
  }

  @override
  int get hashCode => adb.hashCode ^ scrcpy.hashCode;
}
