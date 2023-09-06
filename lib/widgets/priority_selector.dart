
import 'package:flutter/material.dart';

class PrioritySelector extends StatefulWidget {
  final ValueChanged<String?> onPrioritySelected;

  PrioritySelector({required this.onPrioritySelected});

  @override
  _PrioritySelectorState createState() => _PrioritySelectorState();
}

class _PrioritySelectorState extends State<PrioritySelector> {
  String? selectedPriority;

  List<String> priorityOptions = ['High', 'Medium', 'Low'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: priorityOptions.map((priority) {
        bool isSelected = priority == selectedPriority;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedPriority = priority;
            });
            widget.onPrioritySelected(selectedPriority);
          },
          child: Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (priority == "High")
                  ? Color.fromARGB(255, 254, 182, 177)
                  : (priority == "Low")
                      ? Color.fromARGB(255, 174, 242, 176)
                      : Color.fromARGB(255, 245, 234, 108),
              border: Border.all(
                color: isSelected ? Colors.black : Colors.grey,
                width: isSelected ? 1.0 : 0,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              priority,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: (priority == "High")
                      ? Colors.red
                      : (priority == "Low")
                          ? Colors.green
                          : Color.fromARGB(255, 255, 170, 59)),
            ),
            
          ),
        );
      }).toList(),
    );
  }
}
