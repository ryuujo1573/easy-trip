// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cookie_jar/cookie_jar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:easy_trip_app/utilities/screen_util.dart';
import 'package:easy_trip_app/widgets/EBox.dart';
import 'package:easy_trip_app/presets.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<StatefulWidget>
    with WidgetsBindingObserver {
  var _userAccountController = TextEditingController();
  var _userPwdController = TextEditingController();

  // debug
  var _errorController = TextEditingController();

  // debug

  int? respCode;
  String? result;
  CookieJar cookieJar = CookieJar();
  CookieManager? cookieManager;

  void _login() async {
    String account = _userAccountController.text;
    String password = _userPwdController.text;
    if (account == null || password == null) {
      return;
    }
    var dio = Dio();
    var data;

    if (cookieManager == null) {
      cookieManager = CookieManager(cookieJar);
      dio.interceptors.add(cookieManager);
      cookieJar.loadForRequest(Uri.parse("https://api.ryuujo.com/"));
    }
    dio.options = BaseOptions();
    String? type;
    //TODO: finish the other login methods.
    try {
      if (RegExp(r"[0-9a-zA-Z]+@\w+\.\w+").hasMatch(account)) {
        // 邮箱
        type = "by email";
        notImplemented(context, name: type);
        data = FormData.fromMap({
          "method": "",
          "email": account,
          "password": password,
        });
      } else if (RegExp("[a-zA-Z]").hasMatch(account)) {
        // 默认没有纯数字ID
        // 昵称 (method: 2)
        type = "by username";
        data = FormData.fromMap({
          "method": "2",
          "username": account,
          "password": password,
        });
      } else if (!account.contains(" ")) {
        // 手机号
        type = "by phone";
        data = FormData.fromMap(({
          "method": "",
          "phone": account,
          "password": password,
        }));
      } else {
        return;
      }
      await dio
          .post("https://api.ryuujo.com/login/login", // dame dane
              options: Options(),
              data: data)
          .then((response) => setState(() {
                respCode = response.statusCode;
                result = response.data.toString();
              }));
    } catch (exception) {
      setState(() {
        _errorController.value = TextEditingValue(text: exception.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double autoWidthText = ScreenUtil().setWidth(550);
    double maxWidth = 500;
    var sizeLimit = BoxConstraints(
        minWidth: 180, maxWidth: maxWidth, minHeight: 60, maxHeight: 60);
    var defaultDecoration =
        getInputDecoration(sizeLimit.constrainDimensions(autoWidthText, 60));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        title: Text(
          "Login",
          style: defaultTextStyle.copyWith(
              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        elevation: 5,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 32),
        // Key ? key,
        // Widget ? leading,
        // bool automaticallyImplyLeading = true, Widget ? title, List < Widget>?
        // actions, Widget ? flexibleSpace, PreferredSizeWidget ? bottom,
        // double ? elevation, Color ? shadowColor, ShapeBorder ? shape,
        // Color ? backgroundColor, Color ? foregroundColor,
        // Brightness ? brightness, IconThemeData ? iconTheme,
        // IconThemeData ? actionsIconTheme, TextTheme ? textTheme, bool primary
        // = true, bool ? centerTitle, bool excludeHeaderSemantics = false,
        // double ? titleSpacing, double toolbarOpacity = 1.0, double
        // bottomOpacity = 1.0, double ? toolbarHeight, double ? leadingWidth,
        // bool ? backwardsCompatibility, TextStyle ? toolbarTextStyle,
        // TextStyle ? titleTextStyle, SystemUiOverlayStyle ? systemOverlayStyle
      ),
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: OverflowBox(
              alignment: Alignment.center,
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(

                  // Column is also a layout widget. It takes a list of children and
                  // arranges them vertically. By default, it sizes itself to fit its
                  // children horizontally, and tries to be as tall as its parent.
                  //
                  // Invoke "debug painting" (press "p" in the console, choose the
                  // "Toggle Debug Paint" action from the Flutter Inspector in Android
                  // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                  // to see the wireframe for each widget.
                  //
                  // Column has various properties to control how it sizes itself and
                  // how it positions its children. Here we use mainAxisAlignment to
                  // center the children vertically; the main axis here is the vertical
                  // axis because Columns are vertical (the cross axis would be
                  // horizontal).
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: sizeLimit,
                      child: Container(
                          width: autoWidthText,
                          height: 60,
                          child: TextField(
                            keyboardType: TextInputType.text,
                            style: defaultTextStyle,
                            decoration: defaultDecoration.copyWith(
                                hintText: "Account (Nickname / Phone / Mail)",
                                counterText: ''),
                            controller: _userAccountController,
                            maxLength: 18,
                          )),
                    ),
                    SizedBox(height: 25),
                    ConstrainedBox(
                        constraints: sizeLimit,
                        child: Container(
                            width: autoWidthText,
                            height: 60,
                            child: TextField(
                              style: defaultTextStyle,
                              obscureText: true,
                              // or not,
                              decoration: defaultDecoration.copyWith(
                                  hintText: "Password", counterText: ''),
                              controller: _userPwdController,
                              maxLength: 18,
                            ))),
                    SizedBox(height: 25),
                    EBox(
                      height: 60,
                      width:
                          (autoWidthText > maxWidth) ? maxWidth : autoWidthText,
                      text: "Log in",
                      onPressed: _login,
                    ),
                    SizedBox(height: 20),
                    LimitedBox(
                        maxWidth: 500,
                        child: Container(
                          height: 50,
                          width: autoWidthText,
                          color: Colors.grey[200],
                          alignment: FractionalOffset.center,
                          child: Text(
                            (respCode == null)
                                ? "debug output :)"
                                : "[$respCode]: $result",
                            style: TextStyle(
                              color: Color(0xff6666ff),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )),
                    Container(
                      width: autoWidthText,
                      height: 100,
                      color: Colors.grey[100],
                      alignment: Alignment.topCenter,
                      child: TextField(
                        scrollController: ScrollController(),
                        scrollPhysics: BouncingScrollPhysics(),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        enabled: false,
                        textAlign: TextAlign.left,
                        controller: _errorController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                      ),
                    ),
                  ]))),
    );
  }
}
