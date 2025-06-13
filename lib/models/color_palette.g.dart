// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_palette.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColorPaletteAdapter extends TypeAdapter<ColorPalette> {
  @override
  final int typeId = 2;

  @override
  ColorPalette read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColorPalette(
      id: fields[0] as String,
      name: fields[1] as String,
      colors: (fields[2] as List).cast<String>(),
      description: fields[3] as String?,
      imageUrl: fields[4] as String?,
      createdAt: fields[5] as DateTime,
      mood: fields[6] as String?,
      usageTips: (fields[7] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ColorPalette obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.colors)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.mood)
      ..writeByte(7)
      ..write(obj.usageTips);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorPaletteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
