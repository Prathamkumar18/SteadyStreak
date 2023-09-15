import 'package:flutter/material.dart';

class IconSelector extends StatefulWidget {
  final List<IconData> icons;
  final Function(IconData?) onIconSelected;

  const IconSelector({super.key, required this.icons, required this.onIconSelected});

  @override
  // ignore: library_private_types_in_public_api
  _IconSelectorState createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  IconData? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.icons.take(6).map((icon) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIcon = icon;
                  print(selectedIcon);
                });
                widget.onIconSelected(selectedIcon);
              },
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 40.0,
                    color: selectedIcon == icon
                        ? Colors.black
                        : Color.fromARGB(255, 203, 209, 254),
                  ),
                  Text(
                    taskNames.elementAt(widget.icons.indexOf(icon)),
                    style: TextStyle(
                      color: selectedIcon == icon ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.icons.skip(6).map((icon) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIcon = icon;
                });
                widget.onIconSelected(selectedIcon);
              },
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 40.0,
                    color: selectedIcon == icon
                        ? Colors.black
                        : Color.fromARGB(255, 203, 209, 254),
                  ),
                  Text(
                    taskNames.elementAt(widget.icons.indexOf(icon)),
                    style: TextStyle(
                      color: selectedIcon == icon ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

List<String> taskNames = [
  'Morning',
  'Study',
  'Workout',
  'Playing',
  'Shopping',
  'Cooking',
  'Cleaning',
  'Meeting',
  'Time',
  'Relax',
  'Fav',
  'Movie',
];
