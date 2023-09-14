import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:steady_streak/screens/task.dart';
import 'package:steady_streak/utils/colors.dart';
import 'package:steady_streak/utils/config.dart';
import 'package:steady_streak/widgets/task_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../activity.dart';

class HomeScreen extends StatefulWidget {
  String email;

  HomeScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Activity> activities = [];
  bool isLoading = true;
  String userName = "";
  int c = 0;
  int total = 0;

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

  Future<void> fetchActivities() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8082/user/${widget.email}/all-activities'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['activities'];
      List<Activity> fetchedActivities =
          data.map((json) => Activity.fromJson(json)).toList();
      setState(() {
        activities = fetchedActivities;
        isLoading = false;
        total = activities.length;
        c = countCompletedTasks(activities);
      });
    } else {
      throw Exception('Failed to fetch activities');
    }
  }

  Future<void> updateTaskStatus(String title, bool isChecked) async {
    final String updateActivityStatus =
        'http://10.0.2.2:8082/user/update-activity-status';
    final url = Uri.parse(updateActivityStatus);
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': widget.email,
        'title': title,
        'isChecked': isChecked,
      }),
    );

    if (response.statusCode == 200) {
      // Update the task status in the local list
      setState(() {
        final updatedActivity = activities.firstWhere(
          (activity) => activity.title == title,
        );
        updatedActivity.isChecked = isChecked;
        // Update completed task count
        c = countCompletedTasks(activities);
      });
    } else {
      print('Failed to update task status');
    }
  }

  Future<void> retrieveUserName() async {
    final response = await http.get(
      Uri.parse('$getUserNameByEmail/${widget.email}'),
    );
    final responseBody = json.decode(response.body);
    setState(() {
      userName = responseBody['name'];
    });
  }

  Future<void> deleteTask(String email, String title) async {
    final url = Uri.parse(deleteActivity);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'title': title,
      }),
    );

    if (response.statusCode == 204) {
      setState(() {
        activities.removeWhere((activity) => activity.title == title);
      });
    } else {
      print('Failed to delete task');
    }
  }

  // Function to check if it's a new day
  bool isNewDay(String lastDate) {
    final currentDate = DateTime.now();
    final lastDateTime = DateTime.parse(lastDate);
    return currentDate.day != lastDateTime.day ||
        currentDate.month != lastDateTime.month ||
        currentDate.year != lastDateTime.year;
  }

  Future<void> saveLastScheduledDate() async {
    final preferences = await SharedPreferences.getInstance();
    final currentDate = DateTime.now().toIso8601String();
    await preferences.setString('lastScheduledDate', currentDate);
  }

  Future<String?> getLastScheduledDate() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('lastScheduledDate');
  }

  Future<void> scheduleDailyUpdateIfNeeded() async {
    final lastScheduledDate = await getLastScheduledDate();

    if (lastScheduledDate == null || isNewDay(lastScheduledDate)) {
      await scheduleDailyUpdate();

      await saveLastScheduledDate();
    }
  }

  Future<void> scheduleDailyUpdate() async {
    final url = Uri.parse('http://10.0.2.2:8082/user/schedule-daily-update');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': widget.email,
          'date': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final message = responseBody['message'];
        print(message);
      } else {
        print('Failed to schedule daily update');
      }
    } catch (error) {
      print('Error scheduling daily update: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    retrieveUserName();
    fetchActivities();
    scheduleDailyUpdateIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String date = DateFormat('MMMM d, y').format(now);
    String day = DateFormat('EEEE').format(now);
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    activities = sortActivitiesByPriority(activities);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 260,
            width: w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Welcome Back!!!",
                      style: GoogleFonts.hahmlet(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Text(
                          date,
                          style: GoogleFonts.abhayaLibre(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          day,
                          style: GoogleFonts.abhayaLibre(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.date_range,
                      color: Colors.grey,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    userName,
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.all(2),
                    height: 100,
                    width: w * 0.95,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              total.toString(),
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                                color: const Color.fromARGB(255, 140, 189, 230),
                              ),
                            ),
                            Text(
                              "Total Task",
                              style: GoogleFonts.davidLibre(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        VerticalDivider(
                          indent: 10,
                          endIndent: 10,
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              c.toString(),
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                                color: Color.fromARGB(255, 124, 190, 126),
                              ),
                            ),
                            Text(
                              "Completed Task",
                              style: GoogleFonts.davidLibre(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        VerticalDivider(
                          indent: 10,
                          endIndent: 10,
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              (total - c).toString(),
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                                color: Color.fromARGB(255, 230, 129, 119),
                              ),
                            ),
                            Text(
                              "To Do",
                              style: GoogleFonts.davidLibre(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    width: 340,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: LinearProgressIndicator(
                            minHeight: 15,
                            backgroundColor: Colors.grey,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                            value: (total == 0) ? 0 : c / total,
                          ),
                        ),
                        Text(
                          (total == 0) ? '0' : '${(c / total * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 13,
                            color: bg,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 5,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 71, 71, 71),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  fetchActivities();
                  retrieveUserName();
                },
                child: Text(
                  "Today's Task",
                  style: GoogleFonts.asap(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color.fromARGB(255, 244, 254, 255),
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton.icon(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                    (states) => Colors.black,
                  ),
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskScreen(
                        email: widget.email,
                        onTaskAdded: fetchActivities,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                label: Text(
                  "Add Task",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          isLoading
              ? Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Color.fromARGB(255, 120, 110, 198),
                    highlightColor: Color.fromARGB(255, 2, 36, 37),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              dummyShimmer(60, 60),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  dummyShimmer(20, 260),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  dummyShimmer(20, 230),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Expanded(
                  child: SizedBox(
                    height: h - 390,
                    width: w,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          for (var activity in activities)
                            TaskItem(
                              activity: activity,
                              onDelete: () {
                                deleteTask(widget.email, activity.title);
                              },
                              onUpdateStatus: (isChecked) {
                                updateTaskStatus(activity.title, isChecked);
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

Widget dummyShimmer(double h, double w) {
  return Container(
    height: h,
    width: w,
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
