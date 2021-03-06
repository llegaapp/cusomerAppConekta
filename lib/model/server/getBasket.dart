import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/model/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

getBasket(String uid, Function(OrderData, List<OrderDetailsData>, String, double, String, String) callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{}';
    var url = "${serverPath}getBasket";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');
    dprint('Response orderdetails: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        Response ret = Response.fromJson(jsonResult);
        callback(ret.order, ret.orderdetails, ret.currency, ret.defaultTax, ret.fee, ret.percent);
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
  double defaultTax;
  OrderData order;
  List<OrderDetailsData> orderdetails;
  String fee;
  String percent;

  Response({this.error, this.order, this.orderdetails, this.currency, this.defaultTax, this.fee, this.percent});
  factory Response.fromJson(Map<String, dynamic> json){
    var _order;
    if (json['order'] != null)
      _order = OrderData.fromJson(json['order']);
    var _orderdetails;
    if (json['orderdetails'] != null) {
      var items = json['orderdetails'];
      var t = items.map((f)=> OrderDetailsData.fromJson(f)).toList();
      _orderdetails = t.cast<OrderDetailsData>().toList();
    }
    return Response(
      error: json['error'].toString(),
      defaultTax: toDouble(json['default_tax'].toString()),
      currency: json['currency'].toString(),
      order: _order,
      orderdetails: _orderdetails,
      fee: json['fee'].toString(),
      percent: json['percent'].toString(),
    );
  }
}

class OrderData {
  String id;
  String user;
  String driver;
  String status;
  String pstatus;
  String tax;
  String hint;
  String active;
  String restaurant;
  String ticketCode;
  String method;
  String total;
  String fee;

  OrderData({this.id, this.user, this.driver, this.status, this.pstatus, this.tax,
    this.hint, this.active, this.restaurant, this.ticketCode, this.method, this.total, this.fee});
  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id : json['id'].toString(),
      user: json['user'].toString(),
      driver: json['driver'].toString(),
      status: json['status'].toString(),
      pstatus: json['pstatus'].toString(),
      tax: json['tax'].toString(),
      hint: json['hint'].toString(),
      active: json['active'].toString(),
      restaurant: json['restaurant'].toString(),
      ticketCode: json['ticketCode'].toString(),
      method: json['method'].toString(),
      total: json['total'].toString(),
      fee: json['fee'].toString(),
    );
  }
}


class OrderDetailsData {
  String id;
  String hashid;
  String order;
  String food;
  int count;
  double foodprice;
  double foodprecioUnit;
  double foodtaxFood;
  double foodtax;
  String extras;
  String extrascount;
  String extrasprice;
  String extrasprecioUnit;
  String extrastaxFood;
  String extrastax;
  String foodid;
  String extrasid;
  String image;
  String category;

  OrderDetailsData({this.id, this.hashid, this.order, this.food, this.count, this.foodprice, this.foodprecioUnit,this.foodtaxFood,this.foodtax, this.extras, this.extrascount,
    this.extrasprice,
    this.extrasprecioUnit,
    this.extrastaxFood,
    this.extrastax,
    this.foodid, this.extrasid, this.image, this.category});
  factory OrderDetailsData.fromJson(Map<String, dynamic> json) {
    //print('OrderDetailsData json');
    //print(json);
    return OrderDetailsData(
      id : json['id'].toString(),
      hashid : json['hashid'].toString(),
      order : json['order'].toString(),
      food : json['food'].toString(),
      count : toInt(json['count'].toString()),
      foodprice : toDouble(json['foodprice'].toString()),
      foodprecioUnit : toDouble(json['foodprecioUnit'].toString()),
      foodtaxFood : toDouble(json['foodtaxFood'].toString()),
      foodtax : toDouble(json['foodtax'].toString()),
      extras : json['extras'].toString(),
      extrascount : json['extrascount'].toString(),
      extrasprice : json['extrasprice'].toString(),
      extrasprecioUnit : json['extrasprecioUnit'].toString(),
      extrastaxFood : json['extrastaxFood'].toString(),
      extrastax : json['extrastax'].toString(),
      foodid : json['foodid'].toString(),
      extrasid : json['extrasid'].toString(),
      image : json['image'].toString(),
      category : json['category'].toString(),
    );
  }
}


