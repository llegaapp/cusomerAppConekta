import 'package:fooddelivery/model/server/mainwindowdata.dart';

List<Restaurants> nearYourRestaurants = [];
List<Restaurants> topRestaurants = [];

getRestaurant(String id){
  for (var item in nearYourRestaurants){
    if (item.id == id)
      return item;
  }
  return null;
}