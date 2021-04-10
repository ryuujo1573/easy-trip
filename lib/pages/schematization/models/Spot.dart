// ignore: import_of_legacy_library_into_null_safe
import 'package:latlong/latlong.dart';

import 'Enums.dart';

class Spot {
  Spot({
    required this.poiId,
    required this.name,
    this.coverUrl,
    this.durationByMinutes,
    this.price,
    this.prices,
    this.latitude,
    this.longitude,
    this.fixedTags,
    this.last,
    this.next,
    this.dayCount
  });

  Spot.from({
    required Spot spot,
    Spot? last,
    Spot? next,
    int? day,
  }) : this(
            poiId: spot.poiId,
            name: spot.name,
            coverUrl: spot.coverUrl,
            durationByMinutes: spot.durationByMinutes,
            price: spot.price,
            prices: spot.prices,
            latitude: spot.latitude,
            longitude: spot.longitude,
            fixedTags: spot.fixedTags,
            last: last,
            next: next,
            dayCount: day);

  final int poiId;
  final String name;
  String? coverUrl;
  int? durationByMinutes;
  double? price;
  Iterable<int>? prices;
  double? latitude;
  double? longitude;
  Iterable<String>? fixedTags;

  int? dayCount;
  Spot? last;
  Spot? next;

  LatLng getPostion() => LatLng(latitude, longitude);

  // Tags? tags;
  // Rating? ratings;

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      poiId: json['poiID'],
      name: json['name'],
      coverUrl: json['coverURL'],
      durationByMinutes: json['duration']?.toInt(),
      price: json['price'],
      prices: json['prices'],
      //fixme
      latitude: json['lat'],
      longitude: json['lng'],

      fixedTags: json['tags']?.toString().split('|'),
    );
  }
}
