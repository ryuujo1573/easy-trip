import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_trip_app/pages/DispatchedRoutePage.dart';
import 'package:easy_trip_app/presets.dart';
import 'package:easy_trip_app/utilities/screen_util.dart';
import 'package:easy_trip_app/widgets/ECard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewTripPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewTripPageState();
  }
}

class _presetCard extends StatefulWidget {
  _presetCard({
    required this.tag,
    required this.icon,
    this.backgroundColor = Colors.grey,
    this.foregroundColor = Colors.blueGrey,
    required this.onSelected,
  });

  final String tag;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  final Function onSelected;

  @override
  State<StatefulWidget> createState() {
    return _presetCardState();
  }
}

class _presetCardState extends State<_presetCard> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.75,
      child: Card(
        color: widget.backgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Flexible(
              flex: 8,
              child: Icon(
                widget.icon,
                color: widget.foregroundColor,
                size: 48,
              ),
            ),
            Spacer(),
            Flexible(
                flex: 3,
                child: Text(
                  widget.tag,
                  style: defaultTextStyle.copyWith(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                )),
            Spacer()
          ],
        ),
      ),
    );
  }
}

class _NewTripPageState extends State<NewTripPage> with ScreenUtil {
  bool _platformCallFlag = true;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("新的旅行"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          _platformCallFlag ? Icons.workspaces_filled : Icons.error,
          size: 32,
          color: Colors.lime[50]!,
        ),
        onPressed: () async {
          // Fluttertoast.showToast(msg: "Android Call Test", fontSize: 18);
          var result = await Dio()
              .get("https://api.ryuujo.com/route/apiTest")
              .then((value) => DispatchedRouteArgument.fromJson(value.data));

          Navigator.of(context).pushNamed("/dispatch", arguments: result);

          if (kIsWeb) {
            return;
          }
          if (Platform.isAndroid) { // !!!!!!!!!!!!!!!!!
            try {
              var result = await platform.invokeMethod("aiboost_test");
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(result),
              ));
            } on Exception catch (e) {
              setState(() {
                _platformCallFlag = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error: $e"),
                  ),
                )..closed
                    .then((value) => setState(() => _platformCallFlag = true));
              });
            }
          }
        },
      ),
      body: ListView(
        shrinkWrap: false,
        padding: EdgeInsets.all(20),
        primary: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          // 出行预设
          ECard(
              // height: setWidth(400),
              title: "出行预设",
              child: LimitedBox(
                maxHeight: MediaQuery.of(context).orientation == Orientation.portrait ? setWidth(260) : setHeight(500),
                child: ListView(
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  children: [
                    _presetCard(
                      tag: "情侣出行",
                      icon: Icons.adb_rounded,
                      onSelected: () => null,
                      backgroundColor: Colors.pink[50]!,
                    ),
                    _presetCard(
                      tag: "携带儿童",
                      icon: Icons.child_friendly_rounded,
                      onSelected: () => null,
                      backgroundColor: Colors.lime[50]!,
                    ),
                    _presetCard(
                      tag: "协同老人",
                      icon: Icons.elderly_rounded,
                      onSelected: () => null,
                      backgroundColor: Colors.green[100]!,
                    ),
                    _presetCard(
                      tag: "拜访他人",
                      icon: Icons.sensor_door_rounded,
                      onSelected: () => null,
                      backgroundColor: Colors.lightBlue[50]!,
                    ),
                  ],
                ),
              )
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: List.generate(10, (index) => new Text("data")),
              // ),
              ),
          SizedBox(
            height: 30,
          ),
          ECard(
            title: "时间安排",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "请选择起止时间:",
                  style: ECard.getSubtitleStyle(),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
