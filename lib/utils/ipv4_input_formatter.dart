import 'package:flutter/services.dart';

/// A [TextInputFormatter] that restricts input to a valid IPv4 address format.
///
/// It allows digits and dots, and performs basic validation on segments
/// to ensure they are within the 0-255 range and do not have leading zeros
/// (unless the segment is just "0"). It also limits the number of segments to 4.
class IPv4InputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only digits and dots
    final String newText = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Prevent multiple consecutive dots (e.g., "192..168")
    if (newText.contains('..')) {
      return oldValue;
    }

    // Prevent leading dot (e.g., ".192")
    if (newText.startsWith('.')) {
      return oldValue;
    }

    // Split into segments by dot
    final List<String> segments = newText.split('.');

    // Check number of segments (max 4 for IPv4)
    if (segments.length > 4) {
      return oldValue;
    }

    // Validate each segment
    for (int i = 0; i < segments.length; i++) {
      final String segment = segments[i];

      // If the segment is empty:
      // - Allow it if it's the last segment (e.g., "192.168.1.") as a valid intermediate state.
      // - Disallow it if it's an intermediate empty segment (e.g., "192..168").
      // The `newText.contains('..')` check already handles consecutive dots,
      // but this provides an additional layer for other empty segment scenarios.
      if (segment.isEmpty && i == segments.length - 1) {
        continue; // Allow empty last segment
      }
      if (segment.isEmpty) {
        // If it's empty and not the last segment, it's invalid
        return oldValue;
      }

      // Prevent leading zeros unless the segment is just "0" (e.g., "01", "007")
      if (segment.length > 1 && segment.startsWith('0')) {
        return oldValue;
      }

      // Check segment value (0-255) and length (max 3 digits)
      final int? value = int.tryParse(segment);
      if (value == null || value > 255 || segment.length > 3) {
        return oldValue;
      }
    }

    // If all checks pass, return the new value with cursor at the end
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
