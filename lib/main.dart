import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steady_streak/screens/login_screen.dart';
import 'package:steady_streak/screens/nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(MyApp(
    token: prefs.getString('token'),
  ));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SteadyStreak',
        home: (token == null || JwtDecoder.isExpired(token))
            ? LoginScreen()
            : BottomNav(token: token));
  }
}
