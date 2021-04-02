import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomNaviBar extends StatefulWidget {
  @override
  _BottomNaviBarState createState() => _BottomNaviBarState();

  BottomNaviBar(
  {this.child}
      );

  final Widget? child;
}

class _BottomNaviBarState extends State<BottomNaviBar> {

  // BottomNavBar
  ValueListenable<ScaffoldGeometry>? geometryListenable;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    geometryListenable = Scaffold.geometryOf(context);
  }
  @override
  Widget build(BuildContext context) {
    var notchedShape = CircularNotchedRectangle();
    return ClipPath(
      clipper: _CircularNotchedRectangleClipper(
          geometry: geometryListenable ?? Scaffold.geometryOf(context),
          shape: notchedShape,
          notchMargin: 10
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Opacity(
          opacity: 0.8  ,
          child: BottomAppBar(
            // BottomNavigationBar ?
            notchMargin: 10,
            elevation: 5,
            shape: notchedShape,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: widget.child
          ),
        ),
      ),
    );
  }
}

class _CircularNotchedRectangleClipper extends CustomClipper<Path> {
  const _CircularNotchedRectangleClipper({
    required this.geometry,
    required this.shape,
    required this.notchMargin,
  })   : assert(geometry != null),
        assert(shape != null),
        assert(notchMargin != null),
        super(reclip: geometry);

  final ValueListenable<ScaffoldGeometry> geometry;
  final NotchedShape shape;
  final double notchMargin;

  @override
  Path getClip(Size size) {
    // button is the floating action button's bounding rectangle in the
    // coordinate system whose origin is at the appBar's top left corner,
    // or null if there is no floating action button.
    final Rect? button = geometry.value.floatingActionButtonArea?.translate(
      0.0,
      geometry.value.bottomNavigationBarTop! * -1.0,
    );
    return shape.getOuterPath(Offset.zero & size, button?.inflate(notchMargin));
  }

  @override
  bool shouldReclip(_CircularNotchedRectangleClipper oldClipper) {
    return oldClipper.geometry != geometry ||
        oldClipper.shape != shape ||
        oldClipper.notchMargin != notchMargin;
  }
}
