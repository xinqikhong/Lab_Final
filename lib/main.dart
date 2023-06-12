import 'package:barterit/view/splashscreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarterIt',
      theme: ThemeData(
        brightness: Brightness.light),
      // ignore: prefer_const_constructors
      home: Scaffold(
        // ignore: prefer_const_constructors
        body: SplashScreen(),
      ),
    );
  }
}