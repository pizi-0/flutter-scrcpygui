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
