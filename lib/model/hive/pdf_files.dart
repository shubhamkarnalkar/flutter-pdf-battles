import 'package:hive/hive.dart';

part 'pdf_files.g.dart';

@HiveType(typeId: 1)
class PdfFiles extends HiveObject {
  PdfFiles({required this.name, required this.path});
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String path;

  @override
  String toString() => 'PdfFiles(name: $name, path: $path)';
}
