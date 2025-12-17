// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_news_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedNewsDataAdapter extends TypeAdapter<CachedNewsData> {
  @override
  final int typeId = 0;

  @override
  CachedNewsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedNewsData(
      newsJsonList: (fields[0] as List).cast<String>(),
      timestamp: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CachedNewsData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.newsJsonList)
      ..writeByte(1)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedNewsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
