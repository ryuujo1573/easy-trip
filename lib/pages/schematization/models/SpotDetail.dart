import 'package:latlong/latlong.dart';

class SpotDetail {
  final int poiId;
  final String name;
  final String? engName;
  final String description;
  final LatLng position;
  final String? coverUrl;
  final double? rating;
  final List<String>? fixedTags;
  final Iterable<double> prices;
  final String playTime;
  final String? preferMd;
  final String? openTime;

  SpotDetail({
    required this.poiId,
    required this.name,
    required this.description,
    required this.position,
    required this.prices,
    required this.playTime,
    this.openTime,
    this.preferMd,
    this.engName,
    this.rating,
    this.fixedTags,
    this.coverUrl,
  });

  factory SpotDetail.fromJson(Map<String, dynamic> json) {
    var pos = LatLng(json['lat'], json['lng']); //todo: change the wrong arg
    print(json['price']);
    return SpotDetail(
      poiId: json['poiID'],
      // notice the case!
      name: json['name'],
      description: json['desc'],
      position: pos,
      rating: json['rating'],
      // todo: add support of 'price openTime prefer'
      // fixedTags: json[''],
      coverUrl: json['coverURL'],
      playTime: json['playtime'],
      prices: json['price']?.cast<double>() ?? const [0],
      preferMd: json['prefer'],
      openTime: json['openTime'],
    );
  }
}
