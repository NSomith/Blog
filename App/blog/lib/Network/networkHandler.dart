
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  String baseurl = "https://frozen-brook-01777.herokuapp.com";
  var log = Logger();
  Future<dynamic> get(String url) async {
    url = formatter(url);
    var response = await http.get(Uri.parse(url));
    log.d(response.body);
  }

  String formatter(url) => baseurl + url;
}
