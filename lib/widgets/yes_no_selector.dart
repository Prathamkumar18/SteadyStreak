import 'package:flutter/material.dart';

class YesNoSelector extends StatefulWidget {
  final ValueChanged<String?> onYesNoSelected;

  YesNoSelector({required this.onYesNoSelected});

  @override
  _YesNoSelectorState createState() => _YesNoSelectorState();
}

class _YesNoSelectorState extends State<YesNoSelector> {
  String? selectedOption;

  List<String> options = ['Yes', 'No'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: options.map((option) {
        bool isSelected = option == selectedOption;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedOption = option;
            });
            widget.onYesNoSelected(selectedOption);
          },
          child: Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.black : Colors.grey,
                width: isSelected ? 1.0 : 0,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              option,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: (option == "Yes")
                      ? Color.fromARGB(255, 9, 138, 13)
                      : Colors.red),
            ),
          ),
        );
      }).toList(),
    );
  }
}
