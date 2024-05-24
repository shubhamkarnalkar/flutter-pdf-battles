import 'package:pdf_battles/model/hive/pdf_files.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf_battles/common/constants/constants.dart';

Future<void> initialize() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PdfFilesAdapter());
  await Hive.openBox(settingsBox);
  await Hive.openBox<PdfFiles>(filesBox);
}
