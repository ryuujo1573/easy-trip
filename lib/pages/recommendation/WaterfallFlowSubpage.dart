import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_trip_app/pages/recommendation/models/StaggeredItem.dart';
import 'package:easy_trip_app/presets.dart';
import 'package:easy_trip_app/utilities/screen_util.dart';
import 'package:easy_trip_app/utilities/user_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final Random rnd = Random(DateTime.now().millisecond);
// final List<Size> sizeList = List.generate(3, (index) => Size(rnd.nextInt(500) + 200, rnd.nextInt(800) + 200));

class WaterfallFlowSubpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WaterfallFlowSubpageState().._getData(0);
  }
}

class _WaterfallFlowSubpageState extends State<WaterfallFlowSubpage>
    with ScreenUtil {
  final List<StaggeredItem> _items = [];
  int _page = 1;

  // int restOfItem = 0;
  late ScrollController controller = ScrollController()
    ..addListener(() {
      var current = controller.position.pixels; //.toInt();
      //滑动到底部
      if (current + 200 > controller.position.maxScrollExtent) {
        _getData(_page++);
      }
    });

  // bool isLoading = false;

  void _getData([int? page]) async {
    // String? state = await User.getLoginState();
    // if (state == null) return;

    // fixme: it doesn't work.
    // String? cookie = await User.cookieJar.storage.read('api.ryuujo.com');
    // if (cookie == null) {
    //   return;
    // }

    // if (isLoading) return;
    // isLoading = true;
    print(
        '[User.request]: https://api.ryuujo.com/rs/listRS?page=${(page == null) ? _page : page}');
    User.request
        .get(
            'https://api.ryuujo.com/rs/listRS?page=${(page == null) ? _page++ : page}')
        .then((value) {
      var data = value.data as Map<String, dynamic>;
      print(data);
      //todo: 早日用上statusCode
      if (data.keys.contains('error')) {
        //error
      } else {
        List<StaggeredItem>? results = data['detail']
                ?.map<StaggeredItem>((e) => StaggeredItem.fromJson(e))
                .toList() ??
            null;
        print('results: $results');
        if (results == null) {
          // isLoading = false;
          return;
        }
        // restOfItem += results.length;
        if (mounted)
          setState(() {
            _items.addAll(results);
            // isLoading = false;
          });
      }
    }).catchError((e) {
      print('[error]: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Build: StaggeredSubpage');
    // if (restOfItem <= 3) _getData();
    return
        //   CustomScrollView(
        //   controller: controller,
        //   slivers: [
        //     SliverPadding(
        //       padding: EdgeInsets.only(bottom: 80),
        //       sliver: SliverStaggeredGrid(
        //         delegate: SliverChildBuilderDelegate((context, index) {
        //           //setState(() {
        //           Widget child;
        //           //});
        //           if (_items.length < index + 1) // (_items.length == 0)
        //             child = Container(
        //               height: setHeight(300),
        //               color: Colors.green[50],
        //             );
        //           else {
        //             restOfItem--;
        //             child = Column(
        //               children: [
        //                 // FadeInImage.memoryNetwork(
        //                 //   placeholder: kTransparentImage,
        //                 //   // image: 'https://picsum.photos/${sizeList[index].width}/${sizeList[index].height}/',
        //                 //   image: "https://pan.qqsuu.cn/view/${index+100}.jpg",
        //                 //   fit: BoxFit.cover,
        //                 //
        //                 //   placeholderCacheHeight: 600,
        //                 // ),
        //                 Container(
        //                   height: setHeight(300),
        //                   color: Colors.grey[50],
        //                   child: Column(
        //                     children: [
        //                       CachedNetworkImage(
        //                           imageUrl:
        //                               'https://easytrip123.oss-cn-beijing.aliyuncs.com/zip/zip/${_items[index].id}.png' //_items[index].coverUrl,
        //                           ),
        //                       Text(
        //                         "Picture $index",
        //                       ),
        //                     ],
        //                   ),
        //                   alignment: Alignment.center,
        //                 )
        //               ],
        //             );
        //           }
        //
        //           return Card(
        //               color: Colors.white,
        //               elevation: 2,
        //               clipBehavior: Clip.antiAliasWithSaveLayer,
        //               shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.all(Radius.circular(10))),
        //               child: child,);
        //         }, childCount: _items.length),
        //         gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 2,
        //           staggeredTileBuilder: (int index) {
        //             return StaggeredTile.fit(1);
        //           },
        //         ),
        //       ),
        //     ),
        //   ],
        // );

        StaggeredGridView.countBuilder(
      controller: controller,
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: _items.length,
      itemBuilder: (context, index) => Card(
        color: Colors.white,
        elevation: 2,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: () {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FadeInImage.memoryNetwork(
                //   placeholder: kTransparentImage,
                //   // image: 'https://picsum.photos/${sizeList[index].width}/${sizeList[index].height}/',
                //   image: "https://pan.qqsuu.cn/view/${index+100}.jpg",
                //   fit: BoxFit.cover,
                //
                //   placeholderCacheHeight: 600,
                // ),

                CachedNetworkImage(
                    imageUrl:
                        'https://easytrip123.oss-cn-beijing.aliyuncs.com/zip/zip/${_items[index].id}.png' //_items[index].coverUrl,
                    ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "${_items[index].name}",
                          style: defaultTextStyle.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: setSp(30),
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      Row(
                        children: _items[index]
                            .tags
                            .map((e) => Padding(
                                  padding: const EdgeInsets.only(left: 0, top: 8, right: 8.0, bottom: 4),
                                  child: getFixedTag(e),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }.call(),
      ),
      staggeredTileBuilder: (int index) {
        return StaggeredTile.fit(1);
      },
    );
  }
}
