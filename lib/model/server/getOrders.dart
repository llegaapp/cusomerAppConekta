import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/model/server/getBasket.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fooddelivery/model/utils.dart';

getOrders(String uid, Function(List<OrdersData>, String) callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{}';

    dprint('body: $body');
    var url = "${serverPath}getOrders";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint("getOrders");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        Response ret = Response.fromJson(jsonResult);
        callback(ret.orders, ret.currency);
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
  String currency;
  List<OrdersData> orders;
  Response({this.error, this.orders, this.currency});
  factory Response.fromJson(Map<String, dynamic> json){
    var _order;
    if (json['data'] != null){
      var items = json['data'];
      var t = items.map((f)=> OrdersData.fromJson(f)).toList();
      _order = t.cast<OrdersData>().toList();
    }
    return Response(
      error: json['error'].toString(),
      currency: json['currency'].toString(),
      orders: _order,
    );
  }
}

class OrdersData {
  String orderid;
  String date;
  String status;
  String statusName;
  double total;
  String restaurant; 
  String ticketCode;
  String name;
  String image;
  String curbsidePickup;
  String arrived;
  String tax;
  String fee;
  String address;
  String send;
  String hint;
  double couponTotal;
  List<OrderTimes> ordertimes;
  List<OrderDetailsData> orderdetails;
  
  OrdersData({this.orderid, this.date, this.status, this.total, this.restaurant,this.ticketCode, this.name, this.image, this.statusName,
    this.ordertimes, this.curbsidePickup, this.arrived, this.tax, this.fee, this.address, this.send, this.hint, this.couponTotal, this.orderdetails});
  factory OrdersData.fromJson(Map<String, dynamic> json) {
    var _ordertimes;
    var _orderdetails;
    if (json['ordertimes'] != null){
      var items = json['ordertimes'];
      var t = items.map((f)=> OrderTimes.fromJson(f)).toList();
      _ordertimes = t.cast<OrderTimes>().toList();
    }

    if (json['orderdetails'] != null){
      var items = json['orderdetails'];
      var t = items.map((f)=> OrderDetailsData.fromJson(f)).toList();
      _orderdetails = t.cast<OrderDetailsData>().toList();
    }

    return OrdersData(
        orderid : json['orderid'].toString(),
        date: json['date'].toString(),
        status: json['status'].toString(),
        statusName: json['statusName'].toString(),
        total: toDouble(json['total'].toString()),
        restaurant: json['restaurant'].toString(),
        ticketCode: json['ticketCode'].toString(),
        name: json['name'].toString(),
        image: json['image'].toString(),
        ordertimes: _ordertimes,
        orderdetails: _orderdetails,
        curbsidePickup: (json['curbsidePickup'] != null) ? json['curbsidePickup'].toString() : "false",
        arrived: (json['arrived'] != null) ? json['arrived'].toString() : "false",
        tax: json['tax'].toString(),
        fee: json['fee'].toString(),
        address: json['address'].toString(),
        send: json['send'].toString(),
        hint: json['hint'].toString(),
        couponTotal: toDouble(json['couponTotal'].toString()),
    );
  }
}

class OrderTimes {
  String createdAt;
  int status;
  String driver;
  String comment;
  OrderTimes({this.createdAt, this.status, this.driver, this.comment});
  factory OrderTimes.fromJson(Map<String, dynamic> json) {
    return OrderTimes(
      createdAt : json['created_at'].toString(),
      status: toInt(json['status'].toString()),
      driver: json['driver'].toString(),
      comment: json['comment'].toString(),
    );
  }
}

