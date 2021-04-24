import 'package:blog/Network/networkHandler.dart';
import 'package:blog/Profile/CreateProfile.dart';
import 'package:blog/Profile/MainProfile.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final networkHandler = NetworkHandler();
  Widget page = CircularProgressIndicator();
  @override
  void initState() {
    super.initState();
    checkProfile();
  }

  void checkProfile()async{
     var response = await networkHandler.get("/profile/checkProfile");
    if(response['status']){
      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MainProfile()));
      setState(() {
        page = MainProfile();
      });
    }else{
      setState(() {
        page = button();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        
        child: page,
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
