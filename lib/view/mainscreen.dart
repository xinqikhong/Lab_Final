import 'package:barterit/view/profiletabscreen.dart';
import 'package:barterit/view/youritemscreen.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import 'allitemscreen.dart';

//for buyer screen

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "All Item";

  @override
  void initState() {
    super.initState();
    print(widget.user.name);
    print("Mainscreen");
    tabchildren = [
      AllItemScreen(user: widget.user),
      YourItemScreen(user: widget.user),
      ProfileTabScreen(user: widget.user),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_bag_rounded,
                ),
                label: "All Item"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.upload_file_rounded,
                ),
                label: "Owner"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Profile"),          
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "All Item";
      }
      if (_currentIndex == 1) {
        maintitle = "Owner";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
    });
  }
}