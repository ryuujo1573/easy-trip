import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_trip_app/pages/recommendation/models/StaggeredItem.dart';
import 'package:easy_trip_app/utilities/screen_util.dart';
import 'package:easy_trip_app/utilities/user_state.dart';
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
  List<StaggeredItem> _items = [];
  int _page = 0;
  int restOfItem = 0;
  ScrollController controller = ScrollController();

  void _getData() async {
    // String? state = await User.getLoginState();
    // if (state == null) return;
    User.request
        .get('https://api.ryuujo.com/rs/listRS?page=${_page}')
        .then((value) {
      print('https://api.ryuujo.com/rs/listRS?page=${_page++}');
      print(value.data);
      List<StaggeredItem>? results = value.data['detail']
              ?.map<StaggeredItem>((e) => StaggeredItem.fromJson(e))
              .toList() ??
          null;
      print('results: $results');
      if (results == null) return;
      restOfItem += results.length;
      setState(() {
        _items.addAll(results);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Build: StaggeredSubpage');
    if (restOfItem <= 3) _getData();
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverStaggeredGrid(
          delegate: SliverChildBuilderDelegate((context, index) {
            //setState(() {
            restOfItem--;
            //});
            return Card(
              color: Colors.white,
              elevation: 2,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
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
                    height: setHeight(300) + rnd.nextInt(100),
                    color: Colors.grey[50],
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: 'https://easytrip123.oss-cn-beijing.aliyuncs.com/zip/zip/${_items[index].id}.png'//_items[index].coverUrl,
                        ),
                        Text(
                          "Picture $index",
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                  )
                ],
              ),
            );
          }, childCount: _items.length),
          gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            staggeredTileBuilder: (int index) {
              return StaggeredTile.fit(1);
            },
          ),
        ),
      ],
    );
    // crossAxisCount: 2,
    // mainAxisSpacing: 4,
    // crossAxisSpacing: 4,
    // itemCount: 10,
    // itemBuilder: (context, index) => Card(
    //     color: Colors.white,
    //     elevation: 2,
    //     clipBehavior: Clip.antiAliasWithSaveLayer,
    //     shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.all(Radius.circular(10))
    //     ),
    //     child: Column(
    //       children: [
    //         // FadeInImage.memoryNetwork(
    //         //   placeholder: kTransparentImage,
    //         //   // image: 'https://picsum.photos/${sizeList[index].width}/${sizeList[index].height}/',
    //         //   image: "https://pan.qqsuu.cn/view/${index+100}.jpg",
    //         //   fit: BoxFit.cover,
    //         //
    //         //   placeholderCacheHeight: 600,
    //         // ),
    //         Container(
    //           height: setHeight(300)+rnd.nextInt(100),
    //           color: Colors.grey[50],
    //           child: Text("Picture $index",),
    //           alignment: Alignment.center,
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
