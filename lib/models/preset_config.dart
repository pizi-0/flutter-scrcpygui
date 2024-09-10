// import 'package:pg_scrcpy/models/config.dart';

// class PresetConfig {
//   static Config defaultMirror() {
//     return Config(
//       name: 'Default (Mirror)',
//       args: [
//         '--video-bit-rate=8M',
//         '--video-codec=h264',
//         '--audio-codec=opus',
//         '--audio-bit-rate=128K',
//         '--audio-buffer=50',
//       ],
//     );
//   }

//   static Config defaultRecord(
//       {required String savePath,
//       required String fileName,
//       required String format}) {
//     return Config(
//       name: 'Default (Record)',
//       args: [
//         '--video-bit-rate=8M',
//         '--video-codec=h264',
//         '--audio-codec=opus',
//         '--audio-bit-rate=128K',
//         '--audio-buffer=50',
//         '--record=$savePath/$fileName.$format'
//       ],
//     );
//   }
// }
