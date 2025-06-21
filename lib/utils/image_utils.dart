import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

Uint8List? _processAndEncodeImage(Map<String, dynamic> params) {
  final Uint8List bytes = params['bytes'];
  final int? maxSize = params['maxSize'];

  var decoded = img.decodeImage(bytes);

  if (decoded == null) {
    return null;
  }

  if (maxSize != null &&
      (decoded.width > maxSize || decoded.height > maxSize)) {
    if (decoded.width > decoded.height) {
      decoded = img.copyResize(decoded, width: maxSize);
    } else {
      decoded = img.copyResize(decoded, height: maxSize);
    }
  }

  return img.encodePng(decoded);
}

class ImageUtils {
  static Future<File?> byteToPngFile(Uint8List bytes, String filePath,
      {int? maxSize}) async {
    final pngBytes = await compute(
        _processAndEncodeImage, {'bytes': bytes, 'maxSize': maxSize});
    if (pngBytes == null) return null;
    final file = File(filePath);
    await file.writeAsBytes(pngBytes);

    return file;
  }
}
