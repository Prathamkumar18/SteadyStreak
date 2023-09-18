import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final int val;
  final String date;
  const Box({super.key, required this.val, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: getColor(val),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.white),
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
    if (val == 0)
      return Colors.transparent;
    else if (val >= 1 && val <= 10)
      return Color.fromARGB(255, 2, 76, 5);
    else if (val >= 11 && val <= 30)
      return Color.fromARGB(255, 17, 104, 20);
    else if (val >= 31 && val <= 50)
      return Color.fromARGB(255, 1, 139, 6);
    else if (val >= 51 && val <= 70)
      return Color.fromARGB(255, 1, 189, 7);
    else if (val >= 71 && val <= 90)
      return const Color.fromARGB(255, 1, 222, 9);
    return Color.fromARGB(255, 0, 255, 8);
  }
}
