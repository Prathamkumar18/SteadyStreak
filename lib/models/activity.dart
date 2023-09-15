class Activity {
  final String id;
  final String color;
  final String icon;
  final String title;
  final String description;
  final String priority;
  final String daily;
  bool isChecked;

  Activity({
    required this.id,
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
    required this.priority,
    required this.daily,
    required this.isChecked,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
        id: json['_id'],
        color: json['color'],
        icon: json['icon'],
        title: json['title'],
        description: json['description'],
        priority: json['priority'],
        daily: json['daily'],
        isChecked: json['isChecked'] ?? false);
  }
}
