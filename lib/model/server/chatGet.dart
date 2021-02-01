import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fooddelivery/model/utils.dart';

chatGet(String uid, Function(List<ChatMessages>) callback, Function(String) callbackError) async {

    try {
      var url = "${serverPath}getChatMessages";
      var response = await http.get(url, headers: {
        'Content-type': 'application/json',
        'Accept': "application/json",
          'Authorization': 'Bearer $uid',
      }).timeout(const Duration(seconds: 10));

      dprint("api/getChatMessages");
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        if (jsonResult['error'] == '0') {
          Response ret = Response.fromJson(jsonResult);
          callback(ret.messages);
        }else
          callbackError("error=${jsonResult['error']}");
      } else
        callbackError("statusCode=${response.statusCode}");
    } catch (ex) {
      callbackError(ex.toString());
    }
}

class Response {
  String error;
  List<ChatMessages> messages;
  Response({this.error, this.messages});
  factory Response.fromJson(Map<String, dynamic> json){
    var m;
    if (json['messages'] != null) {
      var items = json['messages'];
      var t = items.map((f)=> ChatMessages.fromJson(f)).toList();
      m = t.cast<ChatMessages>().toList();
    }
    return Response(
      error: json['error'].toString(),
      messages: m,
    );
  }
}

class ChatMessages {
  int id;
  String date;
  String text;
  String author;
  String delivered;
  String read;

  ChatMessages({this.id, this.date, this.text, this.author, this.delivered, this.read});
  factory ChatMessages.fromJson(Map<String, dynamic> json){
    return ChatMessages(
      id: toInt(json['id'].toString()),
      date: json['created_at'].toString(),
      text: json['text'].toString(),
      author: json['author'].toString(),
      delivered: json['delivered'].toString(),
      read: json['read'].toString(),
    );
  }
}
