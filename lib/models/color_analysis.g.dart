// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_analysis.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColorAnalysisAdapter extends TypeAdapter<ColorAnalysis> {
  @override
  final int typeId = 1;

  @override
  ColorAnalysis read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColorAnalysis(
      id: fields[0] as String,
      seasonType: fields[1] as String,
      primaryColors: (fields[2] as List).cast<String>(),
      description: fields[3] as String,
      styleTips: (fields[4] as List).cast<String>(),
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ColorAnalysis obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.seasonType)
      ..writeByte(2)
      ..write(obj.primaryColors)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.styleTips)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorAnalysisAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
