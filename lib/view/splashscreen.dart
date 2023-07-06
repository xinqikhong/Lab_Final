import 'dart:async';
import 'dart:convert';

import 'package:barterit/view/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/config.dart';
import '../model/user.dart';
import 'loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Bartering_16x9_Homepage.jpg'),
              opacity: 0.8,
              fit: BoxFit.cover
            )         
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "BarterIt",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 48,
                  fontWeight: FontWeight.bold
                ),
              ),
              CircularProgressIndicator(),
              Text(
                "Version 0.1",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              )
            ],)
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    checkAndLogin();
  }

  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool ischeck = (prefs.getBool('checkbox')) ?? false;
    late User user;
    if (ischeck) {
      try {
        http.post(
            Uri.parse("${Config.server}/barterit/php/login_user.php"),
            body: {"email": email, "password": password}).then((response) {
          print(response.body);
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            if (jsondata['status'] == "succcess") {
              user = User.fromJson(jsondata['data']);
              Timer(
                  const Duration(seconds: 3),
                  () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (content) => MainScreen(user: user))));
            } else {
              user = User(
                  id: "na",
                  name: "na",
                  email: "na",
                  password: "na",);
              Timer(
                  const Duration(seconds: 3),
                  () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (content) => MainScreen(user: user))));
            }
          } else {
            user = User(
                id: "na",
                name: "na",
                email: "na",
                password: "na",);
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {
          // Time has run out, do what you wanted to do.
        });
      } on TimeoutException catch (_) {
        print("Time out");
      }
    } else {
      user = User(
          id: "na",
          name: "na",
          email: "na",
          password: "na",);
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }

}

