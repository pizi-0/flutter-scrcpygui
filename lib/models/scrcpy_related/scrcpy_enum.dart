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
  mic('mic', ' --audio-source=mic');

  @override
  final String value, command;
  const AudioSource(this.value, this.command);
}
