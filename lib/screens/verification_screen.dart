// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  Widget build(BuildContext context) {
    const SystemUiOverlayStyle(
        statusBarColor: Colors.white, systemNavigationBarColor: Colors.white);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: GestureDetector(
              onTap: () {
                setState(() {
                  fetchAndFilterTasks();
                });
              },
              child: Center(
                  child: Text(
                "Verification",
                style: TextStyle(fontSize: 40),
              )))),
      backgroundColor: Color.fromARGB(255, 229, 230, 229),
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
