import 'dart:typed_data';
import 'dart:ui';

import 'package:easy_trip_app/utilities/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';

final Uint8List kTransparentImage = new Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
]);
const platform = const MethodChannel("com.ryuujo/easy-trip");

TimeOfDay getTimeByMinutes(int minute) {
  return TimeOfDay(minute: minute % 60, hour: (minute / 60).floor());
}

R apply<T, R>(T x, R Function(T) f) {
  return f(x);
}

extension let_ext on dynamic {
  R let<T, R>(R Function(T) f) => apply(this as T, f);

  void set<T>(Function(T) f) => f(this);
}

void notImplemented(BuildContext context, {String? name}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${name ?? "This is"} not implemented. :)"),
      duration: Duration(milliseconds: 1000),
      behavior: SnackBarBehavior.floating,
    ));

TextStyle defaultTextStyle = TextStyle(
  color: Color(0xff666666),
  fontSize: 16,
  fontFamily: "思源黑体",
  fontWeight: FontWeight.w300,
);

extension CNM on ScreenUtil {
  Widget getFixedTag(String tag) {
    MaterialColor color = Colors.cyan;
    TextStyle textStyle = TextStyle(
      color: color[800]!,
      fontSize: setSp(26),
    );
    var textWidget = Text(tag,
        style: textStyle,
        strutStyle: StrutStyle(
          fontSize: textStyle.fontSize,
          fontWeight: textStyle.fontWeight,
          forceStrutHeight: true,
        ));
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
              height: setHeight(32),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: color[50],
                  border: null, //Border.all(color: color[400]!, width: 0.6),
                  borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: setHeight(3),
                    bottom: setHeight(3)),
                child: textWidget,
              ),
            ),
    );
  }
}

InputDecoration getInputDecoration(Size size, {String? placeholder}) =>
    InputDecoration(
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(size.height / 2)),
          gapPadding: size.height / 1.6 //TODO: figure out how it should be set
          ),

      /// Error
      errorStyle: TextStyle(
        color: Color(0xffff6666),
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      errorText: null,
      prefix: SizedBox(width: size.height / 4),

      hintText: placeholder,
      hintStyle: defaultTextStyle.copyWith(color: Colors.grey[400]),

      /// Focused
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.green,
          ),
          borderRadius: BorderRadius.all(Radius.circular(size.height / 2)),
          gapPadding: size.height / 1.6 //TODO: figure out how it should be set
          ),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.redAccent),
          borderRadius: BorderRadius.all(Radius.circular(size.height / 2)),
          gapPadding: size.height / 1.6 //TODO: figure out how it should be set
          ),
    );

Widget popupWaiting(BuildContext context, {String? description}) {
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
                      child: Text(description ?? "Loading..."),
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
