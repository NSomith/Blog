import 'package:flutter/material.dart';

class SignUpPAge extends StatefulWidget {
  SignUpPAge({Key key}) : super(key: key);

  @override
  _SignUpPAgeState createState() => _SignUpPAgeState();
}

class _SignUpPAgeState extends State<SignUpPAge> {
  bool vis = true;
  final globalKey = GlobalKey<FormState>();

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
              Text("Sing with email"),
              SizedBox(
                height: 20,
              ),
              usernameText("Name"),
              emailText("text"),
              passwordText("ad"),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  if(globalKey.currentState.validate()){
                    // sen the data to rest server
                    print("valid");
                  }
                },
                child: Container(
                  height: 50,
                  width: 140,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text("Sign up")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget usernameText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Column(
        children: [
          Text(text),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return "Username cannot be empty";
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

  Widget emailText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Column(
        children: [
          Text(text),
          TextFormField(
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

  Widget passwordText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Column(
        children: [
          Text(text),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return "Passord cannot be empty";
              }
              if (value.length <= 2) {
                return "Lengtrh";
              }
              // check for unique uname
              return null;
            },
            obscureText: vis,
            decoration: InputDecoration(
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
