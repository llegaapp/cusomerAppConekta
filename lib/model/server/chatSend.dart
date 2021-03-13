import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/model/server/chatGet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

chatSend(String uid, String text, Function(List<ChatMessages>) callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"text": ${json.encode(text)}}';

    dprint('body: $body');
    var url = "${serverPath}chatNewMessage";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint("chatNewMessage");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        Response ret = Response.fromJson(jsonResult);
        callback(ret.messages);
      }else
        callbackError("error=${jsonResult["error"]}");
    }else
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
