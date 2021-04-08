// ignore: import_of_legacy_library_into_null_safe
import 'package:latlong/latlong.dart';

import 'Enums.dart';

class Spot {
  Spot({
    required this.poiId,
    required this.name,
    this.prices,
    this.latitude,
    this.longitude,
    this.durationByMinutes,
    this.coverUrl,
    this.fixedTags,
  });

  final int poiId;
  final String name;
  Iterable<int>? prices;
  double? latitude;
  double? longitude;

  LatLng getPostion() => LatLng(latitude, longitude);

  int? durationByMinutes;
  Tags? tags;
  Iterable<String>? fixedTags;
  Rating? ratings;
  String? coverUrl;

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      poiId: json['poiID'],
      name: json['name'],

      latitude: json['lat'],
      longitude: json['lng'],

      //prices: json['price'], //TODO: List<int>
      fixedTags: json['tags']?.toString().split('|'),
      durationByMinutes: json['duration'],
      coverUrl: json['coverURL'],
      //TODO: Tags
    );
  }
}