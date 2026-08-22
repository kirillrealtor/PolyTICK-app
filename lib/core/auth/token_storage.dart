import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure token storage — equivalent of `js-cookie` (Cookies.get/set/remove)
/// in the Next.js app, but using platform-secure storage with graceful memory fallback.
///
/// On iOS: Keychain
/// On Android: EncryptedSharedPreferences with fallback
class TokenStorage {
  static const _tokenKey = 'polytick_auth_token';
  static const _deviceIdKey = 'polytick_device_id';
  static const _reviewerKey = 'polytick_is_reviewer_active';
  static const _referralCodeKey = 'polytick_ref_code';
  static const _intendedPlanKey = 'polytick_intended_plan';

  // In-memory cache fallback to prevent crashes if keystore glitches
  static final Map<String, String> _memoryCache = {};

  final FlutterSecureStorage _storage;

  TokenStorage()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  // ── Auth Token ──

  Future<String?> getToken() async {
    try {
      final val = await _storage.read(key: _tokenKey);
      if (val != null) _memoryCache[_tokenKey] = val;
      return val ?? _memoryCache[_tokenKey];
    } catch (e) {
      debugPrint('TokenStorage read error: $e');
      return _memoryCache[_tokenKey];
    }
  }

  Future<void> setToken(String token) async {
    _memoryCache[_tokenKey] = token;
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      debugPrint('TokenStorage write error: $e');
    }
  }

  Future<void> clearToken() async {
    _memoryCache.remove(_tokenKey);
    try {
      await _storage.delete(key: _tokenKey);
    } catch (e) {
      debugPrint('TokenStorage delete error: $e');
    }
  }

  // ── Reviewer / Demo Mode Persistence ──

  Future<bool> isReviewerSession() async {
    try {
      final val = await _storage.read(key: _reviewerKey);
      if (val != null) _memoryCache[_reviewerKey] = val;
      return (val ?? _memoryCache[_reviewerKey]) == 'true';
    } catch (e) {
      return _memoryCache[_reviewerKey] == 'true';
    }
  }

  Future<void> setReviewerSession(bool active) async {
    final strVal = active ? 'true' : 'false';
    _memoryCache[_reviewerKey] = strVal;
    try {
      await _storage.write(key: _reviewerKey, value: strVal);
    } catch (e) {
      debugPrint('TokenStorage reviewer write error: $e');
    }
  }

  // ── Device ID (for magic link polling) ──

  Future<String?> getDeviceId() async {
    try {
      final val = await _storage.read(key: _deviceIdKey);
      if (val != null) _memoryCache[_deviceIdKey] = val;
      return val ?? _memoryCache[_deviceIdKey];
    } catch (e) {
      return _memoryCache[_deviceIdKey];
    }
  }

  Future<void> setDeviceId(String deviceId) async {
    _memoryCache[_deviceIdKey] = deviceId;
    try {
      await _storage.write(key: _deviceIdKey, value: deviceId);
    } catch (e) {
      debugPrint('TokenStorage deviceId write error: $e');
    }
  }

  Future<void> clearDeviceId() async {
    _memoryCache.remove(_deviceIdKey);
    try {
      await _storage.delete(key: _deviceIdKey);
    } catch (e) {
      debugPrint('TokenStorage deviceId delete error: $e');
    }
  }

  // ── Referral Code ──

  Future<String?> getReferralCode() async {
    try {
      final val = await _storage.read(key: _referralCodeKey);
      if (val != null) _memoryCache[_referralCodeKey] = val;
      return val ?? _memoryCache[_referralCodeKey];
    } catch (e) {
      return _memoryCache[_referralCodeKey];
    }
  }

  Future<void> setReferralCode(String code) async {
    _memoryCache[_referralCodeKey] = code;
    try {
      await _storage.write(key: _referralCodeKey, value: code);
    } catch (e) {
      debugPrint('TokenStorage referralCode write error: $e');
    }
  }

  Future<void> clearReferralCode() async {
    _memoryCache.remove(_referralCodeKey);
    try {
      await _storage.delete(key: _referralCodeKey);
    } catch (e) {
      debugPrint('TokenStorage referralCode delete error: $e');
    }
  }

  // ── Intended Plan ──

  Future<String?> getIntendedPlan() async {
    try {
      final val = await _storage.read(key: _intendedPlanKey);
      if (val != null) _memoryCache[_intendedPlanKey] = val;
      return val ?? _memoryCache[_intendedPlanKey];
    } catch (e) {
      return _memoryCache[_intendedPlanKey];
    }
  }

  Future<void> setIntendedPlan(String plan) async {
    _memoryCache[_intendedPlanKey] = plan;
    try {
      await _storage.write(key: _intendedPlanKey, value: plan);
    } catch (e) {
      debugPrint('TokenStorage intendedPlan write error: $e');
    }
  }

  Future<void> clearIntendedPlan() async {
    _memoryCache.remove(_intendedPlanKey);
    try {
      await _storage.delete(key: _intendedPlanKey);
    } catch (e) {
      debugPrint('TokenStorage intendedPlan delete error: $e');
    }
  }

  // ── Clear All ──

  Future<void> clearAll() async {
    _memoryCache.clear();
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint('TokenStorage clearAll error: $e');
    }
  }
}
