// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

import 'scrcpy_related/scrcpy_info/scrcpy_app_list.dart';

class MissingIcon {
  final String serialNo;
  final List<ScrcpyApp> apps;
  MissingIcon({
    required this.serialNo,
    required this.apps,
  });

  MissingIcon addApp(ScrcpyApp app) {
    if (apps.contains(app)) {
      return this;
    } else {
      return MissingIcon(
        serialNo: serialNo,
        apps: [...apps, app],
      );
    }
  }

  MissingIcon removeApp(ScrcpyApp app) {
    return MissingIcon(
      serialNo: serialNo,
      apps: apps.where((a) => a.packageName != app.packageName).toList(),
    );
  }

  @override
  bool operator ==(covariant MissingIcon other) {
    if (identical(this, other)) return true;

    return other.serialNo == serialNo && listEquals(other.apps, apps);
  }

  @override
  int get hashCode => serialNo.hashCode ^ apps.hashCode;
}
