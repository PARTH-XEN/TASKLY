// lib/services/update_service.dart
//
// TASKLY In-App Update Service
// ─────────────────────────────────────────────────────────────────────────────
// Fetches version.json from your GitHub repository to detect new releases.
// When a newer version is available, surfaces an update banner on the dashboard
// and a "Check for Update" tile in Settings.
//
// HOW TO CONFIGURE FOR YOUR REPO
// ───────────────────────────────
// 1. Create a GitHub repository for TASKLY.
// 2. Push your code, including version.json at the repo root.
// 3. Replace YOUR_USERNAME below with your actual GitHub username.
// 4. When releasing a new version:
//    a. Update pubspec.yaml version (e.g. 1.0.1+2)
//    b. Update version.json with the same version and build numbers.
//    c. Build the APK: flutter build apk --release
//    d. Create a GitHub Release and upload app-release.apk as an asset.
//    e. Commit and push version.json — existing installs detect it on next launch.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CONFIGURATION — Replace YOUR_USERNAME with your GitHub username.
// ─────────────────────────────────────────────────────────────────────────────
const String _versionCheckUrl =
    'https://raw.githubusercontent.com/PARTH-XEN/taskly/main/version.json';

/// The version currently installed on the device.
/// Must match pubspec.yaml → version field (before the +build number).
const String _currentVersion = '1.0.0';

/// The build number currently installed on the device.
/// Must match pubspec.yaml → version field (after the +).
const int _currentBuild = 1;

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

/// Holds information about a newer version available on GitHub Releases.
class UpdateInfo {
  final String version;
  final int build;
  final String downloadUrl;
  final String releaseNotes;

  const UpdateInfo({
    required this.version,
    required this.build,
    required this.downloadUrl,
    required this.releaseNotes,
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) => UpdateInfo(
    version: (json['version'] as String?) ?? _currentVersion,
    build: (json['build'] as int?) ?? _currentBuild,
    downloadUrl: (json['downloadUrl'] as String?) ?? '',
    releaseNotes: (json['releaseNotes'] as String?) ?? '',
  );

  @override
  String toString() => 'UpdateInfo(version: $version, build: $build)';
}

// ─────────────────────────────────────────────────────────────────────────────
// Service
// ─────────────────────────────────────────────────────────────────────────────

class UpdateService {
  static const Duration _timeout = Duration(seconds: 10);

  /// Fetches version.json and returns [UpdateInfo] when a newer version exists,
  /// or null when the app is already up-to-date, offline, or if any error occurs.
  ///
  /// This method NEVER throws — all errors are caught and silently ignored so
  /// that a failed update check never disrupts the user experience.
  Future<UpdateInfo?> checkForUpdate() async {
    // If the user has not configured the URL, skip silently.
    if (_versionCheckUrl.contains('YOUR_USERNAME')) return null;

    try {
      final response = await http
          .get(Uri.parse(_versionCheckUrl))
          .timeout(_timeout);

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final info = UpdateInfo.fromJson(json);

      // Compare semantic version: treat version string as dot-separated ints,
      // then fall back to build number for patch-only releases.
      if (_isNewer(info.version, info.build)) {
        return info;
      }
      return null;
    } on SocketException {
      // Device is offline — silent fail.
      return null;
    } on TimeoutException {
      // Server too slow — silent fail.
      return null;
    } on FormatException {
      // Malformed JSON — silent fail.
      return null;
    } catch (_) {
      // Any other error — silent fail.
      return null;
    }
  }

  /// Opens the APK download URL in the system browser.
  /// Android will prompt to install once the download finishes.
  /// Returns false if the URL cannot be launched (e.g. empty placeholder).
  Future<bool> launchDownload(String url) async {
    if (url.isEmpty || url.contains('YOUR_USERNAME')) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Returns true when [remoteVersion]/[remoteBuild] is newer than what is
  /// currently installed.
  bool _isNewer(String remoteVersion, int remoteBuild) {
    final remoteSegments = _parseVersion(remoteVersion);
    final localSegments = _parseVersion(_currentVersion);

    for (var i = 0; i < 3; i++) {
      final r = i < remoteSegments.length ? remoteSegments[i] : 0;
      final l = i < localSegments.length ? localSegments[i] : 0;
      if (r > l) return true;
      if (r < l) return false;
    }
    // Versions are equal — fall back to build number.
    return remoteBuild > _currentBuild;
  }

  List<int> _parseVersion(String v) {
    return v.split('.').map((s) => int.tryParse(s.trim()) ?? 0).toList();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Riverpod providers
// ─────────────────────────────────────────────────────────────────────────────

/// Async provider that checks for updates once per session on first read.
/// Automatically suppressed when offline or the URL is a placeholder.
final updateInfoProvider = FutureProvider<UpdateInfo?>((ref) async {
  return UpdateService().checkForUpdate();
});

/// Tracks whether the user dismissed the update banner for the current session.
/// Resets to false when the app restarts (not persisted intentionally).
final updateBannerDismissedProvider = StateProvider<bool>((_) => false);
