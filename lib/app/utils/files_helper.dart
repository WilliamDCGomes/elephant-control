import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FilesHelper {
  static Future<XFile> createXFileFromBase64(String base64String, {String? name}) async {
    Uint8List bytes = base64.decode(base64String);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/" + (name ?? DateTime.now().millisecondsSinceEpoch.toString()) + ".jpg");
    await file.writeAsBytes(bytes);
    return XFile(file.path);
  }
}