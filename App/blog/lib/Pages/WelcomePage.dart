import 'package:blog/Pages/SignUpPage.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> animation; //offset is the x y of the screen
  AnimationController _animationController2;
  Animation<Offset> animation2;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));

    animation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.bounceOut));
    _animationController2 = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));

    animation2 = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
        parent: _animationController2, curve: Curves.bounceOut));
    _animationController.forward();
    _animationController2.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _animationController2.dispose();
  }

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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              SlideTransition(
                position: animation,
                child: Text(
                  "Somith",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SlideTransition(
                position: animation,
                child: Text(
                  "Great stories for great people",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 38,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              boxContainer("assets/google.png", "Sign up with Google", null),
              SizedBox(
                height: 20,
              ),
              boxContainer(
                  "assets/facebook1.png", "Sign up with Facebook", null),
              SizedBox(
                height: 20,
              ),
              boxContainer(
                  "assets/email2.png", "Sign up with Email", onEmailClick),
              SlideTransition(
                position: animation2,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 17,
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  onEmailClick() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUpPAge()));
  }

  Widget boxContainer(String path, String text, onclick) {
    return SlideTransition(
      position: animation2,
      child: InkWell(
        onTap: onclick,
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width - 140,
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                children: [
                  Image.asset(
                    path,
                    height: 40,
                    width: 40,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
