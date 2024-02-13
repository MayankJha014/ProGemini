import 'dart:io';
import 'package:file_picker/file_picker.dart';

Future<File?> pickImages() async {
  File? images;
  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (files != null && files.files.isNotEmpty) {
      final filePath = files.files.single.path!;

      images = File(filePath);
    }
  } catch (e) {
    print(e.toString());
  }
  return images;
}
