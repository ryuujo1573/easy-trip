import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
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
  late SharedPreferences _prefs;

  @override
  Future<void> delete(String key) async {
    _prefs.remove(key);
  }

  @override
  Future<void> deleteAll(List<String> keys) async {
    keys.forEach((element) => _prefs.remove);
  }

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<String?> read(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> write(String key, String value) async {
    print('write: $key:$value');
    _prefs.setString(key, value);
  }
}

class User {
  static Dio request = Dio()..interceptors.add(CookieManager(cookieJar));
  static PersistCookieJar cookieJar =
      PersistCookieJar(storage: SharedPrefStorage());
  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();
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

    request
        .get('https://api.ryuujo.com/login/logout')
        .then((result) => print('Log out: ${result.data}'));
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
      return await request
          .post("https://api.ryuujo.com/login/login", data: data)
          .then((response) {

        print('Log in: ${response.data} @method: $type');
        if (response.data == 'Access Granted') {
          return LoginResult.ok;
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
