
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

  Future<dynamic> post(String url,Map<String,dynamic>mp)async{
    url = formatter(url);
    var response = await http.post(Uri.parse(url),headers: mp);
    if(response.statusCode == 200 || response.statusCode==201){
      log.i(response.body);
      return response;
    }
    // incase of err
    log.i(response.body);
  }


  String formatter(url) => baseurl + url;
}
