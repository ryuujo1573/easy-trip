import 'dart:math';

import 'package:easy_trip_app/utilities/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


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
