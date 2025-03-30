import 'dart:ui';

import 'package:shadcn_flutter/shadcn_flutter.dart';

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

extension AppVersionParsing on String {
  /// Parses a version string (e.g., "1.2.3") into an integer representation.
  ///
  /// This extension method splits the version string into its major, minor,
  /// and patch components, parses each component as an integer, and then
  /// combines them into a single integer.
  ///
  /// Example:
  ///   "1.2.3" becomes 1002003
  ///   "2.10.5" becomes 2010005
  ///   "1.2" becomes 1002000
  ///   "1" becomes 1000000
  ///   "1.a.3" becomes 1000003
  ///   "1.2.3.4" becomes 1002003 (with a warning)
  ///
  /// Returns:
  ///   An integer representing the version, or null if parsing fails.
  int? parseVersionToInt() {
    try {
      final parts = split('.');
      if (parts.length > 3) {
        debugPrint('Warning: Version string has more than 3 parts: $this');
      }
      int major = int.tryParse(parts[0]) ?? 0;
      int minor = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
      int patch = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;

      // Combine into a single integer (e.g., 1.2.3 becomes 1002003)
      return major * 1000000 + minor * 1000 + patch;
    } catch (e) {
      debugPrint('Error parsing version string: $this, Error: $e');
      return null;
    }
  }
}
