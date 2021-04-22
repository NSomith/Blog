import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  // String baseurl = "https://frozen-brook-01777.herokuapp.com";
  String baseurl = "http://192.168.1.8:8000";
  var log = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();
  Future<dynamic> get(String url) async {
    url = formatter(url);
    String token = await storage.read(key: "token");
    var response = await http
        .get(Uri.parse(url), headers: {"Authorization": "Bearer ${token}"});
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    }
    // log.d(response.body);
  }

  Future<http.Response> post(String url, Map<String, dynamic> mp) async {
    url = formatter(url);
    String token = await storage.read(key: "token");
    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}"
        },
        body: json.encode(mp)); //encode converts to json string
    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   log.i(response.body);
    //   return response;
    // }
    // // incase of err
    // log.i(response.body);

    return response;
  }

  Future<http.StreamedResponse> patchImage(String url, String filepath) async{
    url = formatter(url);
    String token = await storage.read(key: "token");
    var request = http.MultipartRequest('PATCH',Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      "Content-Type": "multipart/from-data",
          "Authorization": "Bearer ${token}"
    });
    var response = request.send();
    return response;
  }

  String formatter(url) => baseurl + url;
}
