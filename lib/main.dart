import 'package:flutter/material.dart';
import 'package:steady_streak/screens/login_screen.dart';
import 'package:steady_streak/screens/nav_bar.dart';

void main() { 
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SteadyStreak',
        home: BottomNav(
          email: "p@gmail.com",
        ));
  }
}
