// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'scrcpy_related/scrcpy_info/scrcpy_app_list.dart';

class IconExtractorProgress {
  final int remaining;
  final String currentDevice;
  final String currentApp;
  final List<(ScrcpyApp, String)> failed;
  final List<ScrcpyApp> successful;

  IconExtractorProgress({
    required this.remaining,
    required this.currentDevice,
    required this.currentApp,
    required this.failed,
    required this.successful,
  });

  IconExtractorProgress copyWith({
    int? remaining,
    String? currentDevice,
    String? currentApp,
    List<(ScrcpyApp, String)>? failed,
    List<ScrcpyApp>? successful,
  }) {
    return IconExtractorProgress(
      remaining: remaining ?? this.remaining,
      currentDevice: currentDevice ?? this.currentDevice,
      currentApp: currentApp ?? this.currentApp,
      failed: failed ?? this.failed,
      successful: successful ?? this.successful,
    );
  }

  @override
  String toString() {
    return 'IconExtractorProgress(currentDevice: $currentDevice, currentApp: $currentApp, failed: $failed, successful: $successful)';
  }

  @override
  bool operator ==(covariant IconExtractorProgress other) {
    if (identical(this, other)) return true;

    return other.currentDevice == currentDevice &&
        other.currentApp == currentApp &&
        listEquals(other.failed, failed) &&
        listEquals(other.successful, successful);
  }

  @override
  int get hashCode {
    return currentDevice.hashCode ^
        currentApp.hashCode ^
        failed.hashCode ^
        successful.hashCode;
  }
}
