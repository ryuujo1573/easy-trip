import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:easy_trip_app/utilities/user_state.dart';
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
    with WidgetsBindingObserver, ScreenUtil {
  var _userAccountController = TextEditingController();
  var _userPwdController = TextEditingController();

  // if debug
  var _errorController = TextEditingController();

  // endif debug

  int? respCode;
  String? result;
  CookieJar cookieJar = CookieJar();
  CookieManager? cookieManager;

  @override
  Widget build(BuildContext context) {
    double autoWidthText = setWidth(550);
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
      ),
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: OverflowBox(
              alignment: Alignment.center,
              child: Column(
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
                      onPressed: () => User.login(
                              account: _userAccountController.value.text,
                              password: _userPwdController.value.text)
                          .then((value) => setState(() {
                                _errorController.value =
                                    TextEditingValue(text: value.toString());
                              })),
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
