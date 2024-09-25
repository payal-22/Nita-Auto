class Graph {
  final int people_count;
  final String travel_date;
  final String travel_time;
  Graph(this.people_count, this.travel_date, this.travel_time);

  Graph.fromMap(Map<String, dynamic> map)
      : assert(map['people_count'] != null), // Update the field name
        assert(map['travel_date'] != null), // Update the field name
        assert(map['travel_time'] != null), // Update the field name
        people_count = map['people_count'],
        travel_date = map['travel_date'],
        travel_time = map['travel_time'];

  @override
  String toString() => "Record<$people_count:$travel_date:$travel_time>";
}
