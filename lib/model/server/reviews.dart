import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

reviewsFoodAdd(String uid, String food, String rate, String desc,
    Function(String,String) callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"food": "$food", "rate": "$rate", "desc": "$desc"}';
    var url = "${serverPath}foodReviewsAdd";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        Response ret = Response.fromJson(jsonResult);
        callback(ret.date,ret.idreview);
      }else
        callbackError("error=${jsonResult["error"]}");
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

deleteFoodReviews(String uid, String idreview,
    Function(String) callback, Function(String) callbackError) async {

   //callback(idreview);
   try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"idreview": "$idreview"}';
    var url = "${serverPath}foodReviewsDelete";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        //Response ret = Response.fromJson(jsonResult);
        callback(idreview);
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
  String date;
  String idreview;
  Response({this.error, this.date,this.idreview});
  factory Response.fromJson(Map<String, dynamic> json){
    return Response(
      error: json['error'].toString(),
      date: json['date'].toString(),
      idreview: json['idreview'].toString(),
    );
  }
}

reviewsRestaurantAdd(String uid, String restaurant, String rate, String desc,
    Function(String, String) callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"restaurant": "$restaurant", "rate": "$rate", "desc": "$desc"}';
    var url = "${serverPath}restaurantReviewsAdd";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        Response ret = Response.fromJson(jsonResult);
        callback(ret.date, ret.idreview);
      }else
        callbackError("error=${jsonResult["error"]}");
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

deleteReviews(String uid, String idreview,
    Function(String) callback, Function(String) callbackError) async {

   //callback(idreview);
   try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"idreview": "$idreview"}';
    var url = "${serverPath}restaurantReviewsDelete";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        //Response ret = Response.fromJson(jsonResult);
        callback(idreview);
      }else
        callbackError("error=${jsonResult["error"]}");
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}
