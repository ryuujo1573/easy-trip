class StaggeredItem {
  final StaggeredItemType type;
  final int id;
  final String name;
  final String coverUrl;
  final Iterable<String> tags;

  StaggeredItem({
    this.type = StaggeredItemType.poi,
    required this.id,
    required this.name,
    required this.coverUrl,
    required this.tags,
  });

  factory StaggeredItem.fromJson(Map<String, dynamic> json) {
    return StaggeredItem(
      id: json['poiID'],
      name: json['name'],
      coverUrl: json['coverURL'],
      tags: json['tag'].cast<String>(),
    );
  }
}

enum StaggeredItemType { poi }
