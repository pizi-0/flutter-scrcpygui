import 'dart:io';

// Helper extension to convert InternetAddress to int
extension _InternetAddressToInt on InternetAddress {
  /// Converts an IPv4 address to its 32-bit integer representation.
  /// Throws [UnsupportedError] if the address is not IPv4.
  int toIPv4Int() {
    if (type != InternetAddressType.IPv4) {
      throw UnsupportedError('Only IPv4 addresses can be converted to int.');
    }
    final bytes = rawAddress;
    return (bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3];
  }
}

/// Extension methods for String to compare IPv4 addresses.
extension IPv4Comparison on String {
  /// Parses this string as an IPv4 address and returns its integer representation.
  /// Returns `null` if the string is not a valid IPv4 address.
  int? _tryParseIPv4Int() {
    final address = InternetAddress.tryParse(this);
    if (address != null && address.type == InternetAddressType.IPv4) {
      try {
        return address.toIPv4Int();
      } on UnsupportedError {
        // This should not happen due to the type check, but is here for safety.
        return null;
      }
    }
    return null;
  }

  /// Finds the candidate IPv4 address from a list that is numerically
  /// numerically closer to this (the target) IPv4 address string.
  ///
  /// Returns `null` if this (target) IP is invalid, or if the [candidates]
  /// list is empty or contains no valid IPv4 addresses.
  String? findClosest(List<String> candidates) {
    final targetInt = _tryParseIPv4Int();
    if (targetInt == null) {
      // Target IP is invalid, cannot determine closeness
      return null;
    }

    String? closestCandidate;
    int? minDifference;

    for (final candidate in candidates) {
      final candidateInt = candidate._tryParseIPv4Int();
      if (candidateInt == null) {
        continue; // Skip invalid candidates
      }

      final difference = (targetInt - candidateInt).abs();

      if (minDifference == null || difference < minDifference) {
        minDifference = difference;
        closestCandidate = candidate;
      }
    }

    return closestCandidate;
  }
}
