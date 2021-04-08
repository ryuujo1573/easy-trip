///
/// RoutePath: represents one step of specific touring route.
///

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