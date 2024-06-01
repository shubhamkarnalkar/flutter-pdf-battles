import 'package:hive/hive.dart';

part 'pdf_files.g.dart';

@HiveType(typeId: 1)
class PdfFiles extends HiveObject {
  PdfFiles({required this.name, required this.path, this.isPinned = false});
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String path;
  @HiveField(2, defaultValue: false)
  late bool isPinned;

  @override
  String toString() =>
      'PdfFiles(name: $name, path: $path, isPinned: $isPinned)';
}
