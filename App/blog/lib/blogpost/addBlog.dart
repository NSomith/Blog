import 'dart:convert';

import 'package:blog/Models/addBlogModel.dart';
import 'package:blog/Network/networkHandler.dart';
import 'package:blog/Pages/HomePage.dart';
import 'package:blog/customWidget/overlay.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBlog extends StatefulWidget {
  AddBlog({Key key}) : super(key: key);

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();
  ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;
  IconData iconphoto = Icons.image;
  NetworkHandler networkHandler = NetworkHandler();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            FlatButton(
              onPressed: () {
                if (_imageFile.path != null &&
                    _globalkey.currentState.validate()) {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => OverlayScreen(
                            imagefile: _imageFile,
                            title: _title.toString(),
                          ));
                }
              },
              child: Text(
                "Preview",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            )
          ]),
      body: Form(
        key: _globalkey, //will trigger the validation part in text
        child: ListView(
          children: [titleTextField(), bodyTextField(), addButton()],
        ),
      ),
    );
  }

  Widget addButton() {
    return InkWell(
      onTap: () async {
        AddBlogModel addblog =
            AddBlogModel(body: _body.text, title: _title.text);
        if (_imageFile != null && _globalkey.currentState.validate()) {
          var response =
              await networkHandler.post("/blogpost/add", addblog.toJson());
          print(response.body);
          if (response.statusCode == 200 || response.statusCode == 201) {
            String id = json.decode(response.body)['data'];
            var imagesrc = networkHandler.patchImage(
                "/blogpost/add/coverimage/${id}", _imageFile.path);
            print(imagesrc);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
          }
        }
      },
      child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.teal),
          child: Center(
              child: Text(
            "Add Blog",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ))),
    );
  }

  Widget titleTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: TextFormField(
        controller: _title,
        validator: (value) {
          if (value.isEmpty) {
            return "Title can't be empty";
          } else if (value.length > 100) {
            return "Title length should be <=100";
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          labelText: "Add Image and Title",
          prefixIcon: IconButton(
            icon: Icon(
              iconphoto,
              color: Colors.teal,
            ),
            onPressed: takeCoverPhoto,
          ),
        ),
        maxLength: 100,
        maxLines: null,
      ),
    );
  }

  void takeCoverPhoto() async {
    final coverPhoto = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = coverPhoto;
      iconphoto = Icons.check_box;
    });
  }

  Widget bodyTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
        controller: _body,
        validator: (value) {
          if (value.isEmpty) {
            return "Body can't be empty";
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          labelText: "Provide Body Your Blog",
        ),
        maxLines: null,
      ),
    );
  }
}
