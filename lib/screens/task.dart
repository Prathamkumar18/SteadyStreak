import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:steady_streak/utils/colors.dart';
import 'package:steady_streak/widgets/color_selector.dart';
import 'package:steady_streak/widgets/custom_button.dart';
import 'package:steady_streak/widgets/icon_selector.dart';
import 'package:steady_streak/widgets/priority_selector.dart';
import 'package:steady_streak/widgets/yes_no_selector.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController taskController = TextEditingController();
  TextEditingController descController = TextEditingController();

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
                          color: Colors.black),
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
                    print('Selected Icon: $selectedIcon');
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
                    print('Selected Color: $selectedColor');
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
                    print('Selected Priority: $selectedPriority');
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
                    print('Selected Option: $selectedOption');
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: CustomButton(
                      text: "Add Task",
                      color: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {},
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
