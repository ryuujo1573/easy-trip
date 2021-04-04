import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

R let<T,R>(T x,R Function() f) {
  return f();
}

extension let_ext on dynamic {
   R let<T,R>(R Function(T) f) => f(this);
   void set<T>(Function(T) f) => f(this);
}

void notImplemented(BuildContext context, {String? name}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${name ?? "This is"} not implemented. :)"),
      duration: Duration(milliseconds: 1000),
      behavior: SnackBarBehavior.floating,
    ));

TextStyle defaultTextStyle = TextStyle(
  color: Color(0xffb1bfca),
  fontSize: 18,
  fontFamily: "思源黑体",
  fontWeight: FontWeight.w300,
);

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
