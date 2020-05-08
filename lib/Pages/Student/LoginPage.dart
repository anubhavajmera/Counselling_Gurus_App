import 'dart:convert';
import 'package:counselling_gurus/Pages/Student/IntroSlider.dart';
import 'package:counselling_gurus/Pages/Student/OTPVerificationPage.dart';
import 'package:counselling_gurus/Pages/Student/SignUpPage.dart';
import 'package:counselling_gurus/models/UserModelSignIn.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Animations/FadeAnimation.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool passwordVisible, validateEmail = false, validatePassword = false;
  String email, password;

  UserSignIn user;
  JsonDecoder jsonDecoder = new JsonDecoder();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  loginUser() async{
    print(user.toJson());
    await http.post('http://192.168.43.70:3060/postloginapp', body: user.toJson(), headers: {"Accept": "application/json"}).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => IntroSlider()));
      }
      print(jsonDecoder.convert(res));
      return jsonDecoder.convert(res);
    });
  }

  addToSF() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("email", emailController.text.toString());
    pref.setString("password", passwordController.text.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.orange[900],
          Colors.orange[800],
          Colors.orange[400]
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                      1.3,
                      Text(
                        "Welcome Back",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60,),
                        FadeAnimation(1.2, Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(225, 95, 27, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )]
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                ),
                                child: TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      errorText: validateEmail ? "Email can't be empty": null,
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                ),
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: !passwordVisible,
                                  decoration: InputDecoration(
                                      errorText: validatePassword ? "Password can't be empty": null,
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        passwordVisible?
                                            Icons.visibility:
                                            Icons.visibility_off,
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                      onPressed: (){
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                    )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                        SizedBox(height: 40,),
                        InkWell(
                          child: FadeAnimation(1.3, Text("Forgot Password?", style: TextStyle(color: Colors.grey),)),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OTPVerificationPage()),),
                        ),
                        SizedBox(height: 40,),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FadeAnimation(1.4,
                                  InkWell(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.orange[900]
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            emailController.text.isEmpty ? validateEmail = true: validateEmail = false;
                                            passwordController.text.isEmpty ? validatePassword = true: validatePassword = false;
                                            email = emailController.text.toString();
                                            password = passwordController.text.toString();
                                            user = new UserSignIn(email: email, password: password);
                                          });
                                          addToSF();
                                          loginUser();
                                        },
                                        child: Center(
                                          child: Text("Log In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(width: 30,),
                            Expanded(
                              child: FadeAnimation(1.6,
                                InkWell(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.orange[900]
                                    ),
                                    child: InkWell(
                                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()),),
                                         // Navigator.of(context).pushReplacementNamed('/SignUpPage'),
                                      child: Center(
                                        child: Text("Sign Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                  ),
                                )),
                            ),
                            ],
                        ),
                        SizedBox(height: 40,),
                        FadeAnimation(1.5, Text("Continue with social media", style: TextStyle(color: Colors.grey),)),
                        SizedBox(height: 30,),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FadeAnimation(
                                  1.8,
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.blue),
                                    child: Center(
                                      child: Text(
                                        "Facebook",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: FadeAnimation(
                                  1.9,
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.black),
                                    child: Center(
                                      child: Text(
                                        "Github",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
