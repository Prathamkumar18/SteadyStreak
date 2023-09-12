// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:steady_streak/screens/home_screen.dart';
import 'package:steady_streak/utils/colors.dart';
import 'package:steady_streak/utils/config.dart';
import 'package:steady_streak/widgets/color_selector.dart';
import 'package:steady_streak/widgets/custom_button.dart';
import 'package:steady_streak/widgets/icon_selector.dart';
import 'package:steady_streak/widgets/priority_selector.dart';
import 'package:steady_streak/widgets/yes_no_selector.dart';

class AddTaskScreen extends StatefulWidget {
  String email;
  final Function onTaskAdded;
  AddTaskScreen({
    Key? key,
    required this.email,
    required this.onTaskAdded,
  }) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController taskController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String priority = "";
  String color = "";
  String daily = "";
  String icon = "";
  bool check() {
    if (taskController.text.isEmpty ||
        descController.text.isEmpty ||
        color.isEmpty ||
        icon.isEmpty ||
        priority.isEmpty ||
        daily.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> addActivity(
  String email, Map<String, dynamic> activityData) async {
  final url = Uri.parse('$addTask/$email');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(activityData),
  );

  if (response.statusCode == 200) {
    widget.onTaskAdded();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(email: email)),
    );
  } else {
    print('Failed to add activity: ${response.body}');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Create New Task",
                      style: GoogleFonts.wellfleet(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.blue),
                    ),
                    Spacer(),
                    Icon(
                      Icons.description_outlined,
                      size: 50,
                      color: Colors.blue,
                    ),
                  ],
                ),
                Text(
                  "Lets be productive!",
                  style: GoogleFonts.wellfleet(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Task Name",
                        style: GoogleFonts.nobile(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: taskController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Task";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: "eg.Workout",
                            prefixIcon: Icon(
                              Icons.task,
                              color: Color.fromARGB(255, 85, 174, 247),
                              size: 30,
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Task Description",
                        style: GoogleFonts.nobile(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: descController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Description";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            hintText: "eg. Evening Workout",
                            prefixIcon: Icon(
                              Icons.description,
                              color: Color.fromARGB(255, 85, 174, 247),
                              size: 30,
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                IconSelector(
                  icons: [
                    Icons.wb_sunny,
                    Icons.book,
                    Icons.fitness_center,
                    Icons.videogame_asset,
                    Icons.shopping_cart,
                    Icons.kitchen,
                    Icons.cleaning_services,
                    Icons.event,
                    Icons.access_time,
                    Icons.spa,
                    Icons.star,
                    Icons.movie,
                  ],
                  onIconSelected: (selectedIcon) {
                    setState(() {
                      icon = selectedIcon.toString();
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Tile Color",
                  style: GoogleFonts.nobile(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 5,
                ),
                ColorSelector(
                  onColorSelected: (selectedColor) {
                    setState(() {
                      color = selectedColor.toString();
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Priority",
                  style: GoogleFonts.nobile(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 5,
                ),
                PrioritySelector(
                  onPrioritySelected: (selectedPriority) {
                    setState(() {
                      priority = selectedPriority.toString();
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Daily ?",
                  style: GoogleFonts.nobile(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 5,
                ),
                YesNoSelector(
                  onYesNoSelected: (selectedOption) {
                    setState(() {
                      daily = selectedOption.toString();
                    });
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: CustomButton(
                      text: "Add Task",
                      color: (check()) ? Colors.black : Colors.grey,
                      textColor: Colors.white,
                      onPressed: () {
                        if (check()) {
                          final userEmail = widget.email;
                          final activityDetails = {
                            'color': color,
                            'icon': icon,
                            'title': taskController.text.toString(),
                            'description': descController.text.toString(),
                            'priority': priority,
                            'daily': daily,
                          };
                          addActivity(userEmail, activityDetails);
                        }
                      },
                      image: false),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ));
  }
}
