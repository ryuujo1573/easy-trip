/*
 * Created by 李卓原 on 2018/9/29.
 * email: zhuoyuan93@gmail.com
 *
 * Modified by ryuujo on 2021/3/7
 */

import 'package:flutter/material.dart';

class ScreenUtil {
  static ScreenUtil instance = new ScreenUtil();

  //设计稿的设备尺寸修改
  static const width = 750;
  static const height = 1334;
  bool allowFontScaling = false;

  static MediaQueryData? _mediaQueryData;
  static double? _screenWidth;
  static double? _screenHeight;
  static double? _pixelRatio;
  static double? _statusBarHeight;
  static double? _bottomBarHeight;
  static double? _textScaleFactor;

  static void Initialize(BuildContext context) {

  }

  void init(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _mediaQueryData = mediaQuery;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = _mediaQueryData!.padding.bottom;
    _textScaleFactor = mediaQuery.textScaleFactor;
  }

  static MediaQueryData get mediaQueryData => _mediaQueryData!;

  ///每个逻辑像素的字体像素数，字体的缩放比例
  static double get textScaleFactory => _textScaleFactor!;

  ///设备的像素密度
  static double get pixelRatio => _pixelRatio!;

  ///当前设备宽度 dp
  static double get screenWidthDp => _screenWidth!;

  ///当前设备高度 dp
  static double get screenHeightDp => _screenHeight!;

  ///当前设备宽度 px
  static double get screenWidth => _screenWidth! * _pixelRatio!;

  ///当前设备高度 px
  static double get screenHeight => _screenHeight! * _pixelRatio!;

  ///状态栏高度 刘海屏会更高
  static double get statusBarHeight => _statusBarHeight! * _pixelRatio!;

  ///底部安全区距离
  static double get bottomBarHeight => _bottomBarHeight! * _pixelRatio!;

  ///实际的dp与设计稿px的比例
  get scaleWidth => _screenWidth! / width;

  get scaleHeight => _screenHeight! / height;

  ///根据设计稿的设备宽度适配
  ///高度也根据这个来做适配可以保证不变形
  setWidth(double width) => width * scaleWidth;

  /// 根据设计稿的设备高度适配
  /// 当发现设计稿中的一屏显示的与当前样式效果不符合时,
  /// 或者形状有差异时,高度适配建议使用此方法
  /// 高度适配主要针对想根据设计稿的一屏展示一样的效果
  setHeight(double height) => height * scaleHeight;

  ///字体大小适配方法
  ///@param fontSize 传入设计稿上字体的px ,
  ///@param allowFontScaling 控制字体是否要根据系统的“字体大小”辅助选项来进行缩放。默认值为true。
  ///@param allowFontScaling Specifies whether fonts should scale to respect Text Size accessibility settings. The default is true.
  setSp(double fontSize) => allowFontScaling
      ? setWidth(fontSize)
      : setWidth(fontSize) / _textScaleFactor;
}
