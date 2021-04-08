import 'dart:math';

import 'package:easy_trip_app/pages/schematization/SliverMapHeaderDelegate.dart';
import 'package:easy_trip_app/pages/schematization/models/DispatchedRouteArgument.dart';
import 'package:easy_trip_app/presets.dart';
import 'package:easy_trip_app/utilities/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_map/plugin_api.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:latlong/latlong.dart';
import 'package:map/map.dart' as Extra;
import 'package:marquee/marquee.dart';

import 'models/Enums.dart';
import 'models/RoutePath.dart';
import 'models/Spot.dart';

extension RouteToSpot on Iterable<Spot> {
  Iterable<Spot> sortWith(Iterable<RoutePath> paths) {
    return Iterable.generate(paths.length + 1, (index) {
      if (index == 0)
        return this.firstWhere((element) => element.poiId == paths.first.start);
      return this.firstWhere(
          (element) => element.poiId == paths.elementAt(index - 1).end);
    });
  }
}

class DispatchedRoutePage extends StatefulWidget {
  DispatchedRoutePage({required DispatchedRouteArgument arguments}) {
    spots = arguments.spots.toList();
    routes = arguments.routes.toList();
  }

  @override
  State<StatefulWidget> createState() {
    return _DispatchedRoutePageState();
  }

  late final List<Spot> spots;
  late final List<RoutePath> routes;
}

class _DispatchedRoutePageState extends State<DispatchedRoutePage>
    with ScreenUtil, TickerProviderStateMixin {
  String? location;

  late Iterable<Spot> routeSpots = widget.spots.sortWith(widget.routes);
  bool isPinned = false;

  // late Animation<double> animation =
  //     Tween<double>(begin: 0.3, end: 1).animate(controller);
  // late AnimationController controller =
  //     AnimationController(vsync: this, duration: Duration(milliseconds: 800));
  //
  // @override
  // void initState() {
  //   super.initState();
  //   // controller.addListener(() => setState(() {}));
  // }
  //
  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("你的智能行程"),
        actions: [
          IconButton(
            icon: Icon(
              isPinned ? Icons.map_outlined : Icons.map_sharp,
              size: 30,
            ),
            onPressed: () {
              if (isPinned)
                setState(() {
                  isPinned = false;
                });
              else
                setState(() {
                  isPinned = true;
                });
            },
          )
        ],
      ),
      extendBody: true,
      body: CustomScrollView(
        dragStartBehavior: DragStartBehavior.down,
        slivers: [
          SliverPersistentHeader(
              pinned: isPinned,
              // floating: true,
              delegate: SliverMapHeaderDelegate(
                child: _setMap(),
                minExtent: setHeight(400),
                maxExtent: setHeight(1000),
              )),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, id) {
              if (id.isOdd) {
                id = ((id - 1) / 2).floor();
                return buildSeparator(context, id);
              } else {
                id = ((id) / 2).floor();
                return buildItem(context, id);
              }
            }, childCount: routeSpots.length + widget.routes.length),
          ),
        ],
      ),
    );
  }

  Chip getChip(int transport) {
    String label;
    IconData icon;
    switch (transport) {
      case 0:
        label = "步行";
        icon = Icons.directions_walk_rounded;
        break;
      case 3:
        label = "地铁";
        icon = Icons.directions_subway_rounded;
        break;
      case 2:
        label = "公交";
        icon = Icons.directions_bus_rounded;
        break;
      default:
        label = "传送";
        icon = Icons.not_listed_location_rounded;
        break;
    }
    return Chip(
      labelPadding: EdgeInsets.zero,
      //EdgeInsets.only(right: 16,), // according to the size of Icon
      padding: EdgeInsets.only(right: 16, left: 1),
      backgroundColor: Colors.green[50],
      label: Text(
        label,
        style: defaultTextStyle.copyWith(
            color: Colors.green[800],
            fontSize: 15,
            fontWeight: FontWeight.bold,
            height: 1),
      ),
      avatar: Icon(
        icon,
        size: 18,
        color: Colors.green[800],
      ),
    );
  }

  double rad(double degree) {
    return degree * PI / 180;
  }

  double getScaleLevel(
      {required double minLat,
      required double maxLat,
      required double minLng,
      required double maxLng}) {
    const EARTH_RADIUS = 6378.137;
    double radLat1 = rad(minLat);
    double radLat2 = rad(maxLat);
    double a = radLat1 - radLat2;
    double b = rad(maxLng) - rad(minLng);
    double s = 2 *
        asin(sqrt(pow(sin(a / 2), 2) +
            cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
    s = s * EARTH_RADIUS;
    s = (s * 10000) / 10;
    return s; //单位是米 TODO: 适配缩放等级
  }

  LatLng getCenterPosition() {
    var spots =
        widget.spots.where((element) => element.longitude != null).toList();
    double minLat, maxLat, minLng, maxLng;
    var lng = (spots.map((e) => e.longitude!).toList()
      ..sort((a, b) => a.compareTo(b)));
    minLng = lng.first;
    maxLng = lng.last;
    var lat = (spots.map((e) => e.latitude!).toList()
      ..sort((a, b) => a.compareTo(b)));
    minLat = lat.first;
    maxLat = lat.last;

    return LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);
  }

  Widget getFixedTag(String tag) {
    MaterialColor color = Colors.cyan;
    TextStyle textStyle = TextStyle(
      color: color[800]!,
      fontSize: setSp(26),
    );
    return Container(
      height: setHeight(32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: color[50],
          border: null, //Border.all(color: color[400]!, width: 0.6),
          borderRadius: BorderRadius.circular(100)),
      child: Padding(
        padding: EdgeInsets.only(
            left: 8, right: 8, top: setHeight(3), bottom: setHeight(3)),
        child: Text(
          tag,
          style: textStyle,
          strutStyle: StrutStyle(
            fontSize: textStyle.fontSize,
            fontWeight: textStyle.fontWeight,
            forceStrutHeight: true,
          ),
        ),
      ),
    );
  }

  /// TODO: 处理enum
  Widget getTag(Spot spot) {
    switch (spot.tags) {
      case Tags.stadium:
        // TODO: Handle this case.
        break;
      case Tags.historical:
        // TODO: Handle this case.
        break;
      case Tags.modern:
        // TODO: Handle this case.
        break;
      case Tags.park:
        // TODO: Handle this case.
        break;
      case Tags.hotel:
        // TODO: Handle this case.
        break;
      default:
        break;
    }
    return Text(spot.tags.toString());
  }

  Widget buildSeparator(BuildContext context, int id) {
    var route = widget.routes[id];
    bool needTransport = route.transport != -1;
    return needTransport //widget.routes[id].duration > 10
        ? Container(
            height: setHeight(140),
            color: Colors.green[600],
            child: Column(
              children: [
                Spacer(),
                Flexible(
                    // flex: 2,
                    child: Row(
                  children: [
                    Spacer(),
                    Flexible(
                      flex: 11,
                      child: Row(
                        children: [
                          //Chip
                          getChip(route.transport),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "•",
                            style: TextStyle(
                              color: Colors.green[50],
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "约${route.duration}分钟" +
                                (route.transport != 0 ? " (含步行)" : ""),
                            style: TextStyle(
                                color: Colors.green[50],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
                Spacer()
              ],
            ),
          )
        : Divider(
            color: Colors.grey[200],
            height: 50,
            thickness: 30,
          );
  }

  FlutterMap _setMap() => FlutterMap(
        options: MapOptions(
          center: getCenterPosition(),
          zoom: 11,
          maxZoom: 18, // ##玄学数字不可修改##
        ),
        layers: [
          TileLayerOptions(
              urlTemplate:
                  "https://wprd01.is.autonavi.com/appmaptile?lang=zh_cn&size=1&style=7&x={x}&y={y}&z={z}",
              subdomains: ['a', 'b', 'c']),
          PolylineLayerOptions(polylines: [
            Polyline(
                points: routeSpots
                    .where((element) => element.latitude != null)
                    .map((e) => e.getPostion())
                    .toList(),
                // () {
                //   List<LatLng> points = routeSpots.map((e) => e.getPostion()).toList();
                //   // var pt = widget.spots
                //   //     .firstWhere((element) => element.poiId == -1);
                //   // points.add(LatLng(pt.latitude!, pt.longitude!));
                //   // widget.routes.map((e) => e.end).forEach((element) {
                //   //   var spot = widget.spots
                //   //       .firstWhere((spot) => spot.poiId == element);
                //   //   if (spot.longitude != null)
                //   //     points.add(LatLng(spot.latitude!, spot.longitude!));
                //   // });
                //
                //   return points;
                // }.call(),
                color: Color(0xff80beaf),
                //!.withAlpha(160),
                strokeWidth: 4)
          ]),
          MarkerLayerOptions(
            markers: () {
              var realSpots = routeSpots
                  .where((element) => element.latitude != null)
                  .toList();
              print(
                  "realSpots.length: ${realSpots.length}, \n allSpots.length: ${widget.spots.length}");
              return Iterable.generate(
                  realSpots.length,
                  (index) => Marker(
                        width: 80.0,
                        height: 80.0,
                        point: realSpots.elementAt(index).getPostion(),
                        //..set((i) => (i as LatLng).latitude += 0.00009 ), // ##玄学数字不可修改##
                        anchorPos: AnchorPos.align(AnchorAlign.top),
                        builder: (context) => Container(
                          // color: Colors.white54,
                          alignment: Alignment.bottomCenter,
                          child: Stack(
                            alignment: Alignment.center,
                            fit: StackFit.loose,
                            children: [
                              Icon(
                                Icons.push_pin_rounded,
                                size: 48,
                                color: Colors.red[300],
                              ),
                              SizedBox(
                                height: 36,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontSize: setSp(34)),
                                ),
                              )
                            ],
                          ),
                        ),
                      )).toList();
            }.call(),
          ),
        ],
      );

  Widget buildItem(BuildContext context, int id) {
    var spot = routeSpots.elementAt(id);
    var maxWidth = spot.coverUrl == null
        ? double.infinity
        : setWidth(750) * 0.8 - setWidth(150);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => spot.poiId <= 0 ? null : Navigator.of(context).pushNamed('/spots/${spot.poiId}', arguments: spot.name),
      child: Row(
        children: [
          Spacer(),
          Expanded(
            flex: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // todo: add support of map motion.
                // todo ref: https://api.flutter.dev/flutter/widgets/ScrollNotification-class.html
                SizedBox(height: 24),
                // 显示时间
                Text(
                  id == widget.routes.length
                      ? "${getTimeByMinutes(widget.routes[id - 1].duration + widget.routes[id - 1].etd).format(context)}"
                      : "${getTimeByMinutes(widget.routes[id].etd).format(context)}",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Stack(alignment: AlignmentDirectional.topStart, children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth //
                        ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: setHeight(50),
                          child: () {
                            var style = defaultTextStyle.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: setSp(50),
                              color: Colors.grey[800],
                            );
                            return (TextPainter(
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        textDirection: TextDirection.ltr,
                                        text: TextSpan(
                                            text: spot.name, style: style))
                                      ..layout(maxWidth: maxWidth))
                                    .didExceedMaxLines
                                ? Marquee(
                                    text: "${spot.name}",
                                    style: style,
                                    startPadding: 300,
                                    fadingEdgeStartFraction: 0.1,
                                    fadingEdgeEndFraction: 0.1,
                                    blankSpace: 60,
                                  )
                                : Text(
                                    "${spot.name}",
                                    style: style,
                                  );
                          }.call(),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(location ?? ""),
                        Offstage(
                          offstage: spot.longitude == null,
                          child: Text(
                            "预计游玩时间  ${"${(spot.durationByMinutes! / 60).floor()}小时${spot.durationByMinutes! % 60 > 0 ? (spot.durationByMinutes!%60).toString() + "分钟" : ''}"}",
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: spot.coverUrl == null
                        ? null
                        : Container(
                            color: Colors.cyan[50],
                            width: setWidth(180),
                            height: setHeight(200),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: spot.coverUrl!,
                              //"https://c-ssl.duitang.com/uploads/item/201701/11/20170111121734_8rkUP.thumb.1000_0.png",
                              fit: BoxFit.cover,
                              placeholderCacheHeight: 600,
                            ),
                          ),
                  ),

                  // 显示标签
                  Offstage(
                    //todo: do not use an 'Offstage' when widget itself should never be painted.
                    offstage: spot.fixedTags == null,
                    child: Container(
                      height: setHeight(200),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          children: spot.fixedTags
                                  ?.map((e) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: getFixedTag(e),
                                      ))
                                  .toList() ??
                              const <Widget>[],
                          // .addAll(spot.tags ...),
                        ),
                      ),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}
