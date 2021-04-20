import 'package:blog/Pages/HomePage.dart';
import 'package:blog/Pages/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = WelcomePage();
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    setState(() {
       checklogin();
    });
  }

   checklogin() async {
    String token = await storage.read(key: "token");
    if (token != null) {
      setState(() {
      page = HomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: page,
    );
  }
}
