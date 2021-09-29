import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Networking{

  Future networkHelper({userText}) async {
    var url = Uri.parse('https://api.funtranslations.com/translate/minion.json?text=$userText');
    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      return data['contents']['translated'];
    }else{
      print('problem: ');
      print(response.statusCode);
    }

  }


}