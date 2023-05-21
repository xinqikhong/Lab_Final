import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../model/config.dart';
import 'loginscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'mainscreen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late double screenHeight, screenWidth;
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String eula;
  bool _isChecked = false;
  bool _passwordVisible = true;
  bool _passwordVisible1 = true;

  
  

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    

    return Scaffold(
      body: Stack(
        children: [
          upperHalf(context),
          lowerHalf(context),
          
        ],
      ),
    );
  }

    Widget upperHalf(BuildContext context) {
      return SizedBox(
        height: screenHeight / 2,
        width: screenWidth,
        child: Image.asset(
          'assets/images/register.jpg',
          fit: BoxFit.cover,
        ),
      );
    }

    Widget lowerHalf(BuildContext context) {
      return Container(
        height: 600,
        margin: EdgeInsets.only(top: screenHeight / 5),
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
                      children: <Widget>[
                        //Form registration here
                        const Text(
                          "Register New Account",
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
                          validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "name must be longer than 3"
                            : null,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus);
                          },
                          controller: _nameEditingController,
                          keyboardType: TextInputType.text,
                          
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                            ),
                            icon: Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                              borderSide:BorderSide( width: 2.0),
                            )
                          )
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || !val.contains("@") || !val.contains(".")
                            ? "Enter a valid email"
                            : null,
                          focusNode: focus,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus1);
                          },
                          controller: _emailditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.phone),
                            focusedBorder: OutlineInputBorder(
                              borderSide:BorderSide(width: 2.0),
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
                          decoration:  InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
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
                            ),
                            icon: const Icon(Icons.lock),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:BorderSide( width: 2.0),
                            ),
                            
                          ),
                          obscureText: _passwordVisible,
                        ),
                        TextFormField(
                          style: const TextStyle(
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (val) {
                            validatePassword(val.toString());
                            if (val != _passEditingController.text) {
                              return "password do not match";
                            } else {
                              return null;
                            }
                          },
                          focusNode: focus2,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus3);
                          },
                          controller: _pass2EditingController,
                          decoration: InputDecoration(
                            labelText: 'Re‐enter Password',
                            labelStyle: const TextStyle(
                               
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                              _passwordVisible1
                                ? Icons.visibility
                                // ignore: dead_code
                                : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible1 = !_passwordVisible1;
                                });
                              },
                            ),
                            icon: const Icon(Icons.lock),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:BorderSide( width: 2.0),
                            )
                          ),
                          obscureText: _passwordVisible1,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value ?? true;
                                });
                              },
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: _showEULA,
                                child: const Text(
                                  'Agree with terms',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
                              ),
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)
                              ),
                              color: Colors.blue,
                              minWidth: 115,
                              height: 50,
                              child: const Text(
                                'Register', 
                                style: TextStyle(color: Colors.white)),
                              elevation: 10,
                              onPressed: _registerAccount,
                            ),
                          ],
                        ),
                  
                      ]
                    ),
                  ),
                ),
                //Already regiter link here
                //Back home link here
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Already Register? ",
                    style: TextStyle(fontSize: 16.0, )
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(context,
                      MaterialPageRoute(
                      builder: (BuildContext context) =>const LoginScreen()))
                    },
                    child: const Text(
                      "Login here",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
              
            ],
          ),
        ),
      );
    }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }
  
  Future<void> loadEula() async {
    eula = await rootBundle.loadString('assets/eula.txt');
  }

  void _showEULA() {
    loadEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
            style: TextStyle(
               
            ),
          ),
          content: SizedBox(
            height: screenHeight / 1.5,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: RichText(
                      softWrap: true,
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: const TextStyle(
                              
                          fontSize: 12.0,
                        ),
                        text: eula
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _registerAccountDialog() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the registration form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    //bool _isChecked = false;
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please accept the terms and conditions",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(
               
            ),
          ),
          content: const Text("Are you sure?",
              style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(
                   
                ),
              ),
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Successfully Registered",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  fontSize: 14.0);
                Navigator.of(context).pop();
                _registerUserAccount();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(
                   
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }

  void _registerUserAccount() {
    FocusScope.of(context).requestFocus(FocusNode());
    String name = _nameEditingController.text;
    String email = _emailditingController.text;
    String pass = _passEditingController.text;
    
    http.post(Uri.parse("${Config.server}/barterit/php/register_user.php"),
        body: {"name": name, "email": email, "password": pass})
    .then((response) {
      if (kDebugMode) {
        print(response.body);
      }
    });

    Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen(),
          )
        );

    /*ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.style(
      message: "Registration in progress..",
      //title: const Text("Registering..."),
      
    );
    progressDialog.show();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Registering...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        },
      );


      http.post(Uri.parse("${Config.server}/barterit/php/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "password": pass,
        }).then((response) {
          var data = jsonDecode(response.body);
          if (response.statusCode == 200 && data['status'] == 'success') {
            Fluttertoast.showToast(
              msg: "Registration Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
            progressDialog.hide();
            // Navigate to the desired screen after successful registration
            Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
          } else {
            Fluttertoast.showToast(
              msg: "Registration Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
            progressDialog.hide();
          }
        }
      );*/
}

  void _registerAccount() {
    _registerAccountDialog();
    /*() => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const MainScreen()));*/
  }


}