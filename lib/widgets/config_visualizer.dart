import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_config.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_enum.dart';
import 'package:scrcpygui/models/scrcpy_related/scrcpy_running_instance.dart';

class ConfigVisualizer extends StatelessWidget {
  final ScrcpyRunningInstance? instance;
  final ScrcpyConfig? conf;
  const ConfigVisualizer({super.key, this.instance, this.conf});

  @override
  Widget build(BuildContext context) {
    final config = instance?.config ?? conf;
    double iconSize = 13;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment:
            conf == null ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (instance != null) SessionTimer(instance: instance!),
          config!.isRecording
              ? Tooltip(
                  message: 'Recording',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(Icons.videocam,
                        size: iconSize, color: Colors.green),
                  ),
                )
              : Tooltip(
                  message: 'Mirroring',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child:
                        Icon(Icons.copy, size: iconSize, color: Colors.green),
                  ),
                ),
          if (config.audioOptions.audioSource == AudioSource.mic)
            Icon(Icons.mic_rounded, size: iconSize),
          if (config.windowOptions.noWindow)
            Tooltip(
              message: 'No window',
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(Icons.desktop_access_disabled_rounded,
                      size: iconSize)),
            ),
          CodecIndicator(config: config),
        ],
      ),
    );
  }
}

class CodecIndicator extends StatefulWidget {
  final ScrcpyConfig config;
  const CodecIndicator({super.key, required this.config});

  @override
  State<CodecIndicator> createState() => _CodecIndicatorState();
}

class _CodecIndicatorState extends State<CodecIndicator> {
  TextStyle style = const TextStyle(fontSize: 10);

  Widget _buildVideoCodec() {
    // BoxDecoration decoration = BoxDecoration(
    //     borderRadius: BorderRadius.circular(3),
    //     border: Border.all(
    //         color: Theme.of(context).colorScheme.onPrimaryContainer));
    final codec = widget.config.videoOptions.videoCodec;

    final bitrate = widget.config.videoOptions.videoBitrate.toString();

    return Row(
      children: [
        Tooltip(
          message: 'Video codec',
          child: Container(
            // decoration: decoration,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(codec, style: style),
          ),
        ),
        Tooltip(
          message: 'Video bitrate',
          child: Container(
              // decoration: decoration,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Text('${bitrate}M', style: style)),
        ),
      ],
    );
  }

  Widget _buildAudioCodec() {
    // BoxDecoration decoration = BoxDecoration(
    //     borderRadius: BorderRadius.circular(3),
    //     border: Border.all(
    //         color: Theme.of(context).colorScheme.onPrimaryContainer));
    final codec = widget.config.audioOptions.audioCodec;

    final bitrate = widget.config.audioOptions.audioBitrate.toString();

    return Row(
      children: [
        Tooltip(
          message: 'Audio codec',
          child: Container(
              // decoration: decoration,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(codec, style: style)),
        ),
        Tooltip(
          message: 'Audio bitrate',
          child: Container(
              // decoration: decoration,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Text('${bitrate}K', style: style)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        children: [
          if (widget.config.scrcpyMode != ScrcpyMode.audioOnly)
            _buildVideoCodec(),
          if (widget.config.scrcpyMode != ScrcpyMode.videoOnly)
            _buildAudioCodec()
        ],
      ),
    );
  }
}

class RecordingIndicator extends StatefulWidget {
  const RecordingIndicator({super.key});

  @override
  State<RecordingIndicator> createState() => _RecordingIndicatorState();
}

class _RecordingIndicatorState extends State<RecordingIndicator> {
  Timer? timer;
  bool pulse = true;

  _blink() {
    timer = Timer.periodic(const Duration(seconds: 1), (a) {
      setState(() => pulse = !pulse);
    });
  }

  @override
  void initState() {
    super.initState();
    _blink();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: pulse ? Colors.red : Colors.transparent,
      ),
    );
  }
}

class SessionTimer extends StatefulWidget {
  final ScrcpyRunningInstance instance;
  const SessionTimer({super.key, required this.instance});

  @override
  State<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  Timer? timer;
  String dur = '';

  _getDuration() {
    timer = Timer.periodic(
      const Duration(milliseconds: 200),
      (a) {
        final end = DateTime.now();
        final range = DateTimeRange(start: widget.instance.startTime, end: end);
        dur = range.duration.toString().split('.').first;
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    _getDuration();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(dur),
    );
  }
}
