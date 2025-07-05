import 'package:flutter_riverpod/flutter_riverpod.dart';

final configListStateProvider =
    StateProvider<ConfigListState>((ref) => ConfigListState());

class ConfigListState {
  final bool reorder;
  final bool filtering;
  final bool override;

  bool get isOpen => reorder || filtering || override;

  ConfigListState(
      {this.reorder = false, this.filtering = false, this.override = false});

  ConfigListState copyWith({bool? reorder, bool? filtering, bool? override}) {
    return ConfigListState(
      reorder: reorder ?? this.reorder,
      filtering: filtering ?? this.filtering,
      override: override ?? this.override,
    );
  }
}
