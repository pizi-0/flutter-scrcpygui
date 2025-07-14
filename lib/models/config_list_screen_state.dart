import 'package:flutter_riverpod/flutter_riverpod.dart';

final configListStateProvider =
    StateProvider<ConfigListState>((ref) => ConfigListState());

class ConfigListState {
  final bool edit;
  final bool filtering;
  final bool override;

  bool get isOpen => edit || filtering || override;

  ConfigListState(
      {this.edit = false, this.filtering = false, this.override = false});

  ConfigListState copyWith({bool? edit, bool? filtering, bool? override}) {
    return ConfigListState(
      edit: edit ?? this.edit,
      filtering: filtering ?? this.filtering,
      override: override ?? this.override,
    );
  }
}
