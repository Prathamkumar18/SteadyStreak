import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:steady_streak/screens/login_screen.dart';
import 'package:steady_streak/utils/colors.dart';
import 'package:steady_streak/utils/config.dart';
import 'package:steady_streak/widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import '../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text
      };
      var res = await http.post(Uri.parse(signup),
          body: jsonEncode(regBody),
          headers: {"content-Type": "application/json"});
      if (res.statusCode == 200) {
        showSnackBar(context, "Registered successfully");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        var jsonResponse = jsonDecode(res.body);
        if (jsonResponse["message"].toString().contains("duplicate")) {
          showSnackBar(context, "Email already exist");
        } else {
          showSnackBar(context, "Enter valid Credentials");
        }
      }
    } else {
      showSnackBar(context, "Enter valid Credentials");
    }
  }

  @override
  Widget build(BuildContext context) {
    const SystemUiOverlayStyle(
        statusBarColor: tintWhite, systemNavigationBarColor: Colors.white);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/signup.png"),
                      fit: BoxFit.cover)),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sign Up",
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 40,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter username";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: "eg.user_18",
                              label: const Text(
                                "Username",
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                              prefixIcon: Icon(Icons.person)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
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
                              label: const Text(
                                "Email ID",
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                              prefixIcon: Icon(Icons.alternate_email_outlined)),
                        ),
                        const SizedBox(height: 15),
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.w400)),
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
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: CustomButton(
                text: "Sign up",
                image: false,
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () {
                  registerUser();
                },
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already a member?",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
