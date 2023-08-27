import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as TM;
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_logger/dio_logger.dart';
import 'package:fmanager/utils/helpers.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../model/config.dart';

class DioHelper {
  static Dio? dio;
  static String? cookies;

  static Future init(String baseUrl) async {
    var cookieJar = await getCookiePath();
    dio = Dio(
      BaseOptions(
        baseUrl: "$baseUrl/api",
      ),
    )
      ..interceptors.add(
        CookieManager(cookieJar),
      )
      ..interceptors.add(dioLoggerInterceptor)
      ..interceptors.add(AuthInterceptor());

    dio?.options.connectTimeout = 6000;
    dio?.options.receiveTimeout = 6000;
    Dio x = dio!;
    Get.lazyPut(() => x, fenix: true);
  }

  static Future initCookies() async {
    cookies = await getCookies();
  }

  static Future<PersistCookieJar> getCookiePath() async {
    Directory appDocDir = await getApplicationSupportDirectory();
    String appDocPath = appDocDir.path;
    return PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath));
  }

  static Future<String?> getCookies() async {
    var cookieJar = await getCookiePath();
    if (Config().uri != null) {
      var cookies = await cookieJar.loadForRequest(Config().uri!);

      var cookie = CookieManager.getCookies(cookies);

      return cookie;
    } else {
      return null;
    }
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      await clearLoginInfo();
    }
    super.onError(err, handler);
  }

  @override
  Future<void> onResponse(
      TM.Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401 || response.statusCode == 403) {
      if (!Get.currentRoute.contains("login")) {
        Get.offAndToNamed("login");
      }
    }
    super.onResponse(response, handler);
  }
}
