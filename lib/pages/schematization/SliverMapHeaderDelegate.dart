import 'package:flutter/material.dart';

class SliverMapHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxExtent;
  final double minExtent;
  final Widget child;

  bool isLocked = false;

  SliverMapHeaderDelegate(
      {required this.maxExtent, required this.minExtent, required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(children: [
      child,
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              isLocked = true;
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[700]!.withAlpha(200),
                borderRadius: BorderRadius.circular(10),
              ),
              width: 60,
              height: 10,
            ),
          ),
        ),
      )
    ]);
  }

  @override
  bool shouldRebuild(covariant SliverMapHeaderDelegate oldDelegate) {
    return true;
  }
}
