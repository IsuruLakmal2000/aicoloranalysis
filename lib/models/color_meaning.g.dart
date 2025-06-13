// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_meaning.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ColorMeaningAdapter extends TypeAdapter<ColorMeaning> {
  @override
  final int typeId = 3;

  @override
  ColorMeaning read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColorMeaning(
      id: fields[0] as String,
      colorHex: fields[1] as String,
      colorName: fields[2] as String,
      shortDescription: fields[3] as String,
      psychologicalEffects: fields[4] as String,
      culturalAssociations: fields[5] as String,
      commonUses: (fields[6] as List).cast<String>(),
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ColorMeaning obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.colorHex)
      ..writeByte(2)
      ..write(obj.colorName)
      ..writeByte(3)
      ..write(obj.shortDescription)
      ..writeByte(4)
      ..write(obj.psychologicalEffects)
      ..writeByte(5)
      ..write(obj.culturalAssociations)
      ..writeByte(6)
      ..write(obj.commonUses)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorMeaningAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
