// ignore_for_file: public_member_api_docs, sort_constructors_first
class Activity {
  final String id;
  final String color;
  final String icon;
  final String title;
  final String description;
  final String priority;
  final String daily;
  bool isChecked;
  bool isPending;

  Activity({
    required this.id,
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
    required this.priority,
    required this.daily,
    required this.isChecked,
    required this.isPending,
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
        isChecked: json['isChecked'] ?? false,
        isPending: json['isPending'] ?? false);
  }
}
