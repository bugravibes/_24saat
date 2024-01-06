import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  Future<String> saveImageToDevice(String imagePath) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String fileName = 'repair_image_$timestamp.jpg';
    final File newImage = await File(imagePath).copy('$path/$fileName');
    return newImage.path;
  }
}
