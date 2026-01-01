class ZikirModel {
  String id;
  String title;
  String description; // e.g. "Glory be to Allah" or Arabic translation
  int currentCount;
  int targetCount;
  List<DateTime> history; // When counters were incremented (for stats)

  ZikirModel({
    required this.id,
    required this.title,
    required this.description,
    this.currentCount = 0,
    required this.targetCount,
    List<DateTime>? history,
  }) : history = history ?? [];

  // Convenience method to update history
  void increment() {
    currentCount++;
    history.add(DateTime.now());
  }

  void reset() {
    currentCount = 0;
  }

  // To/From Map for JSON/SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'currentCount': currentCount,
      'targetCount': targetCount,
      'history': history.map((e) => e.toIso8601String()).toList(),
    };
  }

  factory ZikirModel.fromJson(Map<String, dynamic> json) {
    return ZikirModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      currentCount: json['currentCount'] ?? 0,
      targetCount: json['targetCount'] ?? 100,
      history: (json['history'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e))
          .toList(),
    );
  }
}
