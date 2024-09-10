// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class FlagCheckResult {
  final bool ok;
  final String? errorMessage;
  final Widget? overrideFlag;

  FlagCheckResult({required this.ok, this.errorMessage, this.overrideFlag});

  FlagCheckResult copyWith({
    bool? ok,
    String? errorMessage,
    Widget? overrideFlag,
  }) {
    return FlagCheckResult(
      ok: ok ?? this.ok,
      errorMessage: errorMessage ?? this.errorMessage,
      overrideFlag: overrideFlag ?? this.overrideFlag,
    );
  }

  @override
  String toString() => 'FlagCheckResult(ok: $ok, errorMessage: $errorMessage)';
}
