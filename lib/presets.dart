import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
