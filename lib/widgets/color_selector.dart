import 'package:flutter/cupertino.dart';

class ColorSelector extends StatefulWidget {
  final ValueChanged<Color?> onColorSelected;

  ColorSelector({required this.onColorSelected});

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  Color? selectedColor;

  List<Color> colorOptions = [
    Color.fromARGB(255, 244, 190, 186),
    Color.fromARGB(255, 126, 173, 202),
    Color.fromARGB(255, 145, 232, 148),
    Color.fromARGB(255, 232, 220, 127),
    Color.fromARGB(255, 195, 150, 205),
    Color.fromRGBO(225, 189, 135, 1),
  ];

  double selectedSize = 50.0;
  double unselectedSize = 40.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: colorOptions.map((color) {
        bool isSelected = color == selectedColor;
        double size = isSelected ? selectedSize : unselectedSize;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedColor = color;
            });
            widget.onColorSelected(selectedColor);
          },
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        );
      }).toList(),
    );
  }
}
