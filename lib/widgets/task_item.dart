import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/activity.dart';
import '../utils/utils.dart';

class TaskItem extends StatefulWidget {
  final Activity activity;
  final VoidCallback onDelete;
  final ValueChanged<bool> onUpdateStatus;

  const TaskItem({
    Key? key,
    required this.activity,
    required this.onDelete,
    required this.onUpdateStatus,
  }) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(top: 5, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: _parseColor(widget.activity.color),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            height: 80,
            width: 10,
            decoration: BoxDecoration(
              color: _parseColor(widget.activity.color),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
          ),
          Container(
            height: 90,
            padding: EdgeInsets.only(left: 10, top: 10),
            width: 340,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      _getIconDataForActivity(widget.activity.icon),
                      color: _parseColor(widget.activity.color),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: SizedBox(
                        width: 250,
                        child: Text(
                          widget.activity.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: _parseColor(widget.activity.color),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getPriorityColor(widget.activity.priority),
                      ),
                      child: Icon(
                        Icons.arrow_upward,
                        color: _getPriorityIconColor(widget.activity.priority),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.activity.priority,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: _getPriorityColor(widget.activity.priority),
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
                          widget.activity.description,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: _parseColor(widget.activity.color),
                          ),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 1.4,
                      child: Theme(
                          data: ThemeData(
                            unselectedWidgetColor:
                                _parseColor(widget.activity.color),
                          ),
                          child: Checkbox(
                            activeColor: Colors.green,
                            value: widget.activity.isChecked,
                            onChanged: (bool? newValue) {
                              setState(() {
                                widget.activity.isChecked = newValue!;
                                widget.onUpdateStatus(newValue);
                              });
                            },
                          )),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        size: 35,
                      ),
                      color: Colors.red,
                      onPressed: () {
                        widget.onDelete();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String colorValue) {
    final colorRegExp = RegExp(r'0x([0-9A-Fa-f]+)');
    final match = colorRegExp.firstMatch(colorValue);

    if (match != null && match.groupCount >= 1) {
      final hexColor = match.group(1);
      if (hexColor != null && hexColor.isNotEmpty) {
        try {
          final intColor = int.parse(hexColor, radix: 16);
          return Color(intColor);
        } catch (e) {
         showSnackBar(context,'Error parsing color: $e');
        }
      }
    }
    return Colors.transparent;
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Color.fromARGB(255, 254, 182, 177);
      case 'Low':
        return Color.fromARGB(255, 174, 242, 176);
      default:
        return Color.fromARGB(255, 245, 234, 108);
    }
  }

  Color _getPriorityIconColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Low':
        return Colors.green;
      default:
        return Color.fromARGB(255, 255, 170, 59);
    }
  }

  IconData _getIconDataForActivity(String iconString) {
    if (iconString.startsWith('IconData(U+')) {
      final hexString = iconString.substring(11, iconString.length - 1);
      final intCodePoint = int.tryParse(hexString, radix: 16) ?? 0;
      return IconData(intCodePoint, fontFamily: 'MaterialIcons');
    }
    return Icons.error;
  }
}