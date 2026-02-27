import 'package:hive/hive.dart';
import '../models/scan_result_model.dart';
import '../../core/constants/app_constants.dart';

class ScanRepository {
  Box<ScanResultModel> get _box => Hive.box<ScanResultModel>(AppConstants.scansBox);

  // ─── CREATE ───────────────────────────────────────────────────────────────
  Future<void> saveScan(ScanResultModel scan) async {
    await _box.add(scan);
    _enforceHistoryLimit();
  }

  // ─── READ ─────────────────────────────────────────────────────────────────
  List<ScanResultModel> getAllScans() {
    return _box.values.toList().reversed.toList();
  }

  List<ScanResultModel> searchScans(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return getAllScans();
    return _box.values
        .where((s) => s.rawValue.toLowerCase().contains(q))
        .toList()
        .reversed
        .toList();
  }

  List<ScanResultModel> filterByType(ScanType? type) {
    if (type == null) return getAllScans();
    return _box.values
        .where((s) => s.type == type)
        .toList()
        .reversed
        .toList();
  }

  List<ScanResultModel> getFavorites() {
    return _box.values
        .where((s) => s.isFavorite)
        .toList()
        .reversed
        .toList();
  }

  int get totalCount => _box.length;

  // ─── UPDATE ───────────────────────────────────────────────────────────────
  Future<void> toggleFavorite(ScanResultModel scan) async {
    scan.isFavorite = !scan.isFavorite;
    await scan.save();
  }

  // ─── DELETE ───────────────────────────────────────────────────────────────
  Future<void> deleteScan(ScanResultModel scan) async {
    await scan.delete();
  }

  Future<void> deleteScanAtIndex(int index) async {
    final scans = getAllScans();
    if (index < scans.length) {
      await scans[index].delete();
    }
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  void _enforceHistoryLimit() {
    const limit = AppConstants.defaultHistoryLimit;
    if (_box.length > limit) {
      // Remove oldest entries
      final excess = _box.length - limit;
      final keys = _box.keys.take(excess).toList();
      _box.deleteAll(keys);
    }
  }
}
