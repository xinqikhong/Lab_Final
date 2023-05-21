import 'dart:convert';

import 'package:barterit/view/mainscreen.dart';
import 'package:barterit/view/registerscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
//import 'package:progress_dialog/progress_dialog.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../model/config.dart';
import '../model/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenHeight, screenWidth;
  final _formKey = GlobalKey<FormState>();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final TextEditingController _emailditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  //bool _passwordVisible = true;
  bool _showProgressIndicator = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          upperHalf(context),
          lowerHalf(context)
        ],
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return SizedBox(
      height: screenHeight / 2,
      width: screenWidth,
      child: Image.asset(
        'assets/images/login.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    
    return Container(
        height: 600,
        margin: EdgeInsets.only(top: screenHeight / 3),
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty ||
                          !val.contains("@") ||
                          !val.contains(".")
                          ? "enter a valid email"
                          : null,
                        focusNode: focus,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus1);
                          },
                          controller: _emailditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                          labelStyle: TextStyle(),
                          labelText: 'Email',
                          icon: Icon(Icons.phone),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                            width: 2.0),
                          )
                        )
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        validator: (val) => validatePassword(val.toString()),
                        focusNode: focus1,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus2);
                        },
                        controller: _passEditingController,
                        
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
              
                          ),
                          /*suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                              ? Icons.visibility
                              // ignore: dead_code
                              : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),*/
                          labelText: 'Password',
                          icon: Icon(Icons.lock),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0
                            ),
                          )
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                            color: Colors.blue,
                            minWidth: 115,
                            height: 50,
                            elevation: 10,
                            onPressed: _loginUser,
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white)),
                          ),
                        ]
                      ),
                    ],
                  )
                )
              )
            ),
            const SizedBox(
                        height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Register new account? ",
                style: TextStyle(fontSize: 16.0, )),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          title: const Text(
                            "Register new Account",
                            style: TextStyle(
                            // Customize the title style if needed
                            ),
                          ),
                          content: const Text(
                            "Are you sure?",
                            style: TextStyle(
                            // Customize the content style if needed
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Yes"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => const RegisterScreen(),
                                  ),
                                );
                              },
                            ),
                            TextButton(
                              child: const Text("No"),
                              onPressed: () {
                              Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    "Click here",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Forgot password? ",
                style: TextStyle(fontSize: 16.0, )),
                GestureDetector(
                  onTap: null,
                  child: const Text(" Click here",
                    style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),  
          ],
        )));
  }

  void _loginUser() {
    // Make an HTTP request and handle the response
    // Example using the http package:
    /*ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.style(
      message: "Please wait..",
    );
  
    progressDialog.show();*/
    if (_formKey.currentState!.validate()) {
      print("line 265");
      //return;
    
      /*setState(() {
        _showProgressIndicator = true;
      });*/
    //http.post(Uri.parse("your_login_url"),
    //http.post('your_login_url' as Uri, 
    http.post(Uri.parse("${Config.server}/barterit/php/login_user.php"), 
    body: {
      'email': _emailditingController.text,
      'password': _passEditingController.text,
    }).then((response) {
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      /*if (response.statusCode == 200 && response.body != "failed") {
        //progressDialog.hide();
        print("success line 282");
        final jsonResponse = json.decode(response.body);
        User user = User.fromJson(jsonResponse);*/

      if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          print('Decoded response: $jsonResponse');

          if (jsonResponse['status'] == 'success') {
            User user = User.fromJson(jsonResponse['data']);  
        
        // Use the user object as needed
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen(),
          )
        );

        Fluttertoast.showToast(
          msg: "Login Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);

      } else {
        // Handle failed login
        print(" line 304");
        Fluttertoast.showToast(
          msg: "Login Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0,
        );
      }
    } else{
      // Handle non-200 response status
          Fluttertoast.showToast(
            msg: "Error: ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0,
          );
      }
      /*setState(() {
         _showProgressIndicator = false;
      });*/

    }).catchError((error) {
      // Handle any errors that occur during the HTTP request
      /*setState(() {
        _showProgressIndicator = false;*/
        print(" line 322");
        print(error);
        Fluttertoast.showToast(
        msg: "Error: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 14.0,
      );
      });
    }}
  
  validatePassword(String string) {}
}