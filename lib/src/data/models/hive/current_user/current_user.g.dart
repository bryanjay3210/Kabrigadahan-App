// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentUserAdapter extends TypeAdapter<CurrentUser> {
  @override
  final int typeId = 0;

  @override
  CurrentUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentUser(
      name: fields[0] as String?,
      profilepicture: fields[1] as String?,
      barangay: fields[2] as String?,
      purok: fields[3] as String?,
      mobileNumber: fields[4] as String?,
      imageFileToken: fields[5] as String?,
      memberId: fields[6] as String?,
      idNumber: fields[7] as String?,
      birthdate: fields[8] as DateTime?,
      membershipLevel: fields[9] as int?,
      assignedOfficer: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentUser obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.profilepicture)
      ..writeByte(2)
      ..write(obj.barangay)
      ..writeByte(3)
      ..write(obj.purok)
      ..writeByte(4)
      ..write(obj.mobileNumber)
      ..writeByte(5)
      ..write(obj.imageFileToken)
      ..writeByte(6)
      ..write(obj.memberId)
      ..writeByte(7)
      ..write(obj.idNumber)
      ..writeByte(8)
      ..write(obj.birthdate)
      ..writeByte(9)
      ..write(obj.membershipLevel)
      ..writeByte(10)
      ..write(obj.assignedOfficer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
