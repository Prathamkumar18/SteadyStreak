// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:steady_streak/widgets/verify.dart';

class Tasks {
  final String title;
  final String description;
  final String imageURL;
  final String email;
  final bool isVarified;
  Tasks({
    required this.title,
    required this.description,
    required this.imageURL,
    required this.email,
    required this.isVarified,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      title: json['title'],
      description: json['description'],
      imageURL: json['imageURL'],
      email: json['email'],
      isVarified: json['isVarified'] ?? false,
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

  void deleteTaskFromDatabaseByEmailAndTitle(String email, String title) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference tasksReference = databaseReference.child('tasks');
    final String Email = email.replaceAll('.', '-');
    final String Title = title.replaceAll('.', '-');
    final String compositeKey = '$Email-${Title}';
    DatabaseReference taskToRemove = tasksReference.child('$compositeKey');
    taskToRemove.remove().then((_) {
      print('Task deleted from the database');
    }).catchError((error) {
      print('Error deleting task from the database: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: GestureDetector(
              onTap: () {
                setState(() {
                  fetchAndFilterTasks();
                });
              },
              child: Text("Verification"))),
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
                return VerifyBox(
                  onDelete: () => deleteTaskFromDatabaseByEmailAndTitle(
                      task.email, task.title),
                  isVarified: task.isVarified,
                  email: task.email,
                  description: task.description,
                  imageURL: task.imageURL,
                  title: task.title,
                );
              },
            );
          }
        },
      ),
    );
  }
}
