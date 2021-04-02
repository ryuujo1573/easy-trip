import 'dart:math';
import 'dart:typed_data';

import 'package:easy_trip_app/utilities/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
final Random rnd = Random(DateTime.now().millisecond);
// final List<Size> sizeList = List.generate(3, (index) => Size(rnd.nextInt(500) + 200, rnd.nextInt(800) + 200));

class WaterfallFlowSubpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WaterfallFlowSubpageState();
  }
}

class _WaterfallFlowSubpageState extends State<WaterfallFlowSubpage>
  with ScreenUtil {
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder( // todo: use AnimatedPadding for better appearance.
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemCount: 10,
        itemBuilder: (context, index) => Card(
            color: Colors.white,
            elevation: 2,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Column(
              children: [
                // FadeInImage.memoryNetwork(
                //   placeholder: kTransparentImage,
                //   // image: 'https://picsum.photos/${sizeList[index].width}/${sizeList[index].height}/',
                //   image: "https://pan.qqsuu.cn/view/${index+100}.jpg",
                //   fit: BoxFit.cover,
                //
                //   placeholderCacheHeight: 600,
                // ),
                Container(
                  height: setHeight(300)+rnd.nextInt(100),
                  color: Colors.grey[50],
                  child: Text("Picture $index",),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
        staggeredTileBuilder: (index) => StaggeredTile.fit(1)
    );
  }
}
