import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config/app_options.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_info/scrcpy_app_list.dart';
import 'package:scrcpygui/utils/const.dart';

class ConfigsNotifier extends Notifier<List<ScrcpyConfig>> {
  @override
  List<ScrcpyConfig> build() {
    return [...defaultConfigs];
  }

  addConfig(ScrcpyConfig config) {
    state = [...state, config];
  }

  removeConfig(ScrcpyConfig config) {
    state = [...state.where((c) => c != config)];
  }

  overwriteConfig(ScrcpyConfig oldConfig, ScrcpyConfig newConfig) {
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

  setConfig(ScrcpyConfig config) {
    state = config;
  }

  setName(String newName) {
    state = state!.copyWith(configName: newName);
  }

  setModeConfig({ScrcpyMode? scrcpyMode, bool? isRecording, String? savePath}) {
    state = state!.copyWith(
      scrcpyMode: scrcpyMode ?? state!.scrcpyMode,
      isRecording: isRecording ?? state!.isRecording,
      savePath: savePath ?? state!.savePath,
    );
  }

  setVideoConfig(
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

  setVirtDisplayConfig(
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

  setAudioConfig(
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

  setAppConfig({bool? forceClose, ScrcpyApp? selectedApp, bool reset = false}) {
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

  setWindowConfig(
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

  setDeviceConfig(
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

  setAdditionalFlags({String? additionalFlags}) {
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
