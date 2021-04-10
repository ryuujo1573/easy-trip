class SuisennItem {
  final int id;
  final int model_id;
  final String name;
  final String coverUrl;
  final Iterable<String> tags;
  final double score;

  SuisennItem({
    required this.id,
    required this.model_id,
    required this.name,
    required this.coverUrl,
    required this.tags,
    required this.score,
  });

  factory SuisennItem.fromJson(Map<String, dynamic> json) {
    return SuisennItem(
      id: json['poiID'],
      model_id: json['newID'],
      name: json['name'],
      coverUrl: json['coverURL'],
      tags: json['tag'].cast<String>(),
      score: json['score']
    );
  }
}