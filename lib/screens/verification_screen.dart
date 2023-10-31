import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Tasks {
  final String title;
  final String description;
  final String imageURL;
  final String email;

  Tasks({
    required this.title,
    required this.description,
    required this.imageURL,
    required this.email,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      title: json['title'],
      description: json['description'],
      imageURL: json['imageURL'],
      email: json['email'],
    );
  }
}

class VerificationScreen extends StatefulWidget {
  String email;

  VerificationScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  List<Tasks> tasks = [];
  Future<List<Tasks>> fetchAndFilterTasks() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    DatabaseEvent databaseEvent = await databaseReference.child('tasks').once();
    List<Tasks> allTasks = [];

    if (databaseEvent.snapshot.value != null) {
      Map<dynamic, dynamic> tasksData =
          databaseEvent.snapshot.value as Map<dynamic, dynamic>;

      tasksData.forEach((key, data) {
        Tasks task = Tasks.fromJson(Map<String, dynamic>.from(data));
        if (task.email == widget.email) {
          allTasks.add(task);
        }
      });
    }

    return allTasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Tasks>>(
        future: fetchAndFilterTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final tasks = snapshot.data;
            if (tasks == null || tasks.isEmpty) {
              return Text('No tasks found for the current user.');
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  leading: Image.network(task.imageURL),
                );
              },
            );
          }
        },
      ),
    );
  }
}
