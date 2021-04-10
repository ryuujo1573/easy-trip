import 'RoutePath.dart';
import 'Spot.dart';

class DispatchedRouteArgument {
  List<Spot> spots;
  List<List<RoutePath>> routesOfDays;

  void transform() {
    for (int day = 0; day < routesOfDays.length; day++) {
      for(int r = 0; r < routesOfDays[day].length; r++){
        RoutePath route = routesOfDays[day][r];
        var start = spots.firstWhere((spot) => spot.poiId == route.start);
        var end = spots.firstWhere((spot) => spot.poiId == route.end);
        start.next = end;
        end.last = start;
        start.dayCount = day;
        end.dayCount = day;
      }
    }
  }

  DispatchedRouteArgument({required this.spots, required this.routesOfDays});

  factory DispatchedRouteArgument.fromJson(Map<String, dynamic> json) {
    var spots = json['spot'] as List;
    var res = json['routes'] as List<dynamic>;
    var routesOfDays = res.map((e) => e as List<dynamic>).toList();



    return DispatchedRouteArgument(
      spots: spots.map((value) => Spot.fromJson(value)).toList(),
      routesOfDays: routesOfDays.map((value) => value.map((e) => RoutePath.fromJson(e)).toList()).toList(),
    );
  }
}
