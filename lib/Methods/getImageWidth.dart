import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

class GetImageWidth {
  static Future<int?> getImageWidth(File? image) async {
    if (image != null) {
      final Completer<ui.Image> completer = Completer();
      final data = await image.readAsBytes();
      ui.decodeImageFromList(Uint8List.fromList(data), (result) {
        completer.complete(result);
      });
      final img = await completer.future;
      return img.width;
    }
    return null;
  }
}
