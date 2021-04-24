import 'package:blog/Network/networkHandler.dart';
import 'package:blog/Pages/WelcomePage.dart';
import 'package:blog/Screen/HomeScreen.dart';
import 'package:blog/Screen/ProfileScreen.dart';
import 'package:blog/blogpost/addBlog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currState = 0;
  List<Widget> widlist = [HomeScreen(), ProfileScreen()];
  List<String> titlesc = ["Home Page", "Profile Page"];
  final storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  String username = "User";
  Widget profilePhoto = Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50), color: Colors.black),
  );

  @override
  void initState() {
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/profile/checkProfile");
    setState(() {
      username = response['username'];
    });
    if (response['status']) {
      profilePhoto = CircleAvatar(
        radius: 50,
        backgroundImage: NetworkHandler().getImage(response['username']),
      );
    } else {
      profilePhoto = Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.black),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  child: Column(
                children: [
                  profilePhoto,
                  SizedBox(
                    height: 10,
                  ),
                  Text(username)
                ],
              )),
              ListTile(
                title: Text("post"),
              ),
              ListTile(
                title: Text("Logout"),
                trailing: Icon(Icons.logout),
                onTap: () {
                  logout();
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(titlesc[currState]),
          centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.notifications), onPressed: null)
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddBlog()));
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 12,
          child: Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: currState == 0 ? Colors.blue : Colors.black45,
                    ),
                    onPressed: () {
                      setState(() {
                        currState = 0;
                      });
                    },
                    iconSize: 30,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.person,
                      color: currState == 1 ? Colors.blue : Colors.black45,
                    ),
                    onPressed: () {
                      setState(() {
                        currState = 1;
                      });
                    },
                    iconSize: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: widlist[currState]);
  }

  logout() async {
    await storage.delete(key: "token");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => WelcomePage()),
        (route) => false);
  }
}
