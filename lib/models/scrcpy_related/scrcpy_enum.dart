abstract interface class StringEnum {
  final String value;
  final String command;

  const StringEnum(this.value, this.command);
}

enum ScrcpyMode implements StringEnum {
  audioOnly('audio only', ' --no-video'),
  both('audio + video', ''),
  videoOnly('video only', ' --no-audio');

  @override
  final String value, command;
  const ScrcpyMode(this.value, this.command);
}

enum MainMode implements StringEnum {
  mirror('Mirror', ''),
  record('Record', '');

  @override
  final String value, command;
  const MainMode(this.value, this.command);
}

enum VideoFormat implements StringEnum {
  mp4('mp4', '.mp4'),
  mkv('mkv', '.mkv');

  @override
  final String value, command;
  const VideoFormat(this.value, this.command);
}

enum AudioFormat implements StringEnum {
  aac('aac', '.aac'),
  flac('flac', '.flac'),
  m4a('m4a', '.m4a'),
  mka('mka', '.mka'),
  opus('opus', '.opus'),
  wav('wav', '.wav');

  @override
  final String value, command;

  const AudioFormat(this.value, this.command);
}

enum AudioSource implements StringEnum {
  output('output', ''),
  playback('playback', ' --audio-source=playback'),
  mic('mic', ' --audio-source=mic'),
  //extra
  micUnprocessed('mic (unprocessed)', ' --audio-source=mic-unprocessed'),
  micCamcorder('mic (camcorder)', ' --audio-source=mic-camcorder'),
  micVoiceRecog(
      'mic (voice recognition)', ' --audio-source=mic-voice-recognition'),
  micVoiceComm(
      'mic (voice communication)', ' --audio-source=mic-voice-communication'),
  voiceCall('voice call', ' --audio-source=voice-call'),
  voiceCallUplink('voice call (uplink)', ' --audio-source=voice-call-uplink'),
  voiceCallDownlink(
      'voice call (downlink)', ' --audio-source=voice-call-downlink'),
  voicePerf('voice (performance)', ' --audio-source=voice-performance');

  @override
  final String value, command;
  const AudioSource(this.value, this.command);
}

enum ScrcpyOverride { record, landscape, mute }

enum MouseMode implements StringEnum {
  sdk('sdk', ''),
  uhid('uhid', ' --mouse=uhid'),
  aoa('aoa', ' --mouse=aoa'),
  disabled('disabled', ' --mouse=disabled');

  @override
  final String value, command;
  const MouseMode(this.value, this.command);
}

enum KeyboardMode implements StringEnum {
  sdk('sdk', ''),
  uhid('uhid', ' --keyboard=uhid'),
  aoa('aoa', ' --keyboard=aoa'),
  disabled('disabled', ' --keyboard=disabled');

  @override
  final String value, command;
  const KeyboardMode(this.value, this.command);
}

enum GamepadMode implements StringEnum {
  disabled('disabled', ''),
  uhid('uhid', ' --gamepad=uhid'),
  aoa('aoa', ' --gamepad=aoa');

  @override
  final String value, command;
  const GamepadMode(this.value, this.command);
}
