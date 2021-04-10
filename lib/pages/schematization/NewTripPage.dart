import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_trip_app/pages/schematization/models/SpotTag.dart';
import 'package:easy_trip_app/presets.dart';
import 'package:easy_trip_app/utilities/Tuple.dart';
import 'package:easy_trip_app/utilities/screen_util.dart';
import 'package:easy_trip_app/utilities/user_state.dart';
import 'package:easy_trip_app/widgets/ECard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';

import 'models/DispatchedRouteArgument.dart';

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
  DateTime? dt1;
  DateTime? dt2;
  DateTime? _focusedDay;

  List<SpotTag> tags = [];
  List<int> _filters = [];

  late TextEditingController _castTotalController =
      TextEditingController(text: '1')
        ..addListener(() {
          int value = int.parse(_castTotalController.text);
          if (value > 20) _castTotalController.text = '20';
          var eachTotal = _castEachControllers.values
              .map((e) => int.parse(e.text))
              .reduce((a, b) => a + b);
          if (eachTotal > value) _castTotalController.text = '$eachTotal';
        });

  late Map<String, TextEditingController> _castEachControllers =
      Map.fromIterables(['长辈人数', '学生人数', '儿童人数'],
          Iterable.generate(3, (index) => TextEditingController(text: '0')));

  // List<int> _castCountEach = const [0, 0, 0];
  //
  // int get _restCount {
  //   return int.parse(_castTotalController.text) -
  //       _castCountEach.reduce((a, b) => a + b);
  // }

  Iterable<Widget> get tagWidgets sync* {
    if (requestOnce)
      () async {
        requestOnce = false;
        String tagStringAll = await User.request
            .get('https://api.ryuujo.com/rs/listTag')
            .then((value) => value.data);
        var list = tagStringAll.split('|');
        for (int i = 0; i < list.length; i++) {
          tags.add(SpotTag(i, list.elementAt(i)));
        }
        setState(() {});
      }.call();
    for (var tag in tags) {
      yield FilterChip(
        showCheckmark: false,
        // selectedShadowColor: Colors.green[500],
        label: Text(tag.tag),
        selected: _filters.contains(tag.index),
        onSelected: (select) {
          if (select) {
            _filters.add(tag.index);
          } else {
            _filters.remove(tag.index);
          }

          setState(() {});
        },
      );
    }
  }

  bool requestOnce = true;

  // bool isWaiting = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("新的旅行"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          _platformCallFlag ? Icons.check : Icons.error,
          size: 32,
          color: Colors.lime[50]!,
        ),
        onPressed: () async {
          // if (!isWaiting)
          //   isWaiting = true;
          // else
          //   return; // todo: 防止多次点击
          // Fluttertoast.showToast(msg: "Android Call Test", fontSize: 18);

          // readme: this is the argument for page: SuisennPage to request & build.
          var result = <String, dynamic>{
            'dayStart': dt1.toString(),
            'dayEnd': dt2.toString(),
            'days': (dt2!.difference(dt1!).inDays),
            //people
            'castTotal': _castTotalController.text.let(int.parse),
            //elder
            'castElder': _castEachControllers['长辈人数']!.text.let(int.parse),
            //child
            'castChild': _castEachControllers['儿童人数']!.text.let(int.parse),
            //student
            'castStudent': _castEachControllers['学生人数']!.text.let(int.parse),
            //lst
            'preferTags':_filters.isEmpty ? null :
                _filters.map((e) => '$e').reduce((a, b) => '$a|$b'),
            // //score
            // 'preferScores': '[]' //fixme: calculate the scores of each tag.
          };

          Navigator.of(context).pushNamed("/recommend", arguments: result);          //

        },
      ),
      body: ListView(
        shrinkWrap: false,
        primary: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          // 出行预设
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Offstage(
              offstage: true,
              child: ECard(
                  // height: setWidth(400),
                  title: "出行预设",
                  child: LimitedBox(
                    maxHeight: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? setWidth(260)
                        : setHeight(500),
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
            ),
          ),

          //todo: 年视角
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: ECard(
              title: "时间安排",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "请选择起止时间:",
                    style: ECard.getSubtitleStyle(),
                    textAlign: TextAlign.left,
                  ),
                  () {
                    var now = DateTime.now();
                    return TableCalendar(
                      availableGestures: AvailableGestures.none,
                      locale: 'zh-cn',
                      rangeSelectionMode: RangeSelectionMode.enforced,
                      focusedDay: _focusedDay ?? now,
                      firstDay: now,
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      availableCalendarFormats: {
                        CalendarFormat.month: 'Month',
                      },
                      // calendarStyle: CalendarStyle(
                      //
                      // ),
                      lastDay: DateTime(now.year + 1, now.month, 30),
                      onRangeSelected: (d1, d2, d3) {
                        setState(() {
                          dt1 = d1;
                          dt2 = d2;
                        });
                      },
                      rangeStartDay: dt1,
                      rangeEndDay: dt2,

                      calendarBuilders: CalendarBuilders(
                        headerTitleBuilder: (context, day) => Center(
                            child: Text(
                          '${day.year}年${day.month}月',
                          style: defaultTextStyle,
                        )),
                      ),
                    );
                  }.call()
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: ECard(
              title: '出行人数',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 3,
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: Text(
                            '请输入总人数',
                            style: ECard.getSubtitleStyle(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              controller: _castTotalController,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 2.0, bottom: 0.0),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                      children: _castEachControllers.keys
                          .map(
                            (title) => Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: FractionallySizedBox(
                                    widthFactor: 1,
                                    child: Text(
                                      title,
                                      style: ECard.getSubtitleStyle(),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: SizedBox(
                                      height: 40,
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        controller: _castEachControllers[title],
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: 2.0, bottom: 0.0),
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList())
                  //fixme
                  // Row(
                  //   children: [
                  //     Expanded(flex: 3, child: Center()),
                  //     Flexible(
                  //       flex: 7,
                  //       child: Container(
                  //         color: Colors.green[50],
                  //         child: FractionallySizedBox(
                  //           widthFactor: 1,
                  //           // the elder / stu / child /
                  //           child: Slider(
                  //             value: _castCountEach[0].toDouble(),
                  //             onChanged: (double value) {
                  //               setState(() {
                  //                 _castCountEach[0] = value.toInt();
                  //               });
                  //             },
                  //             divisions: _restCount,
                  //             min: 0,
                  //             max: _restCount.toDouble(),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
            child: ECard(
                title: '旅游偏好',
                child: Column(
                  children: [
                    Wrap(
                        spacing: 5, runSpacing: 0, children: tagWidgets.toList()
                        // (() {
                        //         return [getFixedTag(,
                        //             fontFactor: 1.2,
                        //             selectable: true, onSelected: (select) {
                        //           selectedTag.add(e.t1)];
                        //         });
                        //       }).call(),
                        )
                  ],
                )),
          )

          //
        ],
      ),
    );
  }
}
