// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AutomationData {
  final List<AutomationAction> actions;

  AutomationData({
    required this.actions,
  });

  AutomationData copyWith({
    List<AutomationAction>? actions,
  }) {
    return AutomationData(
      actions: actions ?? this.actions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'actions': actions.map((x) => x.toMap()).toList(),
    };
  }

  factory AutomationData.fromMap(Map<String, dynamic> map) {
    return AutomationData(
      actions: List<AutomationAction>.from(
        (map['actions']).map<AutomationAction>(
          (x) => AutomationAction.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AutomationData.fromJson(String source) =>
      AutomationData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AutomationData(actions: $actions)';

  @override
  bool operator ==(covariant AutomationData other) {
    if (identical(this, other)) return true;

    return listEquals(other.actions, actions);
  }

  @override
  int get hashCode => actions.hashCode;
}

class AutomationAction {
  final ActionType? type;
  final dynamic action;

  AutomationAction({
    this.type,
    this.action,
  });

  AutomationAction copyWith({
    ActionType? type,
    dynamic action,
  }) {
    return AutomationAction(
      type: type ?? this.type,
      action: action ?? this.action,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': ActionType.values.indexOf(type!),
      'action': action,
    };
  }

  factory AutomationAction.fromMap(Map<String, dynamic> map) {
    return AutomationAction(
      type: ActionType.values[map['type']],
      action: map['action'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory AutomationAction.fromJson(String source) =>
      AutomationAction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AutomationAction(type: $type, action: $action)';

  @override
  bool operator ==(covariant AutomationAction other) {
    if (identical(this, other)) return true;

    return other.type == type && other.action == action;
  }

  @override
  int get hashCode => type.hashCode ^ action.hashCode;
}

enum ActionType { autoconnect, launchConfig, stopConfig }
