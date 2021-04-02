import 'dart:convert';
import 'dart:typed_data';
import 'package:easy_trip_app/presets.dart';
import 'package:easy_trip_app/utilities/screen_util.dart';
import 'package:easy_trip_app/widgets/ECard.dart';
import 'package:flutter/material.dart';

class DispatchedRouteArgument {
  Iterable<Spot> spots;
  Iterable<RoutePath> routes;

  DispatchedRouteArgument({required this.spots, required this.routes});

  factory DispatchedRouteArgument.fromJson(Map<String, dynamic> json) {
    var spots = json['spot'] as List;
    var routes = json['routes'] as List;
    return DispatchedRouteArgument(
      spots: spots.map((value) => Spot.fromJson(value)),
      routes: routes.map((value) => RoutePath.fromJson(value)),
    );
  }
}

enum Tags {
  stadium, // Gymnasium, Natatorium
  historical,
  modern,
  park,
  hotel,
}

enum Rating {
  a5,
  a4,
  a3,
}

class Spot {
  Spot({
    required this.poiId,
    required this.name,
    this.prices,
    this.latitude,
    this.longitude,
    this.durationByMinutes,
    this.coverUrl,
    this.tags,
  });

  final int poiId;
  final String name;
  Iterable<int>? prices;
  double? latitude;
  double? longitude;
  int? durationByMinutes;
  Tags? tags;
  Rating? ratings;
  String? coverUrl;

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      poiId: json['poiID'],
      name: json['name'],

      latitude: json['lat'],
      longitude: json['lng'],

      //prices: json['price'], //TODO: List<int>
      durationByMinutes: json['duration'],
      coverUrl: json['coverURL'],
      //TODO: Tags
    );
  }
}

class RoutePath {
  final int start;
  final int end;

  // -1 represents that the end of the step is not a concrete position,
  // making the transport no sense.
  final int transport;
  final int etd;

  // separate the way of route display by 10 minutes' duration,
  // e.g. spots separated in a near distance, without notable color change (below 10 mins),
  //      spots separated in a formal way with a contrasted color backgrounded.
  final int duration;

  RoutePath(
      {required this.start,
      required this.end,
      required this.transport,
      required this.etd,
      required this.duration});

  factory RoutePath.fromJson(Map<String, dynamic> json) {
    return RoutePath(
      start: json['start'],
      end: json['end'],
      transport: json['transport'] ?? -1,
      etd: json['startTime'],
      duration: json['time'],
    );
  }
}

class DispatchedRoutePage extends StatefulWidget {
  DispatchedRoutePage({required this.spots, required this.routes});

  @override
  State<StatefulWidget> createState() {
    return _DispatchedRoutePageState();
  }

  final List<Spot> spots;
  final List<RoutePath> routes;
}

class _DispatchedRoutePageState extends State<DispatchedRoutePage>
    with ScreenUtil {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("你的智能行程"),
      ),
      extendBody: true,
      body: Column(
        children: [
          SizedBox(
            height: setHeight(400),
            child: ECard(
              title: "\"这里应该有一个地图来着（\"",
              child: Text(
                "有一说一, 确实((",
                style: ECard.getSubtitleStyle(),
              ),
            ),
          ),
          Spacer(),
          Expanded(
            flex: 19,
            child: ListView.separated(
              primary: true,
              shrinkWrap: false,
              physics: AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, id) {
                var route = widget.routes[id];
                return true //widget.routes[id].duration > 10
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
                                                (route.transport != 0
                                                    ? " (含步行)"
                                                    : ""),
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
                    : Divider();
              },
              itemBuilder: (context, id) {
                var routes;
                var spot;

                if (id == 0) {
                  spot =
                      widget.spots.firstWhere((element) => element.poiId == -1);
                } else {
                  routes = widget.routes[id - 1];
                  spot = widget.spots.firstWhere((x) => x.poiId == routes.end);
                }

                return Column(
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Spacer(),
                        Expanded(
                          flex: 10,
                          child: Stack(children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: setWidth(750) * 0.8 - setWidth(180) //
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${spot.name}",
                                    style: defaultTextStyle.copyWith(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 24,
                                        color: Colors.grey[800]),
                                  ),
                                  SizedBox(height: 4,),
                                  Text(
                                      "(${spot.longitude}, ${spot.latitude}) @poiId=${spot.poiId}"),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                color: Colors.cyan[50],
                                width: setWidth(180),
                                height: setHeight(200),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: Uint8List.fromList(<int>[
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
                                    0xAE
                                  ]),
                                  image: spot.coverUrl ??
                                      "https://c-ssl.duitang.com/uploads/item/201701/11/20170111121734_8rkUP.thumb.1000_0.png",
                                  fit: BoxFit.cover,
                                  placeholderCacheHeight: 600,
                                ),
                              ),
                            )
                          ]),
                        ),
                        Spacer()
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    )
                  ],
                );
              },
              itemCount: widget.spots.length + 1,
            ),
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
      labelPadding: EdgeInsets.zero,//EdgeInsets.only(right: 16,), // according to the size of Icon
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
}
