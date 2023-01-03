// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_recent_search.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyRecentSearchAdapter extends TypeAdapter<MyRecentSearch> {
  @override
  final int typeId = 6;

  @override
  MyRecentSearch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyRecentSearch(
      fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MyRecentSearch obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.recent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyRecentSearchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
