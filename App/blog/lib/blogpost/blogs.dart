import 'package:blog/Models/ListModel.dart';
import 'package:blog/Models/addBlogModel.dart';
import 'package:blog/Network/networkHandler.dart';
import 'package:blog/blogpost/blogDetail.dart';
import 'package:blog/customWidget/blogCardData.dart';
import 'package:flutter/material.dart';

class Blog extends StatefulWidget {
  Blog({Key key, this.url}) : super(key: key);
  final String url;

  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  NetworkHandler networkHandler = NetworkHandler();
  ListModel listModel = ListModel();
  List<AddBlogModel> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var response = await networkHandler.get(widget.url);
    listModel = ListModel.fromJson(response);
    setState(() {
      data = listModel.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? Center(
            child: Text("No data present"),
          )
        : Column(
            children: data
                .map((item) => InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BlogDetails(
                              addBlogModel: item,
                              networkHandler: networkHandler,
                            )));
                      },
                      child: BlogCard(
                        addBlogModel: item,
                        networkHandler: networkHandler,
                      ),
                    ))
                .toList());
  }
}
