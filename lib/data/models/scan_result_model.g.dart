// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanResultModelAdapter extends TypeAdapter<ScanResultModel> {
  @override
  final int typeId = 0;

  @override
  ScanResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanResultModel(
      rawValue: fields[0] as String,
      format: fields[1] as String,
      scannedAt: fields[2] as DateTime,
      type: fields[3] as ScanType,
      isFavorite: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ScanResultModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.rawValue)
      ..writeByte(1)
      ..write(obj.format)
      ..writeByte(2)
      ..write(obj.scannedAt)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScanTypeAdapter extends TypeAdapter<ScanType> {
  @override
  final int typeId = 1;

  @override
  ScanType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ScanType.url;
      case 1:
        return ScanType.email;
      case 2:
        return ScanType.phone;
      case 3:
        return ScanType.wifi;
      case 4:
        return ScanType.contact;
      case 5:
        return ScanType.sms;
      case 6:
        return ScanType.location;
      case 7:
        return ScanType.text;
      default:
        return ScanType.text;
    }
  }

  @override
  void write(BinaryWriter writer, ScanType obj) {
    switch (obj) {
      case ScanType.url:
        writer.writeByte(0);
        break;
      case ScanType.email:
        writer.writeByte(1);
        break;
      case ScanType.phone:
        writer.writeByte(2);
        break;
      case ScanType.wifi:
        writer.writeByte(3);
        break;
      case ScanType.contact:
        writer.writeByte(4);
        break;
      case ScanType.sms:
        writer.writeByte(5);
        break;
      case ScanType.location:
        writer.writeByte(6);
        break;
      case ScanType.text:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
