import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../data/models/scan_result_model.dart';
import '../../data/repositories/scan_repository.dart';
import '../../core/utils/url_detector.dart';
import '../../core/theme/app_colors.dart';

class ResultController extends GetxController {
  final _repo = Get.find<ScanRepository>();

  late final ScanResultModel scan;
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    scan = Get.arguments as ScanResultModel;
    isFavorite.value = scan.isFavorite;
  }

  // ── Copy ──────────────────────────────────────────────────────────────────
  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: scan.rawValue));
    _toast('Copied to clipboard!');
  }

  // ── Share ─────────────────────────────────────────────────────────────────
  Future<void> shareResult() async {
    await Share.share(
      scan.rawValue,
      subject: 'Scanned ${UrlDetector.getDisplayType(scan.type)}',
    );
  }

  // ── Open URL ──────────────────────────────────────────────────────────────
  Future<void> openUrl() async {
    String raw = scan.rawValue.trim();

    // Ensure scheme is present
    if (!raw.startsWith('http://') && !raw.startsWith('https://')) {
      raw = 'https://$raw';
    }

    final uri = Uri.tryParse(raw);
    if (uri == null) {
      _toast('Invalid URL', isError: true);
      return;
    }

    try {
      // ✅ launchMode externalApplication — forces the OS browser
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        // Fallback: try platform default
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      _toast('Could not open URL', isError: true);
    }
  }

  // ── Open Email ────────────────────────────────────────────────────────────
  Future<void> openEmail() async {
    final email = scan.rawValue.replaceFirst('mailto:', '').trim();
    final uri = Uri(scheme: 'mailto', path: email);
    try {
      await launchUrl(uri);
    } catch (_) {
      _toast('No email app found', isError: true);
    }
  }

  // ── Call Phone ────────────────────────────────────────────────────────────
  Future<void> callPhone() async {
    final phone = scan.rawValue
        .replaceFirst('tel:', '')
        .replaceFirst('phone:', '')
        .trim();
    final uri = Uri(scheme: 'tel', path: phone);
    try {
      await launchUrl(uri);
    } catch (_) {
      _toast('No phone app found', isError: true);
    }
  }

  // ── Send SMS ──────────────────────────────────────────────────────────────
  Future<void> openSms() async {
    final number = scan.rawValue
        .replaceFirst('smsto:', '')
        .replaceFirst('sms:', '')
        .trim();
    final uri = Uri(scheme: 'sms', path: number);
    try {
      await launchUrl(uri);
    } catch (_) {
      _toast('No SMS app found', isError: true);
    }
  }

  // ── Favourite ─────────────────────────────────────────────────────────────
  Future<void> toggleFavorite() async {
    await _repo.toggleFavorite(scan);
    isFavorite.value = scan.isFavorite;
    _toast(isFavorite.value ? 'Added to favorites ★' : 'Removed from favorites');
  }

  // ── Delete ────────────────────────────────────────────────────────────────
  Future<void> deleteScan() async {
    await _repo.deleteScan(scan);
    Get.back();
    _toast('Scan deleted');
  }

  void scanAgain() => Get.back();

  // ── Helper ────────────────────────────────────────────────────────────────
  void _toast(String msg, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: isError ? AppColors.errorDim : AppColors.surface,
      textColor: isError ? AppColors.error : AppColors.textPrimary,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
