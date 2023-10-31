import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/activity.dart';
import '../utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class TaskItem extends StatefulWidget {
  final Activity activity;
  final VoidCallback onDelete;
  final String email;
  final ValueChanged<bool> onUpdateStatus;

  XFile? file;
  ImagePicker _picker = ImagePicker();
  TaskItem({
    Key? key,
    required this.activity,
    required this.onDelete,
    required this.onUpdateStatus,
    required this.email,
  }) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  Future<void> uploadImageToFirebaseStorage(XFile? image) async {
    if (image == null) {
      showSnackBar(context, "No image selected.");
      return;
    }

    final String imageFileName =
        '${widget.email}_${widget.activity.title}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference storageReference =
        _storage.ref().child('task_images/$imageFileName');

    try {
      UploadTask uploadTask = storageReference.putFile(File(image.path));
      await uploadTask;

      if (uploadTask.snapshot.state == TaskState.success) {
        final String downloadURL = await storageReference.getDownloadURL();

        final Map<String, dynamic> taskData = {
          'email': widget.email,
          'title': widget.activity.title,
          'description': widget.activity.description,
          'imageURL': downloadURL,
          'isVerified':false,
        };

        final String email = widget.email.replaceAll('.', '-');
        final String title = widget.activity.title.replaceAll('.', '-');
        final String compositeKey = '$email-${title}';
        _databaseReference.child('tasks/$compositeKey').set(taskData);
      } else {
        showSnackBar(context, "Image upload failed. Please try again.");
      }
    } catch (e) {
      showSnackBar(context, "An error occurred during the upload: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(top: 5, left: 10, right: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 37, 37, 37),
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
                    (widget.activity.isChecked == true)
                        ? Container(
                            height: 20,
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _parseColor(widget.activity.color),
                            ),
                            child: Center(
                              child: Text(
                                "Task completed",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : (widget.activity.isPending == false)
                            ? Container(
                                height: 20,
                                width: 130,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final XFile? photo = await widget._picker
                                        .pickImage(source: ImageSource.gallery);
                                    setState(() {
                                      widget.file = photo;
                                      widget.activity.isPending = true;
                                      widget.onUpdateStatus(true);
                                      uploadImageToFirebaseStorage(photo);
                                    });
                                  },
                                  child: Text(
                                    "Upload Image",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              )
                            : Container(
                                height: 20,
                                width: 130,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _parseColor(widget.activity.color),
                                ),
                                child: Center(
                                  child: Text(
                                    "Verification pending",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
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
          showSnackBar(context, 'Error parsing color: $e');
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
