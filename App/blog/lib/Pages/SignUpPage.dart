import 'package:blog/Network/networkHandler.dart';
import 'package:flutter/material.dart';

class SignUpPAge extends StatefulWidget {
  SignUpPAge({Key key}) : super(key: key);

  @override
  _SignUpPAgeState createState() => _SignUpPAgeState();
}

class _SignUpPAgeState extends State<SignUpPAge> {
  bool vis = true;
  final globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController uname = TextEditingController();
  TextEditingController uemail = TextEditingController();
  TextEditingController upassword = TextEditingController();

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
              Text("Sing with email"),
              SizedBox(
                height: 20,
              ),
              usernameText(),
              emailText(),
              passwordText(),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  await checkUser();
                  if (globalKey.currentState.validate() && validate) {
                    // sen the data to rest server
                    Map<String, dynamic> data = {
                      "username": uname.text,
                      "email": uemail.text,
                      "password": upassword.text
                    };
                    // networkHandler.get("");
                    await networkHandler.post("/user/register", data);
                    setState(() {
                      circular = false;
                    });
                  } else {
                    setState(() {
                      circular = false;
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
                        child: Center(child: Text("Sign up")),
                      ),
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
              errorText: validate?null:errText,
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
