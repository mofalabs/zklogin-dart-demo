import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZkLoginStorageManager {
  static late SharedPreferences _sharedPreferences;

  static SharedPreferences get sharedPreferences => _sharedPreferences;

  static const String temporaryCacheKeyPair = "_temporary_cache_keyPair";

  static const String temporaryCacheNonce = "_temporary_cache_nonce";

  static const String temporaryCacheRandomness = "_temporary_cache_randomness";

  static const String temporaryCacheMaxEpoch = "_temporary_cache_max_epoch";

  static init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool?> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(temporaryCacheKeyPair);
    prefs.remove(temporaryCacheNonce);
    prefs.remove(temporaryCacheRandomness);
    prefs.remove(temporaryCacheMaxEpoch);
    return null;
  }

  static Future<bool> setTemporaryCacheKeyPair(String value) async {
    return await _sharedPreferences.setString(temporaryCacheKeyPair, value);
  }

  static String getTemporaryCacheKeyPair() =>
      _sharedPreferences.getString(temporaryCacheKeyPair) ?? '';

  static Future<bool> setTemporaryCacheNonce(String value) async {
    return await _sharedPreferences.setString(temporaryCacheNonce, value);
  }

  static String getTemporaryCacheNonce() =>
      _sharedPreferences.getString(temporaryCacheNonce) ?? '';

  static Future<bool> setTemporaryRandomness(String value) async {
    return await _sharedPreferences.setString(temporaryCacheRandomness, value);
  }

  static String getTemporaryRandomness() =>
      _sharedPreferences.getString(temporaryCacheRandomness) ?? '';

  static Future<bool> setTemporaryMaxEpoch(int value) async {
    return await _sharedPreferences.setInt(temporaryCacheMaxEpoch, value);
  }

  static int getTemporaryMaxEpoch() =>
      _sharedPreferences.getInt(temporaryCacheMaxEpoch) ?? 0;

  static String location() {
    if (kIsWeb) return 'LocalStorage';
    if (Platform.isIOS || Platform.isMacOS) return 'NSUserDefaults';
    if (Platform.isAndroid) return 'SharedPreferences';
    if (Platform.isLinux) return 'XDG_DATA_HOME directory';
    if (Platform.isWindows) return 'Roaming AppData directory';
    throw ArgumentError('unsupport');
  }
}
