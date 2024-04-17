import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf_battles/common/constants/constants.dart';

Future<void> initialize() async {
  await Hive.initFlutter();
  await Hive.openBox(settingsBox);
  await Hive.openBox(filesBox);
}
