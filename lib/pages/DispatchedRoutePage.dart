
import 'package:easy_trip_app/presets.dart';
import 'package:easy_trip_app/utilities/georegeo.dart';
import 'package:easy_trip_app/utilities/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:map/map.dart' as Extra;

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
  String? location;



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
            child: FlutterMap(
              options: MapOptions(
                center: getCenterPostion(),
                zoom: 13,
              ),
              nonRotatedLayers: [
                TileLayerOptions(
                    urlTemplate:
                        "http://wprd04.is.autonavi.com/appmaptile?lang=zh_cn&size=1&style=7&x={x}&y={y}&z={z}",
                    subdomains: ['a', 'b', 'c']),

                PolylineLayerOptions(polylines: [
                  Polyline(
                      points: () {
                    List<LatLng> points = [];
                    var pt = widget.spots.firstWhere((element) => element.poiId == -1);
                    points.add(LatLng(pt.latitude!, pt.longitude!));
                    widget.routes.map((e) => e.end).forEach((element) {
                      var spot = widget.spots
                          .firstWhere((spot) => spot.poiId == element);
                      if (spot.longitude != null)
                        points.add(LatLng(spot.latitude!, spot.longitude!));
                    });
                    return points;
                  }.call(),
                    color: Colors.black87
                  )
                ]),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(51.5, -0.09),
                      builder: (ctx) => Container(
                        child: FlutterLogo(),
                      ),
                    ),
                  ],
                ),
              ],
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
                Spot spot;

                if (id == 0) {
                  spot =
                      widget.spots.firstWhere((element) => element.poiId == -1);
                } else {
                  routes = widget.routes[id - 1];
                  spot = widget.spots.firstWhere((x) => x.poiId == routes.end);
                }

                if (spot.latitude != null) {
                  getRegeo(lat: spot.latitude!, lng: spot.longitude!)
                      .then((result) => setState(() {
                            location = result;
                          }));
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
                                  maxWidth:
                                      setWidth(750) * 0.8 - setWidth(180) //
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
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(location ?? ""),
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
                                  placeholder: kTransparentImage,
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

  LatLng getCenterPostion() {
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
}
