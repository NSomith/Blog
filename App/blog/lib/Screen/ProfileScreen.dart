import 'package:blog/Profile/CreateProfile.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: button()),
      ),
    );
  }

  Widget button() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Tap to add profile",
          style: TextStyle(),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateProfile()));
          },
          child: Container(
            height: 40,
            width: 70,
            decoration: BoxDecoration(
                color: Colors.black45, borderRadius: BorderRadius.circular(20)),
            child: Text(
              "Add Profile",
              textAlign: TextAlign.center,
            ),
            alignment: Alignment.center,
          ),
        )
      ],
    );
  }
}
