// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnimeModelAdapter extends TypeAdapter<AnimeModel> {
  @override
  final int typeId = 0;

  @override
  AnimeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnimeModel(
      name: fields[1] as String,
      updateWeekday: fields[2] as String,
      updateTime: fields[3] as String,
      currentEpisode: fields[4] as int,
      totalEpisode: fields[5] as int,
      cover: fields[6] as String,
    )
      ..id = fields[0] as String
      ..createdAt = fields[7] as DateTime;
  }

  @override
  void write(BinaryWriter writer, AnimeModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.updateWeekday)
      ..writeByte(3)
      ..write(obj.updateTime)
      ..writeByte(4)
      ..write(obj.currentEpisode)
      ..writeByte(5)
      ..write(obj.totalEpisode)
      ..writeByte(6)
      ..write(obj.cover)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
