import 'package:blog/Models/profileModel.dart';
import 'package:blog/Network/networkHandler.dart';
import 'package:flutter/material.dart';

class MainProfile extends StatefulWidget {
  MainProfile({Key key}) : super(key: key);

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circle = true;
  NetworkHandler networkHandler = NetworkHandler();
  ProfileModel profileModel = ProfileModel();
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var response = await networkHandler.get("/profile/getdata");
    setState(() {
      profileModel = ProfileModel.fromJson(response['data']);
      // print(profileModel);
      circle = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {},
        //   color: Colors.black,
        // ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
            color: Colors.black,
          ),
        ],
      ),
      body: circle
          ? CircularProgressIndicator()
          : ListView(
              children: [
                head(),
                Divider(
                  thickness: 0.9,
                ),
                otherDetails("about", profileModel.about),
                otherDetails("name", profileModel.name),
                otherDetails("Profession",profileModel.profession),
                otherDetails("Dob",profileModel.DOB)
              ],
            ),
    );
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkHandler().getImage(profileModel.username),
          ),
          Text(profileModel.username),
          SizedBox(
            height: 10,
          ),
          Text(profileModel.titleline),
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${label}:"),
        SizedBox(
          height: 3,
        ),
        Text(value),
      ],
    );
  }
}
