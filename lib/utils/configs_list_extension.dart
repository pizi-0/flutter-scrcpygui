import '../models/scrcpy_related/scrcpy_config.dart';
import '../models/scrcpy_related/scrcpy_config_tags.dart';

extension ScrcpyConfigListExtension on List<ScrcpyConfig> {
  /// Filters the list to include only ScrcpyConfig objects
  /// that contain the specified [tag] in their `tags` list.
  ///
  /// Returns a new list containing the filtered configurations.
  /// If a config's `tags` list is null or empty, it will not be included.
  List<ScrcpyConfig> filterByTag(ConfigTag tag) {
    // Use where to filter the list based on the condition
    // and toList() to convert the resulting Iterable back to a List.
    return where((config) => config.tags.contains(tag)).toList();
  }

  /// Filters the list to include only ScrcpyConfig objects
  /// that contain **all** of the specified [tagsToMatch] in their `tags` list.
  ///
  /// Returns a new list containing the filtered configurations.
  /// If [tagsToMatch] is empty, returns a copy of the original list.
  List<ScrcpyConfig> filterByAllTags(List<ConfigTag> tagsToMatch) {
    if (tagsToMatch.isEmpty) {
      return List.from(this); // Return all if no tags specified
    }
    return where(
            (config) => tagsToMatch.every((tag) => config.tags.contains(tag)))
        .toList();
  }

  /// Filters the list to include only ScrcpyConfig objects
  /// that contain **any** of the specified [tagsToMatch] in their `tags` list.
  ///
  /// Returns a new list containing the filtered configurations.
  /// If [tagsToMatch] is empty, returns an empty list.
  List<ScrcpyConfig> filterByAnyTag(List<ConfigTag> tagsToMatch) {
    if (tagsToMatch.isEmpty) return []; // Return none if no tags specified
    return where(
            (config) => tagsToMatch.any((tag) => config.tags.contains(tag)))
        .toList();
  }
}
