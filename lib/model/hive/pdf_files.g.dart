// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_files.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PdfFilesAdapter extends TypeAdapter<PdfFiles> {
  @override
  final int typeId = 1;

  @override
  PdfFiles read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PdfFiles(
      name: fields[0] as String,
      path: fields[1] as String,
      isPinned: fields[2] == null ? false : fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PdfFiles obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.isPinned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfFilesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
