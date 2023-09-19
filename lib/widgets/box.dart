import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final int val;
  final String date;

  const Box({Key? key, required this.val, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: getColor(val),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                width: 0.5,
                color: Color.fromARGB(255, 128, 202, 207),
              ),
            ),
          ),
          Text(
            date,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Color getColor(int val) {
    if (val == 0) {
      return Colors.transparent;
    } else {
      if (val >= 1 && val <= 10) {
        return Color.fromARGB(255, 2, 76, 5);
      } else if (val >= 11 && val <= 30) {
        return Color.fromARGB(255, 17, 104, 20);
      } else if (val >= 31 && val <= 50) {
        return Color.fromARGB(224, 1, 145, 6);
      } else if (val >= 51 && val <= 70) {
        return Color.fromARGB(166, 2, 210, 9);
      } else if (val >= 71 && val <= 90) {
        return Color.fromARGB(209, 1, 221, 8);
      }
    }
    return Color.fromARGB(255, 0, 255, 8);
  }
}
