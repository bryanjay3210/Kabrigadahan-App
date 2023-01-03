// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_unremitted_donation_remittance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyUnremittedDonationRemittanceAdapter
    extends TypeAdapter<MyUnremittedDonationRemittance> {
  @override
  final int typeId = 12;

  @override
  MyUnremittedDonationRemittance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyUnremittedDonationRemittance(
      amount: fields[0] as double?,
      referenceNumber: fields[1] as String?,
      communityOfficeIdNumber: fields[2] as String?,
      communityOfficeName: fields[3] as String?,
      communityOfficeMemberId: fields[4] as String?,
      memberRemittanceMasterID: fields[5] as String?,
      transactionType: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MyUnremittedDonationRemittance obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.referenceNumber)
      ..writeByte(2)
      ..write(obj.communityOfficeIdNumber)
      ..writeByte(3)
      ..write(obj.communityOfficeName)
      ..writeByte(4)
      ..write(obj.communityOfficeMemberId)
      ..writeByte(5)
      ..write(obj.memberRemittanceMasterID)
      ..writeByte(6)
      ..write(obj.transactionType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyUnremittedDonationRemittanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
