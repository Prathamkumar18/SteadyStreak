import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:steady_streak/screens/task.dart';
import 'package:steady_streak/utils/colors.dart';
import 'package:steady_streak/utils/config.dart';
import 'package:steady_streak/utils/utils.dart';
import 'package:steady_streak/widgets/task_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity.dart';
import '../services/methods.dart';

class HomeScreen extends StatefulWidget {
  final String email;

  const HomeScreen({
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

  Future<void> fetchActivities() async {
    final response =
        await http.get(Uri.parse('$url/user/${widget.email}/all-activities'));

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
      setState(() {
        final updatedActivity = activities.firstWhere(
          (activity) => activity.title == title,
        );
        updatedActivity.isChecked = isChecked;
        c = countCompletedTasks(activities);
      });
    } else {
      showSnackBar(context,'Failed to update task status');
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
        fetchActivities();
      });
    } else {
      showSnackBar(context,'Failed to delete task');
    }
  }

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
      final currentDate = DateTime.now();
      currentDate.subtract(Duration(days: 1));
      final previousDay = currentDate.toIso8601String();
      await scheduleUserDailyUpdate(previousDay);
      await saveLastScheduledDate();
    }
  }

  Future<void> scheduleUserDailyUpdate(String date) async {
    final url = Uri.parse(updateDaily);
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': widget.email,
          'date': date,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final message = responseBody['message'];
        showSnackBar(context,message);
      } else {
        showSnackBar(context,'Failed to schedule daily update');
      }
    } catch (error) {
      showSnackBar(context,'Error scheduling daily update: $error');
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
      backgroundColor: black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 260,
            width: w,
            decoration: BoxDecoration(
              color: tintWhite,
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
                        color: black,
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
                            color: black,
                          ),
                        ),
                        Text(
                          day,
                          style: GoogleFonts.abhayaLibre(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: black,
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
                    (userName.isEmpty)
                        ? ""
                        : userName.substring(0, 1).toUpperCase() +
                            userName.substring(1),
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
                      border: Border.all(color: black, width: 0.5),
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
                                color: black,
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
                                color: black,
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
                                color: black,
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
                            valueColor: AlwaysStoppedAnimation<Color>(black),
                            value: (total == 0) ? 0 : c / total,
                          ),
                        ),
                        Text(
                          (total == 0) ? '0' : '${(c / total * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 13,
                            color: tintWhite,
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
                    (states) => black,
                  ),
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => white,
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
                  color: black,
                ),
                label: Text(
                  "Add Task",
                  style: TextStyle(color: black),
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
                    child: (activities.isEmpty)
                        ? Container(
                            height: 300,
                            width: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/empty.png"),
                                    fit: BoxFit.fill)),
                          )
                        : SingleChildScrollView(
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
                                      updateTaskStatus(
                                          activity.title, isChecked);
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
      color: black.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
