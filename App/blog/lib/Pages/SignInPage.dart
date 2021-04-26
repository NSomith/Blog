import 'dart:convert';

import 'package:blog/Network/networkHandler.dart';
import 'package:blog/Pages/HomePage.dart';
import 'package:blog/Pages/SignUpPage.dart';
import 'package:blog/Pages/forgotPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool vis = true;
  final globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController uname = TextEditingController();
  TextEditingController uemail = TextEditingController();
  TextEditingController upassword = TextEditingController();
  final storage = FlutterSecureStorage();

  String errText;
  bool validate = false;
  bool circular = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Colors.green[200]],
                begin: const FractionalOffset(0.0, 1.0),
                end: FractionalOffset(0.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.repeated)),
        child: Form(
          key: globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign in with email"),
              SizedBox(
                height: 20,
              ),
              usernameText(),
              passwordText(),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    circular = true;
                  });
                  Map<String, dynamic> data = {
                    "username": uname.text,
                    "password": upassword.text
                  };
                  // we will get a token from the backend

                  var response = await networkHandler.post("/user/login", data);
                  Map<String, dynamic> output = json.decode(response.body);
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    setState(() {
                      validate = true;
                      circular = false;
                    });
                    print(output['token']);
                    await storage.write(key: "token", value: output['token']);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false);
                  } else {
                    setState(() {
                      circular = false;
                      validate = false;
                      errText = "Username or password is incorrect";
                    });
                  }
                },
                child: circular
                    ? CircularProgressIndicator()
                    : Container(
                        height: 50,
                        width: 140,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(child: Text("Sign In")),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage()));
                      },
                      child: Text("Forgot password? ")),
                  SizedBox(
                    width: 2,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPAge()));
                      },
                      child: Text("New User"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  checkUser() async {
    if (uname.text.length == 0) {
      setState(() {
        circular = false;
        validate = false;
        errText = "Useranme cant be empty";
      });
    } else {
      var resposne =
          await networkHandler.get("/user/checkusername/${uname.text}");
      if (resposne['status']) {
        setState(() {
          circular = false;
          validate = false;
          errText = "Useranme taken";
        });
      } else {
        setState(() {
          circular = true;
          validate = true;
          // errText = "Useranme taken";
        });
      }
    }
  }

  Widget usernameText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Column(
        children: [
          Text("Username"),
          TextFormField(
            controller: uname,
            // validator: (value) {
            //   if (value.isEmpty) {
            //     return "Username cannot be empty";
            //   }
            //   // check for unique uname
            //   return null;
            // },
            decoration: InputDecoration(
              errorText: validate ? null : errText,
            ),
          )
        ],
      ),
    );
  }

  Widget emailText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Column(
        children: [
          Text("email"),
          TextFormField(
            controller: uemail,
            validator: (value) {
              if (value.isEmpty) {
                return "email cannot be empty";
              }
              if (!value.contains("@")) {
                return "Email invalid";
              }
              // check for unique uname
              return null;
            },
            decoration: InputDecoration(),
          )
        ],
      ),
    );
  }

  Widget passwordText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Column(
        children: [
          Text("password"),
          TextFormField(
            controller: upassword,
            // validator: (value) {
            //   if (value.isEmpty) {
            //     return "Passord cannot be empty";
            //   }
            //   if (value.length <= 2) {
            //     return "Lengtrh";
            //   }
            //   // check for unique uname
            //   return null;
            // },
            obscureText: vis,
            decoration: InputDecoration(
                errorText: validate ? null : errText,
                suffixIcon: IconButton(
                    icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        vis = !vis;
                      });
                    }),
                helperText: "Password should be grater"),
          )
        ],
      ),
    );
  }
}
