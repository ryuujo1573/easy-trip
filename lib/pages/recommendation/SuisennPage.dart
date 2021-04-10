import 'dart:io';
import 'dart:ui';
import 'dart:convert' show json;

import 'package:dio/dio.dart';
import 'package:easy_trip_app/pages/recommendation/models/SuisennItem.dart';
import 'package:easy_trip_app/pages/schematization/models/DispatchedRouteArgument.dart';
import 'package:easy_trip_app/presets.dart';
import 'package:easy_trip_app/utilities/screen_util.dart';
import 'package:easy_trip_app/utilities/user_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuisennPage extends StatefulWidget {
  SuisennPage(this.argument);

  final Map<String, dynamic> argument;

  @override
  _SuisennPageState createState() {
    print(argument);
    return _SuisennPageState();
  }
}

class _SuisennPageState extends State<SuisennPage> with ScreenUtil {
  List<SuisennItem> items = [];

  // Iterable.generate(
  //     10,
  //         (index) =>
  //         SuisennItem(
  //           coverUrl: 'wtf',
  //           score: 0.2,
  //           id: 500 + index,
  //           model_id: 0,
  //           name: 'Title $index',
  //           tags: ['abc', 'wtf', 'AJKSHFK', 'A×$index=${'A' * index}'],
  //         )).toList();

  late int days = widget.argument['days'];

  late Iterable<double> scoreList;

  int get number {
    return days * 5;
  }

  bool requestOnce = true;

  @override
  Widget build(BuildContext context) {
    if (requestOnce) _getData(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.analytics_rounded),
        onPressed: () async {
          var map = <String, dynamic>{
            'days': days,
            'lst':
                "[${items.map((e) => '${e.id}').reduce((a, b) => '$a, $b')}]",
            //assert: scoreList should not be empty.
            'score':
                '[${(scoreList).map((e) => '$e').reduce((a, b) => '$a, $b')}]',
            // '[0.5,0.1,0.4,0.3,0.23]',
            'people': widget.argument['castTotal'],
            'student': widget.argument['castStudent'],
            'child': widget.argument['castChild'],
            'elder': widget.argument['castElder'],
            'lunchTimeBegin': 700,
            'lunchTimeEnd': 780,
            'endTime': 1320,
          };

          print('[User.request] route/arrange; data = $map');

          await User.request
              .post('https://api.ryuujo.com/route/arrange',
                  data: FormData.fromMap(map))
              .then((value) {
            Navigator.of(context).pushNamed('/dispatch', arguments: DispatchedRouteArgument.fromJson(value.data));
          });
        },
      ),
      body: CustomScrollView(
        dragStartBehavior: DragStartBehavior.down,
        slivers: [
          SliverAppBar(
              expandedHeight: 240.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('云端推荐结果'),
                background: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff005c1a), Color(0xff76c353)])),
                ),
              )),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, id) {
              if (id.isOdd) {
                return _buildSeparator(context, id);
              } else {
                id = ((id) / 2).floor();
                return _buildItem(context, id);
              }
            }, childCount: items.length * 2 - 1),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator(BuildContext context, int id) {
    return Divider();
  }

  Widget _buildItem(BuildContext context, int id) {
    var spot = items[id];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => spot.id <= 0
          ? null
          : Navigator.of(context)
              .pushNamed('/spots/${spot.id}', arguments: spot.name),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Expanded(
            flex: 13,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${id + 1}'),
                  Container(
                    child: Text(
                        "${spot.name}",
                        style: defaultTextStyle.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: setSp(50),
                          color: Colors.grey[800],
                        ),
                        softWrap: true,
                        maxLines: 3,
                      ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: setHeight(250),
                color: Colors.cyan[50],
                // width: setWidth(180),
                // height: setHeight(200),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image:
                      "https://easytrip123.oss-cn-beijing.aliyuncs.com/zip/zip/${spot.id}.png",
                  //"https://c-ssl.duitang.com/uploads/item/201701/11/20170111121734_8rkUP.thumb.1000_0.png",
                  fit: BoxFit.cover,
                  placeholderCacheHeight: 600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getData(BuildContext context) async {
    requestOnce = false;
    //print(User.cookieJar.loadForRequest(Uri.parse("https://api.ryuujo.com/")));
    var _sessionId =
        (await SharedPreferences.getInstance()).getString('_sessionId');
    // print('sessionId from prefs: ${_sessionId}');
    late FormData data;
    try {
      data = FormData.fromMap({
        'number': number,
        'user_id': User.id,
        'assign': widget.argument['preferTags']
      });
    } catch (e) {
      Navigator.of(context).pushNamed("/login");
    }
    Map.fromEntries(data.fields).let(print);

    User.request.post('https://api.ryuujo.com/rs/tagRS', data: data).then(
      (value) async {
        print(value.data);
        Iterable<dynamic>? ls = value.data['detail'];
        var result = ls?.map((e) => SuisennItem.fromJson(e));
        if (result == null)
          Future.delayed(Duration(milliseconds: 500));
        else {
          items.addAll(result);
          if (Platform.isAndroid) {
            try {
              //todo: 让多个 loading 文本 同时在一个overlay中加载，监听toBeLoaded
              var entry = OverlayEntry(
                  builder: (_) =>
                      popupWaiting(_, description: "AI Generating..."));
              Overlay.of(context)!.insert(entry);

              scoreList = (await platform.invokeListMethod('aiboost_test', {
                'poiIdList': items
                    .map((item) => '${item.model_id}')
                    .reduce((a, b) => '$a,$b'),
                // 注意是实际传递为newID不是poiId
                'userId': User.id.toString()
              }).whenComplete(() => entry.remove()))!
                  .map((e) => double.parse('$e'));

              setState(() {});

              print('[aiboost] scoreList: $scoreList');

              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text(
              //       ('''[${scoreList.map((e) => '$e').reduce((value, element) => '$value, $element')}]''')),
              // ));
            } on Exception catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: $e"),
                ),
                // ..closed
                //     .then((value) => setState(() => null));
              );
              throw e;
            }
          }
        }
      },
    );
  }
}
