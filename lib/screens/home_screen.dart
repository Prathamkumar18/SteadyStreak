import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:steady_streak/screens/task.dart';
import 'package:steady_streak/utils/colors.dart';
import 'package:steady_streak/widgets/task_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Pratham Kumar";
  int c = 0;
  int total = 6;
  void incrementCounter(bool isChecked) {
    setState(() {
      if (isChecked) {
        c++;
      } else {
        c--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String date = DateFormat('MMMM d, y').format(now);
    String day = DateFormat('EEEE').format(now);
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 250,
              width: w,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 228, 228, 228),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
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
                                color: Colors.black),
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Text(
                                date,
                                style: GoogleFonts.abhayaLibre(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: Colors.black),
                              ),
                              Text(
                                day,
                                style: GoogleFonts.abhayaLibre(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.date_range,
                            color: Colors.grey,
                          )
                        ]),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        userName,
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.grey),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    total.toString(),
                                    style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50,
                                        color: const Color.fromARGB(
                                            255, 140, 189, 230)),
                                  ),
                                  Text(
                                    "Total Task",
                                    style: GoogleFonts.davidLibre(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    c.toString(),
                                    style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50,
                                        color:
                                            Color.fromARGB(255, 124, 190, 126)),
                                  ),
                                  Text(
                                    "Completed Task",
                                    style: GoogleFonts.davidLibre(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    (total - c).toString(),
                                    style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50,
                                        color:
                                            Color.fromARGB(255, 230, 129, 119)),
                                  ),
                                  Text(
                                    "To Do",
                                    style: GoogleFonts.davidLibre(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ]),
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
                                value: c / total,
                              ),
                            ),
                            Text(
                              '${(c / total * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 13,
                                color: bg,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ])),
          SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              Text(
                "Activities:",
                style: GoogleFonts.davidLibre(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black),
              ),
              Spacer(),
              ElevatedButton.icon(
                  style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTaskScreen()),
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Add Task",
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SizedBox(
              height: h - 390,
              width: w,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    TaskItem(
                      icon: Icon(
                        Icons.fitness_center,
                        color: Color.fromARGB(255, 195, 150, 205),
                      ),
                      color: Color.fromARGB(255, 195, 150, 205),
                      desc: "Morning Workout",
                      priority: "High",
                      onChecked: incrementCounter,
                      title: "Workout",
                    ),
                    TaskItem(
                      icon: Icon(
                        Icons.book,
                        color: Color.fromARGB(255, 244, 190, 186),
                      ),
                      color: Color.fromARGB(255, 244, 190, 186),
                      desc: "Coding",
                      onChecked: incrementCounter,
                      priority: "Medium",
                      title: "Study",
                    ),
                    TaskItem(
                      icon: Icon(
                        Icons.book,
                        color: Color.fromARGB(255, 126, 173, 202),
                      ),
                      color: Color.fromARGB(255, 126, 173, 202),
                      desc: "College work",
                      priority: "Low",
                      onChecked: incrementCounter,
                      title: "Study",
                    ),
                    TaskItem(
                      icon: Icon(
                        Icons.fitness_center,
                        color: Color.fromARGB(255, 145, 232, 148),
                      ),
                      color: Color.fromARGB(255, 145, 232, 148),
                      desc: "Morning Workout",
                      priority: "High",
                      onChecked: incrementCounter,
                      title: "Workout",
                    ),
                    TaskItem(
                      icon: Icon(Icons.book, color: Colors.red),
                      color: Colors.red,
                      desc: "Coding",
                      onChecked: incrementCounter,
                      priority: "Medium",
                      title: "Study",
                    ),
                    TaskItem(
                      icon: Icon(Icons.book, color: Colors.green),
                      color: Colors.green,
                      desc: "College work",
                      priority: "Low",
                      onChecked: incrementCounter,
                      title: "Study",
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
