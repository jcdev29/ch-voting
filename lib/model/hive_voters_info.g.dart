// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_voters_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveVotersInfoAdapter extends TypeAdapter<HiveVotersInfo> {
  @override
  final int typeId = 1;

  @override
  HiveVotersInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveVotersInfo(
      firstName: fields[0] as String,
      middleName: fields[1] as String,
      lastName: fields[2] as String,
      sex: fields[3] as String,
      birthdate: fields[4] as String,
      address: fields[5] as String,
      contactNumber: fields[6] as String,
      emailAddress: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveVotersInfo obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.middleName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.sex)
      ..writeByte(4)
      ..write(obj.birthdate)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.contactNumber)
      ..writeByte(7)
      ..write(obj.emailAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveVotersInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
