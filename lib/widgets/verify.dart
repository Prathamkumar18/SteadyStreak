// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/config.dart';
import '../utils/utils.dart';

class VerifyBox extends StatefulWidget {
  final String title;
  final String description;
  final String imageURL;
  final String email;
  final bool isVarified;
  final VoidCallback onDelete;

  VerifyBox({
    Key? key,
    required this.title,
    required this.description,
    required this.imageURL,
    required this.email,
    required this.isVarified,
    required this.onDelete,
  }) : super(key: key);

  @override
  _VerifyBoxState createState() => _VerifyBoxState();
}

class _VerifyBoxState extends State<VerifyBox> {
  Future<void> updateTaskStatusLike(String title, bool isChecked) async {
    final url = Uri.parse(updateActivityStatus);
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': widget.email,
        'title': title,
        'isChecked': false,
        'isPending': true
      }),
    );

    if (response.statusCode == 200) {
      widget.onDelete;
    } else {
      showSnackBar(context, 'Failed to update task status');
    }
  }

  Future<void> updateTaskStatusDislike(String title, bool isChecked) async {
    final url = Uri.parse(updateActivityStatus);
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': widget.email,
        'title': title,
        'isPending': false,
        'isChecked': true
      }),
    );

    if (response.statusCode == 200) {
      widget.onDelete;
    } else {
      showSnackBar(context, 'Failed to update task status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          height: 300,
          width: 360,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 238, 246, 251),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "  Title: ${widget.title}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text("  Description: ${widget.description}",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 124, 124, 124),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  )),
              GestureDetector(
                onTap: () {
                  _showImageDialog(context);
                },
                child: Container(
                  height: 180,
                  width: 340,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.imageURL),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        updateTaskStatusLike(widget.title, true);
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.thumb_down,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        updateTaskStatusDislike(widget.title, true);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 320,
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.imageURL),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
