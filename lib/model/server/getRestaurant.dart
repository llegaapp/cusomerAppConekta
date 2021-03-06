import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantData {

  var _currentId = "";
  ResponseRestaurant _currentRet;

  get(String id, Function(ResponseRestaurant) callback,
      Function(String) callbackError) async {

    if (_currentId == id)
      return callback(_currentRet);

    try {
      var url = "${serverPath}getRestaurant?restaurant=$id";
      var response = await http.get(url, headers: {
        'Content-type': 'application/json',
        'Accept': "application/json",
      }).timeout(const Duration(seconds: 30));

      dprint("api/getRestaurant");
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        if (jsonResult['error'] == '0') {
          ResponseRestaurant ret = ResponseRestaurant.fromJson(jsonResult);
          _currentId = id;
          _currentRet = ret;
          callback(ret);
        } else
          callbackError("error=${jsonResult['error']}");
      } else
        callbackError("statusCode=${response.statusCode}");
    } catch (ex) {
      callbackError(ex.toString());
    }
  }
}

class ResponseRestaurant {
  String error;
  String currency;
  List<DishesData> foods;
  Restaurants restaurant;
  List<CategoriesData> categories;
  List<RestaurantsReviewsData> restaurantsreviews;
  ResponseRestaurant({this.error, this.foods, this.currency, this.restaurant, this.categories, this.restaurantsreviews});
  factory ResponseRestaurant.fromJson(Map<String, dynamic> json){
    var m;
    //print('json_________:');
    //print(json);
    if (json['foods'] != null) {
      print('foods:');
      print(json['foods']);
      var items = json['foods'];
      var t = items.map((f)=> DishesData.fromJson(f)).toList();
      m = t.cast<DishesData>().toList();
    }
    var _categories;
    if (json['categories'] != null) {
      var items = json['categories'];
      var t = items.map((f)=> CategoriesData.fromJson(f)).toList();
      _categories = t.cast<CategoriesData>().toList();
    }
    var _restaurantsreviews;
    if (json['restaurantsreviews'] != null) {
      var items = json['restaurantsreviews'];
      var t = items.map((f)=> RestaurantsReviewsData.fromJson(f)).toList();
      _restaurantsreviews = t.cast<RestaurantsReviewsData>().toList();
    }
    var _restaurant;
    if (json['restaurant'] != null)
      _restaurant = Restaurants.fromJson(json['restaurant']);
    return ResponseRestaurant(
        error: json['error'].toString(),
        currency: json['currency'].toString(),
        foods: m,
        restaurant: _restaurant,
        categories: _categories,
        restaurantsreviews: _restaurantsreviews,
    );
  }
}

