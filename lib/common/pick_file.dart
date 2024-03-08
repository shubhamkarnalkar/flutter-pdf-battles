import 'package:file_picker/file_picker.dart';

Future<String> pickFile(String fileTypeText) async {
  // fileTypeText is for checking the file type afte picking it
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    final String filePath = result.files.single.path!;
    if (filePath.isNotEmpty && filePath.contains(fileTypeText)) {
      return filePath;
    } else {
      throw "Error: Please pick a $fileTypeText file";
    }
  } else {
    throw "Error: Please pick a $fileTypeText file";
  }
}
