// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:localization/localization.dart';

import 'auto_arrange_origin.dart';

abstract interface class NamedEnum {
  final String name;
  const NamedEnum(this.name);
}

enum MinimizeAction implements NamedEnum {
  toTaskBar('to taskbar'),
  toTray('to tray');

  @override
  final String name;

  const MinimizeAction(this.name);
}

class AppBehaviour {
  final String languageCode;
  final bool killNoWindowInstance;
  final bool traySupport;
  final bool toastEnabled;
  final MinimizeAction minimizeAction;
  final bool hideDefaultConfig;
  final bool rememberWinSize;
  final AutoArrangeOrigin autoArrangeOrigin;
  final double windowToScreenHeightRatio;
  final bool showWarningOnBack;

  AppBehaviour({
    required this.languageCode,
    required this.killNoWindowInstance,
    required this.traySupport,
    required this.toastEnabled,
    required this.minimizeAction,
    required this.hideDefaultConfig,
    required this.rememberWinSize,
    required this.autoArrangeOrigin,
    this.windowToScreenHeightRatio = 0.88,
    this.showWarningOnBack = true,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'languageCode': languageCode,
      'killNoWindowInstance': killNoWindowInstance,
      'traySupport': traySupport,
      'toastEnabled': toastEnabled,
      'minimizeAction': minimizeAction.index,
      'hideDefaultConfig': hideDefaultConfig,
      'rememberWinSize': rememberWinSize,
      'autoArrangeOrigin': autoArrangeOrigin.index,
      'windowToScreenHeightRatio': windowToScreenHeightRatio,
      'showWarningOnBack': showWarningOnBack,
    };
  }

  factory AppBehaviour.fromMap(Map<String, dynamic> map) {
    String lang() {
      String? code = map['languageCode'];

      if (code == null) {
        return 'en';
      } else {
        if (supportedLocales.where((l) => l.toLanguageTag() == code).isEmpty) {
          return 'en';
        }

        return map['languageCode'];
      }
    }

    return AppBehaviour(
      languageCode: lang(),
      killNoWindowInstance: map['killNoWindowInstance'] ?? true,
      traySupport: map['traySupport'] ?? true,
      toastEnabled: map['toastEnabled'] ?? true,
      minimizeAction: map['minimizeAction'] == null
          ? MinimizeAction.toTaskBar
          : MinimizeAction.values[map['minimizeAction']],
      hideDefaultConfig: map['hideDefaultConfig'] ?? false,
      rememberWinSize: map['rememberWinSize'] ?? false,
      autoArrangeOrigin:
          AutoArrangeOrigin.values[map['autoArrangeOrigin'] ?? 0],
      windowToScreenHeightRatio:
          (map['windowToScreenHeightRatio'] as num?)?.toDouble() ?? 0.88,
      showWarningOnBack: map['showWarningOnBack'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppBehaviour.fromJson(String source) =>
      AppBehaviour.fromMap(json.decode(source) as Map<String, dynamic>);

  AppBehaviour copyWith({
    String? languageCode,
    bool? killNoWindowInstance,
    bool? traySupport,
    bool? toastEnabled,
    MinimizeAction? minimizeAction,
    bool? hideDefaultConfig,
    bool? rememberWinSize,
    AutoArrangeOrigin? autoArrangeOrigin,
    double? windowToScreenHeightRatio,
    bool? showWarningOnBack,
  }) {
    return AppBehaviour(
      languageCode: languageCode ?? this.languageCode,
      killNoWindowInstance: killNoWindowInstance ?? this.killNoWindowInstance,
      traySupport: traySupport ?? this.traySupport,
      toastEnabled: toastEnabled ?? this.toastEnabled,
      minimizeAction: minimizeAction ?? this.minimizeAction,
      hideDefaultConfig: hideDefaultConfig ?? this.hideDefaultConfig,
      rememberWinSize: rememberWinSize ?? this.rememberWinSize,
      autoArrangeOrigin: autoArrangeOrigin ?? this.autoArrangeOrigin,
      windowToScreenHeightRatio:
          windowToScreenHeightRatio ?? this.windowToScreenHeightRatio,
      showWarningOnBack: showWarningOnBack ?? this.showWarningOnBack,
    );
  }

  @override
  String toString() {
    return 'AppBehaviour(languageCode: $languageCode, killNoWindowInstance: $killNoWindowInstance, traySupport: $traySupport, toastEnabled: $toastEnabled, minimizeAction: $minimizeAction, hideDefaultConfig: $hideDefaultConfig, rememberWinSize: $rememberWinSize, autoArrangeOrigin: $autoArrangeOrigin, windowToScreenHeightRatio: $windowToScreenHeightRatio, showWarningOnBack: $showWarningOnBack)';
  }

  @override
  bool operator ==(covariant AppBehaviour other) {
    if (identical(this, other)) return true;

    return other.languageCode == languageCode &&
        other.killNoWindowInstance == killNoWindowInstance &&
        other.traySupport == traySupport &&
        other.toastEnabled == toastEnabled &&
        other.minimizeAction == minimizeAction &&
        other.hideDefaultConfig == hideDefaultConfig &&
        other.rememberWinSize == rememberWinSize &&
        other.autoArrangeOrigin == autoArrangeOrigin &&
        other.windowToScreenHeightRatio == windowToScreenHeightRatio &&
        other.showWarningOnBack == showWarningOnBack;
  }

  @override
  int get hashCode {
    return languageCode.hashCode ^
        killNoWindowInstance.hashCode ^
        traySupport.hashCode ^
        toastEnabled.hashCode ^
        minimizeAction.hashCode ^
        hideDefaultConfig.hashCode ^
        rememberWinSize.hashCode ^
        autoArrangeOrigin.hashCode ^
        windowToScreenHeightRatio.hashCode ^
        showWarningOnBack.hashCode;
  }
}
