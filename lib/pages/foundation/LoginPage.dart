import 'dart:async';
import 'dart:ui';

import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:easy_trip_app/utilities/user_state.dart';
import 'package:easy_trip_app/utilities/screen_util.dart';
import 'package:easy_trip_app/widgets/EBox.dart';
import 'package:easy_trip_app/presets.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<StatefulWidget>
    with WidgetsBindingObserver, ScreenUtil, SingleTickerProviderStateMixin {
  var _userAccountController = TextEditingController();
  var _userPwdController = TextEditingController();

  // if debug fixme
  var _errorController = TextEditingController();

  // endif debug

  int? respCode;
  String? result;
  CookieJar cookieJar = CookieJar();
  CookieManager? cookieManager;

  bool performingLogin = false;

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
                      onPressed: () async {
                        setState(() => performingLogin = true);
                        var entry = OverlayEntry(builder: _popupWaiting);
                        Overlay.of(context)!.insert(entry);
                        User.login(
                                account: _userAccountController.value.text,
                                password: _userPwdController.value.text)
                            .then((value) async {
                                  setState(() {
                                    _errorController.value = TextEditingValue(
                                        text: value.toString());
                                  });
                                  await Future.delayed(Duration(seconds: 3));
                                  if (value == LoginResult.ok)
                                    Navigator.of(context).pop();
                                  entry.remove();
                                });
                      },
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

Widget _popupWaiting(BuildContext context) {
  // AnimationController controller = AnimationController(
  //     vsync: context.widget as SingleTickerProviderStateMixin,
  //     duration: Duration(milliseconds: 1300));

  return Stack(
    children: [
      FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child:
              // AnimatedBuilder(
              //   animation: controller,
              //   builder: (BuildContext context, Widget? child) {
              //     return
              BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 8, //controller.value,
              sigmaY: 8, //controller.value,
            ),
            //     child: child,
            //   );
            // },
            child: AnimatedOpacity(
                opacity: 0.2,
                duration: Duration(seconds: 1),
                child: Container(color: Colors.black)),
          )),
      Center(
        child: FractionallySizedBox(
          widthFactor: 0.4,
          child: AspectRatio(
            aspectRatio: 1,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Stack(
                children: [
                  Center(
                    child: FractionallySizedBox(
                        widthFactor: 0.2,
                        child: LoadingIndicator(
                          indicatorType: Indicator.circleStrokeSpin,
                          color: Colors.black,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text("Logging..."),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
