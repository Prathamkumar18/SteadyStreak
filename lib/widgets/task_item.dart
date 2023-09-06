import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskItem extends StatefulWidget {
  final Icon icon;
  final Color color;
  final String title;
  final String desc;
  final String priority;
  final ValueChanged<bool> onChecked;
  TaskItem(
      {super.key,
      required this.icon,
      required this.color,
      required this.title,
      required this.desc,
      required this.priority,
      required this.onChecked});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
        height: 100,
        margin: EdgeInsets.only(top: 5, left: 10, right: 10),
        width: w - 20,
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: widget.color, width: 2),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              height: 80,
              width: 10,
              decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
            ),
            Container(
                height: 90,
                padding: EdgeInsets.only(
                  left: 10,
                  top: 10,
                ),
                width: 340,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        widget.icon,
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              widget.title,
                              maxLines: 1,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: widget.color),
                            ),
                          ),
                        ),
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (widget.priority == "High")
                                ? Color.fromARGB(255, 254, 182, 177)
                                : (widget.priority == "Low")
                                    ? Color.fromARGB(255, 174, 242, 176)
                                    : Color.fromARGB(255, 245, 234, 108),
                          ),
                          child: Icon(Icons.arrow_upward,
                              color: (widget.priority == "High")
                                  ? Colors.red
                                  : (widget.priority == "Low")
                                      ? Colors.green
                                      : Color.fromARGB(255, 255, 170, 59)),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.priority,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: (widget.priority == "High")
                                ? Colors.red
                                : (widget.priority == "Low")
                                    ? Colors.green
                                    : Color.fromARGB(255, 255, 170, 59),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              widget.desc,
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: widget.color),
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: 1.4,
                          child: Theme(
                            data:
                                ThemeData(unselectedWidgetColor: widget.color),
                            child: Checkbox(
                              activeColor: Colors.green,
                              value: isChecked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  isChecked = newValue!;
                                  widget.onChecked(isChecked);
                                });
                              },
                            ),
                          ),
                        ),
                        Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                          size: 35,
                        )
                      ],
                    ),
                  ],
                )),
          ],
        ));
  }
}
