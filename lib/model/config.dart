import 'package:get/get.dart';

import '../services/storage_service.dart';

class Config {
  static var configContainer = Get.put(StorageService()).getHiveBox('config');

  bool get isLoggedIn => configContainer.get(
        'isLoggedIn',
        defaultValue: false,
      );

  String? get userId =>
      Uri.decodeFull(configContainer.get('userId', defaultValue: ""));

  String get user => configContainer.get('user');
  String get company => configContainer.get('company') ?? "";

  String? get primaryCacheKey {
    if (baseUrl == null || userId == null) return null;
    return "$baseUrl$userId";
  }

  String get version => configContainer.get('version');
  String get prNo => configContainer.get('prNo');

  String? get baseUrl => configContainer.get('baseUrl');
  String? get stats => configContainer.get('stats');
  String? get profile => configContainer.get('baseUrl');

  Uri? get uri {
    if (baseUrl == null) return null;
    return Uri.parse(baseUrl!);
  }

  static Future set(String k, dynamic v) async {
    configContainer.put(k, v);
  }

  static Future clear() async {
    configContainer.clear();
  }

  static Future remove(String k) async {
    configContainer.delete(k);
  }
}
