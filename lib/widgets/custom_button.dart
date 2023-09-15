// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  final bool image;
  
  const CustomButton({
    Key? key,
    required this.text,
    required this.color,
    required this.textColor,
    required this.onPressed,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: 340,
      child: ElevatedButton(
          // ignore: sort_child_properties_last
          child: image == false
              ? Text(
                  text,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: AssetImage("Assets/Images/google.png")),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
          onPressed: onPressed,
          style: ButtonStyle(
              elevation: MaterialStateProperty.resolveWith((states) => 0),
              backgroundColor: MaterialStateProperty.all(color),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))))),
    );
  }
}