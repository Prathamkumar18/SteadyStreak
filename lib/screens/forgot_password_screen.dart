import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:steady_streak/screens/login_screen.dart';
import 'package:steady_streak/utils/colors.dart';
import 'package:steady_streak/utils/utils.dart';
import 'package:steady_streak/widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import '../utils/config.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;

  Future<void> updateUserPassword() async {
    final apiUrl = '$updatePassword/${emailController.text}';
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"newPassword": passwordController.text}),
    );
    if (response.statusCode == 200) {
      showSnackBar(context, 'Password updated successfully');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      showSnackBar(context, 'Failed to update password');
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    SystemUiOverlayStyle(statusBarColor: background);
    return Scaffold(
        backgroundColor: background,
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: h * 0.08,
              ),
              Container(
                  height: h * 0.30,
                  width: w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/forgetPassword.png"),
                          fit: BoxFit.cover))),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Forgot",
                    style: TextStyle(
                        color: black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Password?",
                    style: TextStyle(
                        color: black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Don't worry! It happens. Please enter the\nemail address associated with your account.",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20, bottom: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter email";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            hintText: "eg.xyz1@gmail.com",
                            label: Text(
                              "Email ID",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            prefixIcon: Icon(Icons.alternate_email_outlined)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Password";
                          } else if (value.length < 6) {
                            return "Password should be >=6";
                          } else {
                            return null;
                          }
                        },
                        obscureText: passwordVisible == true ? false : true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            hintText: "length should be >=6",
                            label: Text("Password",
                                style: TextStyle(fontWeight: FontWeight.w400)),
                            prefixIcon: Icon(Icons.lock_open),
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                child: Icon(passwordVisible == true
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined))),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Center(
                child: CustomButton(
                  text: "Submit",
                  image: false,
                  textColor: white,
                  color: Colors.blue,
                  onPressed: () {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      showSnackBar(context, "Enter complete details");
                    } else {
                      updateUserPassword();
                    }
                  },
                ),
              ),
            ])));
  }
}
