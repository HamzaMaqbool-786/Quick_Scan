import 'package:hive/hive.dart';

part 'scan_result_model.g.dart';

@HiveType(typeId: 1)
enum ScanType {
  @HiveField(0)
  url,
  @HiveField(1)
  email,
  @HiveField(2)
  phone,
  @HiveField(3)
  wifi,
  @HiveField(4)
  contact,
  @HiveField(5)
  sms,
  @HiveField(6)
  location,
  @HiveField(7)
  text,
}

@HiveType(typeId: 0)
class ScanResultModel extends HiveObject {
  @HiveField(0)
  final String rawValue;

  @HiveField(1)
  final String format; // QR Code, EAN-13, etc.

  @HiveField(2)
  final DateTime scannedAt;

  @HiveField(3)
  final ScanType type;

  @HiveField(4)
  bool isFavorite;

  ScanResultModel({
    required this.rawValue,
    required this.format,
    required this.scannedAt,
    required this.type,
    this.isFavorite = false,
  });

  ScanResultModel copyWith({
    String? rawValue,
    String? format,
    DateTime? scannedAt,
    ScanType? type,
    bool? isFavorite,
  }) {
    return ScanResultModel(
      rawValue: rawValue ?? this.rawValue,
      format: format ?? this.format,
      scannedAt: scannedAt ?? this.scannedAt,
      type: type ?? this.type,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
