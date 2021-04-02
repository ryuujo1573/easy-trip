import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ECard extends StatelessWidget {
  ECard({
    required this.title,
    this.titleStyle,
    this.width,
    this.height,
    this.elevation = 4,
    this.borderRadius = 18,
    this.isCompat = false,
    required this.child,
  }) {
    if (titleStyle == null) {
      titleStyle = defaultStyle;
    }
  }

  final String title;

  double? width;
  double? height;
  double elevation;
  double borderRadius;

  bool isCompat; //TODO: design two layouts with different density.
  Widget child;

  static final defaultStyle = const TextStyle(
      color: Colors.black54,
      fontSize: 18,
      fontFamily: "思源黑体", //TODO: check whether its spell is right.
      fontWeight: FontWeight.w700);

  static TextStyle getSubtitleStyle({TextStyle? titleStyle}) =>
      (titleStyle ?? defaultStyle).copyWith(
        color: Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.w300,
      );

  TextStyle? titleStyle;

  TextStyle subtitleStyle() => getSubtitleStyle(titleStyle: titleStyle);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width,
      // height: height,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        elevation: elevation,
        child: Row(
          children: [
            Spacer(),
            Flexible(
              flex: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                // [-] ListView
                // primary: false,
                // padding: EdgeInsetsDirectional.only(top: 32, bottom: 32, start: 28, end: 28),
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: titleStyle,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      child,
                    ],
                  ),
                  SizedBox(height: 24)
                ],
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
