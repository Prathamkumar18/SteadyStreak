import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steady_streak/screens/forgot_password_screen.dart';
import 'package:steady_streak/screens/nav_bar.dart';
import 'package:steady_streak/screens/signup_screen.dart';
import 'package:steady_streak/utils/colors.dart';
import 'package:steady_streak/utils/config.dart';
import 'package:steady_streak/widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  late SharedPreferences prefs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };
      var res = await http.post(Uri.parse(login),
          body: jsonEncode(regBody),
          headers: {"content-Type": "application/json"});
      var jsonResponse = jsonDecode(res.body);
      if (res.statusCode == 200) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        showSnackBar(context, "Logged in successfully.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNav(
              token: myToken,
            ),
          ),
        );
      } else {
        String resMessage = jsonResponse["message"].toString();
        showSnackBar(context, resMessage);
      }
    } else {
      showSnackBar(context, "Enter valid Credentials");
    }
  }

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    const SystemUiOverlayStyle(
        statusBarColor: tintWhite, systemNavigationBarColor: white);
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
                      image: AssetImage("assets/images/login.png"),
                      fit: BoxFit.cover)),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Login",
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
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: Text("Forgot Password?",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
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
                text: "Login",
                image: false,
                textColor: white,
                color: Colors.blue,
                onPressed: () {
                  loginUser();
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
                  "Not a member?",
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
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text(
                    "Sign Up",
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
