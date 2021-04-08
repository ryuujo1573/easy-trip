import 'RoutePath.dart';
import 'Spot.dart';

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
