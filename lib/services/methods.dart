import '../models/activity.dart';

List<Activity> sortActivitiesByPriority(List<Activity> activities) {
    activities.sort((a, b) {
      final priorityValues = {'High': 3, 'Medium': 2, 'Low': 1};
      final priorityA = priorityValues[a.priority];
      final priorityB = priorityValues[b.priority];
      return priorityB!.compareTo(priorityA!);
    });
    return activities;
}

int countCompletedTasks(List<Activity> activities) {
    return activities.where((activity) => activity.isChecked).length;
}

