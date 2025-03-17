import 'dart:ui';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    if (hexString.length == 3 || hexString.length == 4) {
      var newHex = '';
      for (var c in hexString.split('')) {
        final l = newHex.split('');
        l.add('$c$c');

        newHex = l.join();
      }

      hexString = newHex;

      buffer.write('ff');
    }
    buffer.write(hexString.replaceAll('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension ListExtension on List {
  void addIfNotExist(dynamic value) {
    if (!contains(value)) {
      add(value);
    }
  }
}

extension ResolutionStringExtension on String {
  /// Checks if the string is a valid resolution format (e.g., "1920x1080").
  ///
  /// Returns `true` if the string matches the resolution format, `false` otherwise.
  bool get isValidResolution {
    // Regular expression to match the resolution format:
    // - ^: Matches the beginning of the string.
    // - \d+: Matches one or more digits (for the width).
    // - x: Matches the literal "x" character.
    // - \d+: Matches one or more digits (for the height).
    // - $: Matches the end of the string.
    final resolutionRegex = RegExp(r'^\d+x\d+$');
    return resolutionRegex.hasMatch(this);
  }

  /// Returns the width of the resolution if the string is a valid resolution format.
  ///
  /// Returns `null` if the string is not a valid resolution format.
  int? get resolutionWidth {
    if (!isValidResolution) {
      return null;
    }
    return int.tryParse(split('x').first);
  }

  /// Returns the height of the resolution if the string is a valid resolution format.
  ///
  /// Returns `null` if the string is not a valid resolution format.
  int? get resolutionHeight {
    if (!isValidResolution) {
      return null;
    }
    return int.tryParse(split('x').last);
  }
}
