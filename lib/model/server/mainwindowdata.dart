import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/model/pref.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fooddelivery/model/utils.dart';

class MainWindowDataAPI {

  MainWindowData _data;

  get(Function(MainWindowData) callback, Function(String) callbackError) async {

    if (_data != null) {
      return callback(_data);
    }

    try {
      var url = "${serverPath}getMain";
      var response = await http.get(url, headers: {
        'Content-type': 'application/json',
        'Accept': "application/json",
      }).timeout(const Duration(seconds: 30));

      dprint("api/getRestaurants");
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        MainWindowData ret = MainWindowData.fromJson(jsonResult);
        _data = ret;
        callback(ret);
      } else
        callbackError("statusCode=${response.statusCode}");
    } on Exception catch (ex) {
      callbackError(ex.toString());
    }
  }
}

class MainWindowData {
  bool success;
  List<Restaurants> restaurants;
  List<Restaurants> toprestaurants;
  List<CategoriesData> categories;
  List<DishesData> favorites;
  List<DishesData> topFoods;
  List<RestaurantsReviewsData> restaurantsreviews;
  List<Coupon> coupons;
  PaymentsMethods payments;
  String currency;
  double defaultTax;
  AppSettings settings;
  MainWindowData({this.success, this.restaurants, this.categories, this.favorites, this.restaurantsreviews, this.currency,
    this.defaultTax, this.payments, this.settings, this.topFoods, this.toprestaurants, this.coupons});
  factory MainWindowData.fromJson(Map<String, dynamic> json){
    var _restaurants;
    if (json['restaurants'] != null) {
      var items = json['restaurants'];
      var t = items.map((f)=> Restaurants.fromJson(f)).toList();
      _restaurants = t.cast<Restaurants>().toList();
    }
    var _toprestaurants;
    if (json['toprestaurants'] != null) {
      var items = json['toprestaurants'];
      var t = items.map((f)=> Restaurants.fromJson(f)).toList();
      _toprestaurants = t.cast<Restaurants>().toList();
    }
    var _categories;
    if (json['categories'] != null) {
      var items = json['categories'];
      var t = items.map((f)=> CategoriesData.fromJson(f)).toList();
      _categories = t.cast<CategoriesData>().toList();
    }
    var _favorites;
    if (json['favorites'] != null) {
      var items = json['favorites'];
      var t = items.map((f)=> DishesData.fromJson(f)).toList();
      _favorites = t.cast<DishesData>().toList();
    }
    var _top;
    if (json['top_foods'] != null) {
      var items = json['top_foods'];
      var t = items.map((f)=> DishesData.fromJson(f)).toList();
      _top = t.cast<DishesData>().toList();
    }
    var _restaurantsreviews;
    if (json['restaurantsreviews'] != null) {
      var items = json['restaurantsreviews'];
      var t = items.map((f)=> RestaurantsReviewsData.fromJson(f)).toList();
      _restaurantsreviews = t.cast<RestaurantsReviewsData>().toList();
    }
    var _coupons;
    if (json['coupons'] != null) {
      var items = json['coupons'];
      var t = items.map((f)=> Coupon.fromJson(f)).toList();
      _coupons = t.cast<Coupon>().toList();
    }
    var _payments = PaymentsMethods.fromJson(json['payments']);
    var _settings = AppSettings.fromJson(json['settings']);
    return MainWindowData(
      currency: json['currency'].toString(),
      success: toBool(json['success'].toString()),
      restaurants: _restaurants,
      toprestaurants: _toprestaurants,
      categories: _categories,
      favorites: _favorites,
      topFoods: _top,
      restaurantsreviews: _restaurantsreviews,
      defaultTax: toDouble(json['default_tax'].toString()),
      payments: _payments,
      settings: _settings,
      coupons: _coupons,
    );
  }
}

class Coupon{
  String id;
  String name;
  String dateStart;
  String dateEnd;
  double discount;
  String inpercents;
  double amount;

  String allRestaurants;
  String allCategory;
  String allFoods;
  String enviogratis;

  List<String> restaurantsList;
  List<String> categoryList;
  List<String> foodsList;

  Coupon({this.id, this.name, this.discount, this.inpercents, this.amount,
    this.allRestaurants, this.allCategory, this.allFoods, this.enviogratis,
    this.restaurantsList, this.categoryList, this.foodsList, this.dateStart, this.dateEnd});
  factory Coupon.fromJson(Map<String, dynamic> jsons) {

    var _discount = 0.0;
    var _amount = 0.0;
    try{
      _discount = double.parse(jsons['discount']);
      _amount = double.parse(jsons['amount']);
    }catch(ex){
      dprint (ex.toString());
    }

    return Coupon(
      id: jsons['id'].toString(),
      name: jsons['name'].toString(),
      dateStart: jsons['dateStart'].toString(),
      dateEnd: jsons['dateEnd'].toString(),
      discount: _discount,
      amount: _amount,
      inpercents: jsons['inpercents'].toString(),
      allRestaurants : jsons['allRestaurants'].toString(),
      allCategory : jsons['allCategory'].toString(),
      allFoods : jsons['allFoods'].toString(),
      enviogratis : jsons['enviogratis'].toString(),
      restaurantsList : jsons['restaurantsList'].toString().split(","),
      categoryList : jsons['categoryList'].toString().split(","),
      foodsList : jsons['foodsList'].toString().split(","),
    );
  }
}

class Restaurants {
  String id;
  String name;
  String address;
  String published;
  double lat;
  double lng;
  String image;
  String phone;
  String desc;
  String mobilephone;

  String openTimeMonday;
  String closeTimeMonday;
  String openTimeTuesday;
  String closeTimeTuesday;
  String openTimeWednesday;
  String closeTimeWednesday;
  String openTimeThursday;
  String closeTimeThursday;
  String openTimeFriday;
  String closeTimeFriday;
  String openTimeSaturday;
  String closeTimeSaturday;
  String openTimeSunday;
  String closeTimeSunday;
  //
  int area;
  double distance;
  bool areaShowOnMap;
  bool onlineActive;

  Restaurants({this.id, this.name, this.address, this.published, this.lat, this.lng, this.image, this.phone, this.mobilephone, this.desc,
    this.openTimeMonday, this.closeTimeMonday,
    this.openTimeTuesday, this.closeTimeTuesday,
    this.openTimeWednesday, this.closeTimeWednesday,
    this.openTimeThursday, this.closeTimeThursday,
    this.openTimeFriday, this.closeTimeFriday,
    this.openTimeSaturday, this.closeTimeSaturday,
    this.openTimeSunday, this.closeTimeSunday, this.area, this.distance = 1, this.areaShowOnMap = false, this.onlineActive = true
  });
  factory Restaurants.fromJson(Map<String, dynamic> json) {

    var _lat = 0.0;
    var _lng = 0.0;
    try{
      _lat = double.parse(json['lat']);
      _lng = double.parse(json['lng']);
    }catch(ex){
      dprint (ex.toString());
    }

    return Restaurants(
      id : json['id'].toString(),
      name: json['name'].toString(),
      desc: json['desc'].toString(),
      address: json['address'].toString(),
      published : json['published'].toString(),
      lat: _lat,
      lng: _lng,
      image: "$serverImages${json['image'].toString()}",
      phone: json['phone'].toString(),
      mobilephone: json['mobilephone'].toString(),
      openTimeMonday: json['openTimeMonday'].toString(),
      closeTimeMonday: json['closeTimeMonday'].toString(),
      openTimeTuesday: json['openTimeTuesday'].toString(),
      closeTimeTuesday: json['closeTimeTuesday'].toString(),
      openTimeWednesday: json['openTimeWednesday'].toString(),
      closeTimeWednesday: json['closeTimeWednesday'].toString(),
      openTimeThursday: json['openTimeThursday'].toString(),
      closeTimeThursday: json['closeTimeThursday'].toString(),
      openTimeFriday: json['openTimeFriday'].toString(),
      closeTimeFriday: json['closeTimeFriday'].toString(),
      openTimeSaturday: json['openTimeSaturday'].toString(),
      closeTimeSaturday: json['closeTimeSaturday'].toString(),
      openTimeSunday: json['openTimeSunday'].toString(),
      closeTimeSunday: json['closeTimeSunday'].toString(),
      area: toInt(json['area'].toString()),
      onlineActive: json["active"] == 1 ? true : false,

    );
  }

  int compareTo(Restaurants b){
    if (distance > b.distance)
      return 1;
    if (distance < b.distance)
      return -1;
    return 0;
  }

}

class CategoriesData {
  String id;
  String name;
  String image;
  String visible;
  String parent;
  CategoriesData({this.id, this.name, this.visible, this.image, this.parent});
  factory CategoriesData.fromJson(Map<String, dynamic> json) {
    return CategoriesData(
      id : json['id'].toString(),
      name: json['name'].toString(),
      visible: json['visible'].toString(),
      image: "$serverImages${json['image'].toString()}",
      parent: json['parent'].toString(),
    );
  }
}

class Nutritions {
  String desc;
  String name;
  Nutritions({this.name, this.desc});
  factory Nutritions.fromJson(Map<String, dynamic> json) {
    return Nutritions(
      name: json['name'].toString(),
      desc: json['desc'].toString(),
    );
  }
}

class Extras {
  String id;
  String desc;
  String name;
  String image;
  double price;
  double precioUnit;
  double taxFood;
  double tax;

  bool select;
  Extras({this.id, this.name, this.desc, this.price, this.precioUnit, this.taxFood,this.tax, this.image, this.select = false});

  factory Extras.fromJson(Map<String, dynamic> json) {
    print('extrassssssssssss   json');
    print(json);
    return Extras(
      id: json['id'].toString(),
      name: json['name'].toString(),
      desc: json['desc'].toString(),
      price: toDouble(json['price'].toString()),
      precioUnit: toDouble(json['precioUnit'].toString()),
      taxFood: toDouble(json['taxFood'].toString()),
      tax: toDouble(json['tax'].toString()),
      image: json['image'].toString(),
    );
  }
}

class FoodsReviews {
  String id;
  String createdAt;
  String desc;
  String rate;
  String image;
  String userName;
  FoodsReviews({this.id, this.desc, this.createdAt, this.rate, this.image, this.userName});
  factory FoodsReviews.fromJson(Map<String, dynamic> json) {
    var _image = "$serverImages${json['image'].toString()}";
    return FoodsReviews(
      id: json['id'].toString(),
      desc: json['desc'].toString(),
      createdAt: json['created_at'].toString(),
      rate: json['rate'].toString(),
      userName: json['userName'].toString(),
      image: _image,
    );
  }
}

class DishesData {
  String id;         // FoodID
  String idDetails;  // OrderDetailsID
  String hashid;     // For use in Cart
  String name;
  String image;
  double price;
  double precioUnit;
  double taxFood;
  double tax;
  double discountprice;
  String discount;
  String desc;
  String ingredients;
  String published;
  List<Nutritions> nutritions;
  List<Extras> extras;
  List<FoodsReviews> foodsreviews;
  String restaurant;
  String restaurantName;
  String restaurantPhone;
  String restaurantMobilePhone;
  bool restaurantActive;
  String category;
  String fee;
  String percent;
  //
  bool delivered;
  int count;
  bool active;
  //
  DishesData({this.id,this.idDetails, this.hashid , this.name, this.published, this.image, this.restaurantName, this.desc, this.ingredients,
    this.nutritions, this.restaurantPhone, this.restaurantMobilePhone, this.restaurantActive, this.extras, this.foodsreviews,
    this.price,  this.precioUnit,  this.taxFood, this.tax,
    this.restaurant,
    this.category, this.fee, this.percent, this.discountprice,
    this.delivered = false, this.count = 0, this.active = true, this.discount = "",
  });
  factory DishesData.fromJson(Map<String, dynamic> json) {
    var m;
    print('-----------------------precisUnit------------------------------');
    print(json);
    if (json['nutritionsdata'] != null) {
      var items = json['nutritionsdata'];
      var t = items.map((f) => Nutritions.fromJson(f)).toList();
      m = t.cast<Nutritions>().toList();
    }
    var n;
    if (json['extrasdata'] != null) {
      var items = json['extrasdata'];
      //print('items extradataaaaaaaa');
      //print(items);
      var t = items.map((f) => Extras.fromJson(f)).toList();
      n = t.cast<Extras>().toList();
    }
    var d;
    if (json['foodsreviews'] != null) {
      var items = json['foodsreviews'];
      var t = items.map((f) => FoodsReviews.fromJson(f)).toList();
      d = t.cast<FoodsReviews>().toList();
    }
    return DishesData(
      id : json['id'].toString(),
      idDetails : json['idDetails'].toString(),
      hashid : json['hashid'].toString(),
      name: json['name'].toString(),
      published: json['published'].toString(),
      restaurant: json['restaurant'].toString(),
      restaurantName: json['restaurantName'].toString(),
      image: json['image'].toString(),
      desc : json['desc'].toString(),
      ingredients: json['ingredients'].toString(),
      nutritions: m,
      extras: n,
      foodsreviews: d,
      restaurantPhone: json['restaurantPhone'].toString(),
      restaurantMobilePhone: json['restaurantMobilePhone'].toString(),
      restaurantActive: json['restaurantActive'] == 1 ? true : false,
      active: json['available'] == 1 ? true : false,
      price: toDouble(json['price'].toString()),
      precioUnit: toDouble(json['precioUnit'].toString()),
      taxFood: toDouble(json['taxFood'].toString()),
      tax: toDouble(json['tax'].toString()),
      discountprice: toDouble(json['discountprice'].toString()),
      category: json['category'].toString(),
      fee: json['fee'].toString(),
      //percent: json['percent'],
    //   discount: (toDouble(json['discountprice'].toString()) != 0) ?
    //   "-${
    //       (
    //           (
    //               (
    //                 toDouble(json['price'].toString())-toDouble(json['discountprice'].toString())
    //               )
    //                /
    //               (
    //                 toDouble(json['price'].toString())/100
    //               )
    //           ).toStringAsFixed(2)
    //       ).toString()
    //       }%" : "",
    // );
    discount: "Oferta",
    );
  }

  from(DishesData item){
    discount = item.discount;
    image = item.image;
    name = item.name;
    fee = item.fee;
    percent = item.percent;
    id = item.id;
    idDetails = item.idDetails;
    hashid = item.hashid;
    desc = item.desc;
    restaurantName = item.restaurantName;
    restaurant = item.restaurant;
    restaurantPhone = item.restaurantPhone;
    restaurantMobilePhone = item.restaurantMobilePhone;
    restaurantActive = item.restaurantActive;
    price = item.price;
    precioUnit = item.precioUnit;
    taxFood = item.taxFood;
    tax = item.tax;
    discountprice = item.discountprice;
    ingredients = item.ingredients;
    count = item.count;
    extras = List<Extras>();
    category = item.category;
    for (var extras in item.extras)
      this.extras.add(Extras(id: extras.id, desc: extras.desc, name: extras.name, image: extras.image,
          price: extras.price,
          precioUnit: extras.precioUnit,
          taxFood: extras.taxFood,
          tax: extras.tax,
          select: extras.select ));
    //Extras({this.id, this.name, this.desc, this.price, this.precioUnit, this.taxFood,this.tax, this.image, this.select = false});
    return this;
  }

  String toJSON() {
    var t = json.encode(name);
    var t2 = json.encode(image);
    var discPrice = price;
    var precioUnita = precioUnit;
    var taxFooda = taxFood;
    var taxa = tax;
    if (discountprice != null && discountprice != 0)
      discPrice = discountprice;

    var _text = '{"food": $t, "count": "$count", "foodprice": "$discPrice","precioUnit": "$precioUnita","taxFood": "$taxFooda","tax": "$taxa", "extras": "0", '
        '"extrascount" : "0", "extrasprice": "0", "extrasprecioUnit": "0","extrastaxFood": "0","extrastax": "0", "foodid": "$id", "hashid": "$hashid", "extrasid" : "0", "image" : $t2}';
    for (var item in extras){
      if (item.select){
        var t = json.encode(item.name);
        _text = '$_text, {"food": "", "count": "0", "foodprice": "0", "extras": $t, '
            '"extrascount" : "$count", '
            '"extrasprice": "${item.price}", '
            '"extrasprecioUnit": "${item.precioUnit}", '
            '"extrastaxFood": "${item.taxFood}", '
            '"extrastax": "${item.tax}", '
            '"foodid": "$id", "hashid": "$hashid", "extrasid" : "${item.id}", '
            '"image" : ${json.encode(item.image)}}';
      }
    }
    return _text;
  }
}


class RestaurantsReviewsData {
  String id;
  String updatedAt;
  String image;
  String desc;
  String name;
  String rate;
  RestaurantsReviewsData({this.id, this.updatedAt, this.desc, this.image, this.name, this.rate});
  factory RestaurantsReviewsData.fromJson(Map<String, dynamic> json) {
    return RestaurantsReviewsData(
      id : json['id'].toString(),
      updatedAt: json['updated_at'].toString(),
      desc: json['desc'].toString(),
      name: json['name'].toString(),
      image: serverImages + json['image'].toString(),
      rate: json['rate'].toString(),
    );
  }
}

class PaymentsMethods {
  // conekta
  String conektaEnable;
  String conektaKey;
  String conektaSecretKey;

  // stripe
  String stripeEnable;
  String stripeKey;
  String stripeSecretKey;
  // razorpay
  String razEnable;
  String razKey;
  String razName;
  // cache on delivery
  String cacheEnable;
  // paypal
  String payPalEnable;
  String payPalSandBoxMode;
  String payPalClientId;
  String payPalSecret;
  // payStack
  String payStackEnable;
  String payStackKey;
  // yandex.kassa
  String yandexKassaEnable;
  String yandexKassaShopId;
  String yandexKassaClientAppKey;
  String yandexKassaSecretKey;
  // Instamojo
  String instamojoEnable;
  String instamojoSandBoxMode;
  String instamojoApiKey;
  String instamojoPrivateToken;
  // currency code
  String code;

  PaymentsMethods({this.stripeEnable, this.stripeKey, this.stripeSecretKey, this.conektaEnable,this.conektaKey,this.conektaSecretKey, this.razEnable, this.razKey, this.razName, this.cacheEnable,
    this.code, this.payPalClientId, this.payPalEnable, this.payPalSecret, this.payPalSandBoxMode,
    this.payStackEnable, this.payStackKey, this.yandexKassaEnable, this.instamojoEnable, this.yandexKassaShopId,
    this.yandexKassaClientAppKey, this.yandexKassaSecretKey, this.instamojoSandBoxMode, this.instamojoApiKey,
    this.instamojoPrivateToken
  });
  factory PaymentsMethods.fromJson(Map<String, dynamic> json) {
    return PaymentsMethods(
      // conekta

      conektaEnable : json['conektaEnable'].toString(),
      conektaKey : json['conektaKey'].toString(),
      conektaSecretKey : json['conektaSecretKey'].toString(),
     // stripe
      stripeEnable : json['StripeEnable'].toString(),
      stripeKey : json['stripeKey'].toString(),
      stripeSecretKey : json['stripeSecretKey'].toString(),
      // razorpay
      razEnable : json['razEnable'].toString(),
      razKey : json['razKey'].toString(),
      razName : json['razName'].toString(),
      // cache on delivery
      cacheEnable : json['cashEnable'].toString(),
      // payPal
      payPalEnable : json['payPalEnable'].toString(),
      payPalSandBoxMode : json['payPalSandBox'].toString(),
      payPalClientId : json['payPalClientId'].toString(),
      payPalSecret : json['payPalSecret'].toString(),
      // PayStack (Africa)
      payStackEnable : json['payStackEnable'].toString(),
      payStackKey : json['payStackKey'].toString(),
      // Yandex Kassa
      yandexKassaEnable : json['yandexKassaEnable'].toString(),
      yandexKassaShopId : json['yandexKassaShopId'].toString(),
      yandexKassaClientAppKey : json['yandexKassaClientAppKey'].toString(),
      yandexKassaSecretKey : json['yandexKassaSecretKey'].toString(),
      // instamojo
      instamojoEnable : json['instamojoEnable'].toString(),
      instamojoSandBoxMode : json['instamojoSandBoxMode'].toString(),
      instamojoApiKey : json['instamojoApiKey'].toString(),
      instamojoPrivateToken : json['instamojoPrivateToken'].toString(),
      // currency code
      code : json['code'].toString(),
    );
  }
}

class AppSettings {
  String currency;
  String darkMode;
  String rightSymbol;
  int symbolDigits;
  double radius;
  int shadow;
  List<String> rows;
  Color mainColor;
  Color iconColorWhiteMode;
  Color iconColorDarkMode;
  int restaurantCardWidth;
  int restaurantCardHeight;
  Color restaurantBackgroundColor;
  Color restaurantCardTextColor;
  Color dishesTitleColor;
  int dishesCardHeight;
  String oneInLine;
  int categoryCardWidth;
  int categoryCardHeight;
  double restaurantCardTextSize;
  Color dishesBackgroundColor;
  Color searchBackgroundColor;
  Color restaurantTitleColor;
  Color reviewTitleColor;
  Color reviewBackgroundColor;
  Color categoriesTitleColor;
  Color categoriesBackgroundColor;
  String categoryCardCircle;
  int topRestaurantCardHeight;
  String bottomBarType;
  Color bottomBarColor;
  Color titleBarColor;
  String mapapikey;
  String walletEnable;
  String typeFoods;
  String distanceUnit;
  String appLanguage;
  int banner1CardHeight;
  int banner2CardHeight;
  //
  String copyright;
  String copyrightText;
  String about;
  String delivery;
  String privacy;
  String terms;
  String refund;
  String faq;
  String refundTextName;
  String aboutTextName;
  String deliveryTextName;
  String privacyTextName;
  String termsTextName;
  //
  double defaultLat;
  double defaultLng;
  double defaultZoom;
  //
  String googleLogin;
  String facebookLogin;

  //Social Media
  String facebookText;
  String instagramText;
  String twitterText;
  String websiteText;
  //costos delivery
  double taxDelivery;
  double tarifaEnvio;
  int distanciaMaxima;
  int distanciaMinima;
  double tarifaKmExtra;

  //cargos por servicio
  double cargoTasa;
  double cargoTarifa;
  double cargoTasaImpuesto;
  //tiempos de la app
  int tiempoConfirmaPedido;
  int tiempoInvitaDriver;
  int tiempoConfirmaDriver;

  AppSettings({
    this.currency,
    this.darkMode = "false",
    this.rightSymbol = "false",
    this.walletEnable,
    this.symbolDigits = 2,
    this.radius = 15,
    this.shadow = 40,
    this.rows = const ["search", "nearyou", "cat", "pop", "review"],
    this.mainColor,
    this.iconColorWhiteMode = Colors.black,
    this.iconColorDarkMode = Colors.white,
    // restaurants
    this.restaurantCardWidth = 60,
    this.restaurantCardHeight = 40,
    this.restaurantBackgroundColor,
    this.restaurantCardTextSize,
    this.restaurantCardTextColor,
    this.restaurantTitleColor,
    // top restaurants
    this.topRestaurantCardHeight,
    // dishes - most popular
    this.dishesTitleColor,
    this.dishesBackgroundColor,
    this.dishesCardHeight = 80,
    this.oneInLine = "false",
    this.typeFoods = "",
    // categories
    this.categoryCardCircle,
    this.categoriesTitleColor,
    this.categoriesBackgroundColor,
    this.categoryCardWidth = 60,
    this.categoryCardHeight = 40,
    // search
    this.searchBackgroundColor,
    // review
    this.reviewTitleColor,
    this.reviewBackgroundColor,
    // bottomBar
    this.bottomBarType,
    this.bottomBarColor,
    // title bar
    this.titleBarColor,
    // map api key
    this.mapapikey,
    // km or miles
    this.distanceUnit,
    // app language
    this.appLanguage,
    // banners
    this.banner1CardHeight,
    this.banner2CardHeight,
    // documents
    this.copyright,
    this.copyrightText,
    this.about,
    this.delivery,
    this.privacy,
    this.terms,
    this.refund,
    this.faq,
    this.refundTextName,
    this.aboutTextName,
    this.deliveryTextName,
    this.privacyTextName,
    this.termsTextName,
    //
    this.defaultLat,
    this.defaultLng,
    this.defaultZoom,
    //
    this.googleLogin,
    this.facebookLogin,

    //Social Media
    this.facebookText,
    this.instagramText,
    this.twitterText,
    this.websiteText,

    //Social Media
    this.taxDelivery,
    this.tarifaEnvio,
    this.distanciaMaxima,
    this.distanciaMinima,
    this.tarifaKmExtra,

    //cargo por servicios
    this.cargoTasa,
    this.cargoTarifa,
    this.cargoTasaImpuesto,
    //tiempos de la app
    this.tiempoConfirmaPedido,
    this.tiempoInvitaDriver,
    this.tiempoConfirmaDriver,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    var _rows;
    if (json['rows'] != null) {
      _rows = json['rows'].cast<String>().toList();
    }else
      _rows = const ["search", "banner1", "topf", "nearyou", "cat", "pop", "review", "topr"];

    // debug
    //_rows = const ["search", "categoryDetails", "banner1", "topf", "banner2", "nearyou", "cat", "pop", "topr", "review", "copyright"];

    if (json['darkMode'] != null){
      if (json['darkMode'] == "true")
        theme.darkMode = true;
      else
        theme.darkMode = false;
      theme.init();
      pref.set(Pref.uiDarkMode, json['darkMode']);
    }

    return AppSettings(
      currency: json['currency'].toString(),
      darkMode : json['darkMode'].toString(),
      rightSymbol : json['rightSymbol'].toString(),
      symbolDigits: toInt(json['symbolDigits'].toString()),
      walletEnable : (json['walletEnable'] == null) ? "true" : json['walletEnable'].toString(),
      radius : (json['radius'] == null) ? 3 : toDouble(json['radius'].toString()),
      shadow : (json['shadow'] == null) ? 10 : toInt(json['shadow'].toString()),
      rows : _rows,
      iconColorWhiteMode : (json['iconColorWhiteMode'] == null) ? theme.colorDefaultText : Color(int.parse(json['iconColorWhiteMode'].toString(), radix: 16)),
      iconColorDarkMode : (json['iconColorDarkMode'] == null) ? Colors.white : Color(int.parse(json['iconColorDarkMode'].toString(), radix: 16)),
      mainColor : (json['mainColor'] == null) ? theme.colorPrimary : Color(int.parse(json['mainColor'].toString(), radix: 16)),
      // restaurant
      restaurantTitleColor :  (json['restaurantTitleColor'] == null) ? theme.colorBackground : Color(int.parse(json['restaurantTitleColor'].toString(), radix: 16)),
      restaurantCardWidth : (json['restaurantCardWidth'] == null) ? 60 : toInt(json['restaurantCardWidth'].toString()),
      restaurantCardHeight :  (json['restaurantCardHeight'] == null) ? 40 : toInt(json['restaurantCardHeight'].toString()),
      restaurantBackgroundColor : (json['restaurantBackgroundColor'] == null) ? theme.colorBackground : Color(int.parse(json['restaurantBackgroundColor'].toString(), radix: 16)),
      restaurantCardTextSize :  (json['restaurantCardTextSize'] == null) ? 14 : toDouble(json['restaurantCardTextSize'].toString()),
      restaurantCardTextColor : (json['restaurantCardTextColor'] == null) ? theme.colorDefaultText : Color(int.parse(json['restaurantCardTextColor'].toString(), radix: 16)),
      // top restaurants
      topRestaurantCardHeight :  (json['topRestaurantCardHeight'] == null) ? 60 : toInt(json['topRestaurantCardHeight'].toString()),
      // dishes
      dishesTitleColor : (json['dishesTitleColor'] == null) ? theme.colorBackground : Color(int.parse(json['dishesTitleColor'].toString(), radix: 16)),
      dishesBackgroundColor : (json['dishesBackgroundColor'] == null) ? theme.colorBackground : Color(int.parse(json['dishesBackgroundColor'].toString(), radix: 16)),
      dishesCardHeight : (json['dishesCardHeight'] == null) ? 70 : toInt(json['dishesCardHeight'].toString()),
      oneInLine : (json['oneInLine'] == null) ? "false" : json['oneInLine'].toString(),
      typeFoods : (json['typeFoods'] == null) ? "type2" : json['typeFoods'].toString(),
      // search
      searchBackgroundColor : (json['searchBackgroundColor'] == null) ? theme.colorBackground : Color(int.parse(json['searchBackgroundColor'].toString(), radix: 16)),
      // review
      reviewTitleColor : (json['reviewTitleColor'] == null) ? theme.colorBackground : Color(int.parse(json['reviewTitleColor'].toString(), radix: 16)),
      reviewBackgroundColor : (json['reviewBackgroundColor'] == null) ? theme.colorBackground : Color(int.parse(json['reviewBackgroundColor'].toString(), radix: 16)),
      // categories
      categoriesTitleColor : (json['categoriesTitleColor'] == null) ? theme.colorBackground : Color(int.parse(json['categoriesTitleColor'].toString(), radix: 16)),
      categoriesBackgroundColor: (json['categoriesBackgroundColor'] == null) ? theme.colorBackground : Color(int.parse(json['categoriesBackgroundColor'].toString(), radix: 16)),
      categoryCardWidth : (json['categoryCardWidth'] == null) ? 30 : toInt(json['categoryCardWidth'].toString()),
      categoryCardHeight : (json['categoryCardHeight'] == null) ? 30 : toInt(json['categoryCardHeight'].toString()),
      categoryCardCircle : (json['categoryCardCircle'] == null) ? "true" : json['categoryCardCircle'].toString(),
      // bottom bar
      bottomBarType : (json['bottomBarType'] == null) ? "type1" : json['bottomBarType'].toString(),
      bottomBarColor : (json['bottomBarColor'] == null) ? theme.colorBackground : Color(int.parse(json['bottomBarColor'].toString(), radix: 16)),
      titleBarColor :  (json['titleBarColor'] == null) ? theme.colorBackground : Color(int.parse(json['titleBarColor'].toString(), radix: 16)),
      // map api key
      mapapikey : (json['mapapikey'] == null) ? "" : json['mapapikey'].toString(),
      // km or miles
      distanceUnit : (json['distanceUnit'] == null) ? "" : json['distanceUnit'].toString(),
      // app language
      appLanguage: (json['appLanguage'] == null) ? "1" : json['appLanguage'].toString(), // default english
      //
      banner1CardHeight : (json['banner1CardHeight'] == null) ? 40 : toInt(json['banner1CardHeight'].toString()),
      banner2CardHeight : (json['banner2CardHeight'] == null) ? 40 : toInt(json['banner2CardHeight'].toString()),
      //
      copyright : json['copyright'].toString(),
      copyrightText : json['copyright_text'].toString(),
      about : json['about'].toString(),
      delivery : json['delivery'].toString(),
      privacy : json['privacy'].toString(),
      terms : json['terms'].toString(),
      refund : json['refund'].toString(),
      faq : json['faq'].toString(),
      refundTextName : json['refund_text_name'].toString(),
      aboutTextName : json['about_text_name'].toString(),
      deliveryTextName : json['delivery_text_name'].toString(),
      privacyTextName : json['privacy_text_name'].toString(),
      termsTextName : json['terms_text_name'].toString(),
      //
      googleLogin : (json['googleLogin_ca'] == null) ? "true" : json['googleLogin_ca'].toString(),
      facebookLogin : (json['facebookLogin_ca'] == null) ? "true" : json['facebookLogin_ca'].toString(),

      // Social Media
      facebookText : (json['facebook_text'] == null) ? "true" : json['facebook_text'].toString(),
      instagramText : (json['instagram_text'] == null) ? "true" : json['instagram_text'].toString(),
      twitterText : (json['twitter_text'] == null) ? "true" : json['twitter_text'].toString(),
      websiteText : (json['website_text'] == null) ? "true" : json['website_text'].toString(),




      // taeifas de env??o
      taxDelivery  : (json['taxDelivery'] == null) ? 0 : toDouble(json['taxDelivery'].toString()),
      tarifaEnvio  : (json['tarifaEnvio'] == null) ? 0 : toDouble(json['tarifaEnvio'].toString()),
      distanciaMaxima : (json['distanciaMaxima'] == null) ? 0 : toInt(json['distanciaMaxima'].toString()),
      distanciaMinima : (json['distanciaMinima'] == null) ? 0 : toInt(json['distanciaMinima'].toString()),
      tarifaKmExtra : (json['tarifaKmExtra'] == null) ? 0 : toDouble(json['tarifaKmExtra'].toString()),
      //cargos por servicios

      cargoTasa : (json['cargoTasa'] == null) ? 0.0 : toDouble(json['cargoTasa'].toString()),
      cargoTarifa : (json['cargoTarifa'] == null) ? 0.0 : toDouble(json['cargoTarifa'].toString()),
      cargoTasaImpuesto : (json['cargoTasaImpuesto'] == null) ? 0.0 : toDouble(json['cargoTasaImpuesto'].toString()),
      //tiempos de la ah perro

      tiempoConfirmaPedido : (json['tiempoConfirmaPedido'] == null) ? 0.0 : toInt(json['tiempoConfirmaPedido'].toString()),
      tiempoInvitaDriver : (json['tiempoInvitaDriver'] == null) ? 0.0 : toInt(json['tiempoInvitaDriver'].toString()),
      tiempoConfirmaDriver : (json['tiempoConfirmaDriver'] == null) ? 0.0 : toInt(json['tiempoConfirmaDriver'].toString()),


      // Puebla MX
      defaultLat  : (json['defaultLat'] == null) ? 19.040034 : toDouble(json['defaultLat'].toString()),
      defaultLng  : (json['defaultLng'] == null) ? -98.2630051 : toDouble(json['defaultLng'].toString()),
      defaultZoom : (json['defaultZoom'] == null) ? 12 : toDouble(json['defaultZoom'].toString()),

    );
  }

  Color getIconColorByMode(bool darkMode){
    if (darkMode)
      return iconColorDarkMode;
    else
      return iconColorWhiteMode;
  }
}





