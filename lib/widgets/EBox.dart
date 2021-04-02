import 'package:flutter/material.dart';

class EBox extends StatefulWidget {
  @override
  _EBoxState createState() => _EBoxState();

  EBox(
      {Key? key, this.width, this.height, this.text = "default", this.onPressed})
      : super(key: key) {}

  final Color defaultColor = Color(0xFF26BB99);
  final double? width;
  final double? height;
  final String text;
  final void Function()? onPressed;
}

class _EBoxState extends State<EBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: OutlinedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
            minimumSize:
                MaterialStateProperty.all(Size(widget.width!, widget.height!)),
            // foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed))
                return Color(widget.defaultColor.value - 0x101010); // TODO: 修复RGB+?后溢出的问题
              if (states.contains(MaterialState.hovered))
                return Color(widget.defaultColor.value - 0x33000000);
              return widget.defaultColor;
            }),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: BorderSide(color: widget.defaultColor),
                  borderRadius: BorderRadius.all(Radius.circular(widget.height! / 2))
                )
            ),
          animationDuration: Duration(milliseconds: 1500)
        ),
        // style: ButtonStyle(
        //     textStyle: MaterialStateProperty.resolveWith((states) {
        //       TextStyle getStyle({int color = 0xFFEFEFFF, FontWeight weight = FontWeight.w100}) {
        //         return TextStyle(
        //           color:
        //           // (inputString == "") ?
        //           Color(color)
        //           // : (isEditing ? Color(0xff111111) : Color(0xff000000))
        //           ,
        //           fontSize: 18.0,
        //           fontFamily: 'Source Han Sans SC',
        //           fontWeight: FontWeight.w100,
        //         );
        //       }
        //       switch(states.first){
        //         case MaterialState.pressed:
        //           return getStyle(color: 0xFFFFFFFF);
        //         case MaterialState.focused:
        //           return getStyle(weight: FontWeight.w500);
        //         case MaterialState.hovered:
        //           return getStyle();
        //         case MaterialState.disabled:
        //           return getStyle(color: 0xFFCCCCFF);
        //         default:
        //           return getStyle();
        //       }
        //     })),
        child: Text(widget.text,
            style: TextStyle(
              color:
                  // (inputString == "") ?
                  Colors.white
              // : (isEditing ? Color(0xff111111) : Color(0xff000000))
              ,
              fontSize: 18.0,
              fontFamily: 'Source Han Sans SC',
              fontWeight: FontWeight.w100,
            )
        )
    ));
  }
}
