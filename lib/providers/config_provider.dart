import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/app_options.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config_tags.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';
import 'package:scrcpygui/utils/configs_list_extension.dart';
import 'package:scrcpygui/utils/const.dart';

class ConfigsNotifier extends Notifier<List<ScrcpyConfig>> {
  @override
  List<ScrcpyConfig> build() {
    return [];
  }

  void addConfig(ScrcpyConfig config) {
    state = [...state, config];
  }

  void removeConfig(ScrcpyConfig config) {
    state = [...state.where((c) => c != config)];
  }

  void overwriteConfig(ScrcpyConfig oldConfig, ScrcpyConfig newConfig) {
    final newState = state;

    final index = newState.indexOf(oldConfig);

    newState.removeAt(index);
    newState.insert(index, newConfig);

    state = [...newState];
  }
}

class EditingConfigNotifier extends Notifier<ScrcpyConfig?> {
  @override
  ScrcpyConfig? build() {
    return null;
  }

  void setConfig(ScrcpyConfig config) {
    state = config;
  }

  void setName(String newName) {
    state = state!.copyWith(configName: newName);
  }

  void setModeConfig(
      {ScrcpyMode? scrcpyMode, bool? isRecording, String? savePath}) {
    state = state!.copyWith(
      scrcpyMode: scrcpyMode ?? state!.scrcpyMode,
      isRecording: isRecording ?? state!.isRecording,
      savePath: savePath ?? state!.savePath,
    );
  }

  void setVideoConfig(
      {String? displayId,
      double? maxFPS,
      double? resolutionScale,
      int? videoBitrate,
      String? videoCodec,
      String? videoEncoder,
      VideoFormat? videoFormat,
      bool setToDefault = false}) {
    final current = setToDefault
        ? state!.isRecording
            ? defaultRecord.videoOptions
            : defaultMirror.videoOptions
        : state!.videoOptions;

    state = state!.copyWith(
      videoOptions: current.copyWith(
        displayId: displayId ?? current.displayId,
        maxFPS: maxFPS ?? current.maxFPS,
        resolutionScale: resolutionScale ?? current.resolutionScale,
        videoBitrate: videoBitrate ?? current.videoBitrate,
        videoCodec: videoCodec ?? current.videoCodec,
        videoEncoder: videoEncoder ?? current.videoEncoder,
        videoFormat: videoFormat ?? current.videoFormat,
      ),
    );
  }

  void setVirtDisplayConfig(
      {bool? disableDecorations,
      String? dpi,
      bool? preseveContent,
      String? resolution}) {
    final current = state!.videoOptions.virtualDisplayOptions;

    state = state!.copyWith(
      videoOptions: state!.videoOptions.copyWith(
        virtualDisplayOptions: current.copyWith(
          disableDecorations: disableDecorations ?? current.disableDecorations,
          dpi: dpi ?? current.dpi,
          preseveContent: preseveContent ?? current.preseveContent,
          resolution: resolution ?? current.resolution,
        ),
      ),
    );
  }

  void setAudioConfig(
      {int? audioBitrate,
      String? audioCodec,
      String? audioEncoder,
      AudioFormat? audioFormat,
      AudioSource? audioSource,
      bool? duplicateAudio,
      bool setToDefault = false}) {
    final current = setToDefault
        ? state!.isRecording
            ? defaultRecord.audioOptions
            : defaultMirror.audioOptions
        : state!.audioOptions;

    state = state!.copyWith(
      audioOptions: current.copyWith(
        audioBitrate: audioBitrate ?? current.audioBitrate,
        audioCodec: audioCodec ?? current.audioCodec,
        audioEncoder: audioEncoder ?? current.audioEncoder,
        audioFormat: audioFormat ?? current.audioFormat,
        audioSource: audioSource ?? current.audioSource,
        duplicateAudio: duplicateAudio ?? current.duplicateAudio,
      ),
    );
  }

  void setAppConfig(
      {bool? forceClose, ScrcpyApp? selectedApp, bool reset = false}) {
    final current = state!.appOptions;
    state = state!.copyWith(
      appOptions: reset
          ? SAppOptions(forceClose: false)
          : current.copyWith(
              forceClose: forceClose ?? current.forceClose,
              selectedApp: selectedApp ?? current.selectedApp,
            ),
    );
  }

  void setWindowConfig(
      {bool? alwaysOntop, bool? noBorder, bool? noWindow, int? timeLimit}) {
    final current = state!.windowOptions;
    state = state!.copyWith(
      windowOptions: current.copyWith(
        alwaysOntop: alwaysOntop ?? current.alwaysOntop,
        noBorder: noBorder ?? current.noBorder,
        noWindow: noWindow ?? current.noWindow,
        timeLimit: timeLimit ?? current.timeLimit,
      ),
    );
  }

  void setDeviceConfig(
      {bool? noScreensaver,
      bool? offScreenOnClose,
      bool? showTouches,
      bool? stayAwake,
      bool? turnOffDisplay}) {
    final current = state!.deviceOptions;

    state = state!.copyWith(
      deviceOptions: current.copyWith(
        noScreensaver: noScreensaver ?? current.noScreensaver,
        offScreenOnClose: offScreenOnClose ?? current.offScreenOnClose,
        showTouches: showTouches ?? current.showTouches,
        stayAwake: stayAwake ?? current.stayAwake,
        turnOffDisplay: turnOffDisplay ?? current.turnOffDisplay,
      ),
    );
  }

  void setAdditionalFlags({String? additionalFlags}) {
    final current = state!.additionalFlags;
    state = state!.copyWith(additionalFlags: additionalFlags ?? current);
  }
}

final configsProvider = NotifierProvider<ConfigsNotifier, List<ScrcpyConfig>>(
    () => ConfigsNotifier());

final selectedConfigProvider = StateProvider<ScrcpyConfig?>((ref) => null);
final configScreenConfig =
    NotifierProvider<EditingConfigNotifier, ScrcpyConfig?>(
        () => EditingConfigNotifier());
final configScreenShowInfo = StateProvider((ref) => false);

class ConfigTagNotifier extends Notifier<List<ConfigTag>> {
  @override
  List<ConfigTag> build() {
    return [];
  }

  void addTag(ConfigTag tag) {
    if (!state.contains(tag)) {
      state = [...state, tag];

      _setSelectedConfig();
    }
  }

  void removeTag(ConfigTag tag) {
    state = [...state.where((t) => t != tag)];

    _setSelectedConfig();
  }

  void toggleTag(ConfigTag tag) {
    if (state.contains(tag)) {
      removeTag(tag);
    } else {
      addTag(tag);
    }
  }

  void clearTag() {
    state = [
      ...state.where(
          (e) => e == ConfigTag.customConfig || e == ConfigTag.defaultConfig)
    ];

    _setSelectedConfig();
  }

  void _setSelectedConfig() {
    final allconfig = ref.read(configsProvider);
    final f1 = allconfig.filterByAnyTag(state
        .where(
            (t) => t == ConfigTag.customConfig || t == ConfigTag.defaultConfig)
        .toList());

    final f2 = f1.filterByAllTags(state
        .where(
            (t) => t != ConfigTag.customConfig || t != ConfigTag.defaultConfig)
        .toList());

    if (f2.isNotEmpty) {
      final selectedConfig = ref.read(selectedConfigProvider);
      if (!f2.contains(selectedConfig)) {
        ref.read(selectedConfigProvider.notifier).state = f2.first;
      }
    } else {
      ref.read(selectedConfigProvider.notifier).state = null;
    }
  }
}

final configTags = NotifierProvider<ConfigTagNotifier, List<ConfigTag>>(
    () => ConfigTagNotifier());

class FilteredConfigNotifier extends Notifier<List<ScrcpyConfig>> {
  @override
  List<ScrcpyConfig> build() {
    final filters = ref.watch(configTags);
    final allconfigs = ref.watch(configsProvider);

    final f1 = allconfigs.filterByAnyTag(filters
        .where(
            (f) => f == ConfigTag.customConfig || f == ConfigTag.defaultConfig)
        .toList());

    final f2 = f1
        .filterByAllTags(filters
            .where((f) =>
                f != ConfigTag.customConfig || f != ConfigTag.defaultConfig)
            .toList())
        .toList();

    return f2;
  }
}

final filteredConfigsProvider =
    NotifierProvider<FilteredConfigNotifier, List<ScrcpyConfig>>(
        () => FilteredConfigNotifier());

final controlPageConfigProvider = StateProvider<ScrcpyConfig?>((ref) => null);

class ConfigOverrideNotifier extends Notifier<List<ScrcpyOverride>> {
  @override
  List<ScrcpyOverride> build() {
    return [];
  }

  void setOverride(List<ScrcpyOverride> overrides) {
    state = overrides;
  }

  void addOverride(ScrcpyOverride override) {
    if (!state.contains(override)) {
      state = [...state, override];
    }
  }

  void removeOverride(ScrcpyOverride override) {
    state = [...state.where((o) => o != override)];
  }

  void toggleOverride(ScrcpyOverride override) {
    if (state.contains(override)) {
      removeOverride(override);
    } else {
      addOverride(override);
    }
  }

  void clearOverride() {
    state = [];
  }
}

final configOverridesProvider =
    NotifierProvider<ConfigOverrideNotifier, List<ScrcpyOverride>>(
        () => ConfigOverrideNotifier());

final hiddenConfigsProvider = StateProvider<List<String>>((ref) => []);

final preventNavigationProvider = StateProvider<bool>((ref) => false);
