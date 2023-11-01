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
  int itemsPerPage = 10;
  int currentPage = 1;

  Future<void> fetchAndFilterTasks() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    DatabaseEvent databaseEvent = await databaseReference.child('tasks').once();

    if (databaseEvent.snapshot.value != null) {
      Map<dynamic, dynamic> tasksData =
          databaseEvent.snapshot.value as Map<dynamic, dynamic>;

      tasksData.forEach((key, data) {
        Tasks task = Tasks.fromJson(Map<String, dynamic>.from(data));
        if (task.email == widget.email) {
          setState(() {
            tasks.add(task);
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndFilterTasks().then((_) {
      // You can call fetchAndFilterTasks() here to load the initial data.
      // However, for pagination, you may load data on-demand when scrolling.
    });
  }

  Widget build(BuildContext context) {
    const SystemUiOverlayStyle(
        statusBarColor: Colors.white, systemNavigationBarColor: Colors.white);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            fetchAndFilterTasks();
          },
          child: Center(
            child: Text(
              "Verification",
              style: TextStyle(fontSize: 40),
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 229, 230, 229),
      body: ListView.builder(
        itemCount: tasks.length < currentPage * itemsPerPage
            ? tasks.length + 1
            : (currentPage + 1) * itemsPerPage,
        itemBuilder: (context, index) {
          if (index == tasks.length) {
            if (tasks.length < currentPage * itemsPerPage) {
              currentPage++;
              fetchAndFilterTasks();
            }
            return CircularProgressIndicator();
          } else {
            final task = tasks[index];
            return VerifyBox(
              isVarified: task.isVarified,
              email: task.email,
              description: task.description,
              imageURL: task.imageURL,
              title: task.title,
            );
          }
        },
      ),
    );
  }
}
