import 'dart:io';

import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 存储用户名
enum LoginResult {
  ok,
  certificationFailed,
  unimplemented,
  illegalRequest,
  formatError,
  unknown
}

class SharedPrefStorage extends Storage {
  @override
  Future<void> delete(String key) {
    return SharedPreferences.getInstance().then((value) => value.remove(key));
  }

  @override
  Future<void> deleteAll(List<String> keys) async {
    return keys.forEach((element) async =>
        SharedPreferences.getInstance().then((value) => value.remove));
  }

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {}

  @override
  Future<String?> read(String key) {
    return SharedPreferences.getInstance()
        .then((value) => value.getString(key));
  }

  @override
  Future<void> write(String key, String _value) {
    print('write: $key:$_value');
    return SharedPreferences.getInstance()
        .then((value) => value.setString(key, _value));
  }
}

class User {
  factory User() => _getInstance();
  static User get instance => _instance;
  static late User _instance;

  static late int? id;
  static late String? name;

  //todo: 整一个登录回调，如果需要登录且没有登录态就跳到指定的页面!


  User._internal() {
    // request.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) async {
    //     var prefs = await SharedPreferences.getInstance();
    //     var sessionId = prefs.getString('_sessionId');
    //     if (sessionId != null && sessionId.isNotEmpty) {
    //       options.headers
    //         ..addAll({
    //           'Set-Cookie': 'sessionId=$sessionId',
    //         });
    //     }
    //     handler.next(options);
    //   },
    // ));
    // getApplicationDocumentsDirectory().then(
    //   (value) => request
    //     ..interceptors.add(
    //       CookieManager(
    //         cookieJar,
    //         // CookieJar()
    //       ),
    //     ),
    // );
  }

  static User _getInstance() {
    if (_instance == null) {
      _instance = new User._internal();
    }
    return _instance;
  }

  static final request = Dio();
  // static final PersistCookieJar cookieJar = PersistCookieJar(
  //     storage: SharedPrefStorage()
  //  // FileStorage('${value.path}/.cookies/'),
  // );

  static const String keyToken = 'xxxxxxxxxTK';
  static const String keyUserName = 'xxxxxxxxxUserName';

  static Future<LoginResult> login({
    required String account,
    required String password,
  }) async {
    // if (account == null || password == null) {
    //   return LoginResult.formatError;
    // }
    var data;

    // request
    //     .get('https://api.ryuujo.com/login/logout')
    //     .then((result) => print('Log out: ${result.data}'));
    String? type;
    //TODO: finish the other login methods.
    try {
      if (RegExp(r"[0-9a-zA-Z]+@\w+\.\w+").hasMatch(account)) {
        // 邮箱
        type = "email";
        data = FormData.fromMap({
          "method": "",
          "email": account,
          "password": password,
        });
      } else if (RegExp("[a-zA-Z]").hasMatch(account)) {
        // 默认没有纯数字ID
        // 昵称 (method: 2)
        type = "username";
        data = FormData.fromMap({
          "method": "2",
          "username": account,
          "password": password,
        });
      } else if (!account.contains(" ")) {
        // 手机号
        type = "phone";
        data = FormData.fromMap(({
          "method": "",
          "phone": account,
          "password": password,
        }));
      } else {
        return LoginResult.formatError;
      }
      var prefs = SharedPreferences.getInstance();
      return await request
          .post("https://api.ryuujo.com/login/login", data: data)
          .then((response) async {
        print('Log in: ${response.data} @method: $type');
        // ========================================
        // FIXME!! ==============================
        var data = response.data as Map<String, dynamic>;
        if (data['error']! == 0) {
          id = data['userID'];
          name = data['userName'];
          return
          await prefs.then((value) => value.setString('_sessionId', data['sessionID'])) ?
            LoginResult.ok : LoginResult.unknown;
        }
        String? errorCode = response.data['error']?.toString();
        if (errorCode != null) {
          switch (errorCode) {
            case '2':
              return LoginResult.ok;
            default:
              return LoginResult.certificationFailed;
          }
        } else {
          return LoginResult.unknown;
        }
      });
    } catch (exception) {
      // setState(() {
      //   _errorController.value = TextEditingValue(text: exception.toString());
      // });
      //todo: fixme!!
      print(exception.toString());
      return LoginResult.unimplemented;
    }
  }
}
