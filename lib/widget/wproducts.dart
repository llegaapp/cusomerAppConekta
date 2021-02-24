import 'package:flutter/material.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/model/categories.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/ui/main/mainscreen.dart';
import 'package:fooddelivery/widget/wsearch.dart';
import '../main.dart';
import 'ICard12FileCaching.dart';
import 'ICard21FileCaching.dart';
import 'ICard30FileCaching.dart';
import 'ICard32FileCaching.dart';

dishList2(List<Widget> list, List<DishesData> _mostPopular, BuildContext context,
    Function(String id, String heroId)  _onMostPopularClick, double windowWidth,
    String searchByCategory, Function(String) onAddToCartClick){
  // debug
  // _mostPopular =  [
  //   DishesData(image: "1603721362095s1.jpeg", name: "1", restaurantName: "1", price: 1, id: "1"),
  //   DishesData(image: "1603721362095s1.jpeg", name: "2", restaurantName: "1", price: 1, id: "1"),
  //   DishesData(image: "1603721362095s1.jpeg", name: "3", restaurantName: "1", price: 1, id: "1"),
  //   DishesData(image: "1603721362095s1.jpeg", name: "4", restaurantName: "1", price: 1, id: "1"),
  //   DishesData(image: "1603721362095s1.jpeg", name: "5", restaurantName: "1", price: 1, id: "1"),
  //   DishesData(image: "1603721362095s1.jpeg", name: "6", restaurantName: "1", price: 1, id: "1"),
  //   // DishesData(image: "1603721362095s1.jpeg", name: "7", restaurantName: "1", price: 1, id: "1"),
  //   // DishesData(image: "1603721362095s1.jpeg", name: "8", restaurantName: "1", price: 1, id: "1"),
  // ];

  if (_mostPopular == null)
    return;
  var size = _mostPopular.length;

  var _childs = List<Widget>();
  bool first = true;

  var constHeight = windowWidth*0.7;
  var _height = constHeight;
  var y1Start = 10.0;
  var y2Start = 10.0;

  var index = 0;
  for (var item in _mostPopular) {
    if (restaurantSearchValue != "0" && item.restaurant != restaurantSearchValue)
      continue;
    if (categoriesSearchValue != "0" && item.category != categoriesSearchValue)
      continue;
    if (searchByCategory.isNotEmpty && item.category != searchByCategory)
      continue;
    if (first) {
      _height = constHeight;

      if (index == 0 && size > 2)
        _height = constHeight/2-5;

      if (index == size-1 && size > 2)
        _height = constHeight/2-5;

      first = false;
      _childs.add(Container(
        width: windowWidth/2-15,
        height: _height,
        margin: EdgeInsets.only(top: y1Start, left: 10, right: 5),
        child: _card32item(item, windowWidth, _height, _onMostPopularClick, onAddToCartClick),
      ));
      y1Start += _height+10;
    }else{
      _height = constHeight;

      if (index == size-1 && size > 2)
        _height = constHeight/2-5;

      first = true;
      var margin = EdgeInsets.only(left: windowWidth/2+5, top: y2Start, right: 10);
      if (strings.direction == TextDirection.rtl)
        margin = EdgeInsets.only(right: windowWidth/2+5, top: y2Start, left: 10);

      _childs.add(Container(
        width: windowWidth/2-15,
        height: _height,
        margin: margin,
        child: _card32item(item, windowWidth, _height, _onMostPopularClick, onAddToCartClick),
      ));

      y2Start += (_height+10);
    }
    index++;
  }
  if (y2Start == 10)
    y2Start = _height;
  if (size == 1 || size == 2)
    y2Start = constHeight;
  if (_childs.length != 0)
    list.add(Container(
      width: windowWidth,
      height: y2Start+20,
      child: Stack(
        children: _childs,
      ),
    ));
  return;
}

_card32item(DishesData item, double windowWidth, double _height, Function(String id, String heroId)  _onMostPopularClick,
    Function(String) onAddToCartClick){
  return ICard32FileCaching(
    radius: appSettings.radius,
    shadow: appSettings.shadow,
    colorProgressBar: theme.colorPrimary,
    getFavoriteState: account.getFavoritesState,
    revertFavoriteState: account.revertFavoriteState,
    color: theme.colorBackground,
    text: item.name,
    text3: (theme.multiple) ? item.restaurantName : getCategoryName(item.category),
    enableFavorites: account.isAuth(),
    width: windowWidth * 0.5 - 20,
    height: _height,
    image: "$serverImages${item.image}",
    dicount: item.discount,
    id: item.id,
    active: item.active,
    price: basket.makePriceSctring(item.price),
    onAddToCartClick: onAddToCartClick,
    discountprice: (item.discountprice != 0) ? basket.makePriceSctring(item.discountprice) : "",
    textStyle2: theme.text18boldPrimaryUIWhite,
    textStyle: theme.text18boldPrimaryUIWhite,
    textStyle3: theme.text16UIWhite,
    callback: _onMostPopularClick,
  );
}

dishList(List<Widget> list, List<DishesData> _mostPopular, BuildContext context,
    Function(String id, String heroId)  _onMostPopularClick, double windowWidth, Function(String) onAddToCartClick){
  if (_mostPopular == null)
    return;
  var height = windowWidth*appSettings.dishesCardHeight/100;
  bool first = true;
  Widget t1;
  for (var item in _mostPopular) {
    if (restaurantSearchValue != "0" && item.restaurant != restaurantSearchValue)
      continue;
    if (categoriesSearchValue != "0" && item.category != categoriesSearchValue)
      continue;
    if (first) {
      t1 = ICard21FileCaching(
        radius: appSettings.radius,
        shadow: appSettings.shadow,
        colorProgressBar: theme.colorPrimary,
        getFavoriteState: account.getFavoritesState,
        revertFavoriteState: account.revertFavoriteState,
        color: theme.colorBackground,
        text: item.name,
        text3: (theme.multiple) ? item.restaurantName : getCategoryName(item.category),
        enableFavorites: account.isAuth(),
        width: windowWidth * 0.5 - 10,
        height: height,
        image: "$serverImages${item.image}",
        id: item.id,
        price: basket.makePriceSctring(item.price),
        discountprice: (item.discountprice != 0) ? basket.makePriceSctring(item.discountprice) : "",
        dicount: item.discount,
        textStyle2: theme.text18boldPrimaryUI,
        textStyle: theme.text18boldPrimaryUI,
        textStyle3: theme.text16UI,
        callback: _onMostPopularClick,
        onAddToCartClick: onAddToCartClick,
      );
      first = false;
    }else{
      var t2 = ICard21FileCaching(
        radius: appSettings.radius,
        shadow: appSettings.shadow,
        colorProgressBar: theme.colorPrimary,
        color: theme.colorBackground,
        getFavoriteState: account.getFavoritesState,
        revertFavoriteState: account.revertFavoriteState,
        text: item.name,
        enableFavorites: account.isAuth(),
        width: windowWidth * 0.5 - 10,
        height: height,
        image: "$serverImages${item.image}",
        id: item.id,
        text3: (theme.multiple) ? item.restaurantName : getCategoryName(item.category),
        dicount: item.discount,
        discountprice: (item.discountprice != 0) ? basket.makePriceSctring(item.discountprice) : "",
        price: basket.makePriceSctring(item.price),
        textStyle2: theme.text18boldPrimaryUI,
        textStyle: theme.text18boldPrimaryUI,
        textStyle3: theme.text16UI,
        callback: _onMostPopularClick,
        onAddToCartClick: onAddToCartClick,
      );
      list.add(Container(
        color: appSettings.dishesBackgroundColor,
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            t1,
            t2
          ],
        ),
      ));
      first = true;
    }
  }
  if (!first){
    list.add(Container(
      color: appSettings.dishesBackgroundColor,
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          t1,
          Container(width: windowWidth * 0.5 - 15,)
        ],
      ),
    ));
  }
}

dishListOneInLine(List<Widget> list, List<DishesData> productItems, Function (String id, String heroId) callback, double windowWidth,
    Function(String) onAddToCartClick) {
  if (productItems == null)
    return;
  var height = (windowWidth)*appSettings.dishesCardHeight/100;
  for (var item in productItems) {
    if (restaurantSearchValue != "0" && item.restaurant != restaurantSearchValue)
      continue;
    if (categoriesSearchValue != "0" && item.category != categoriesSearchValue)
      continue;
    var t2 = ICard21FileCaching(
      radius: appSettings.radius,
      shadow: appSettings.shadow,
      colorProgressBar: theme.colorPrimary,
      color: theme.colorBackground,
      getFavoriteState: account.getFavoritesState,
      revertFavoriteState: account.revertFavoriteState,
      text: item.name,
      enableFavorites: account.isAuth(),
      width: windowWidth,
      height: height,
      image: "$serverImages${item.image}",
      id: item.id,
      text3: (theme.multiple) ? item.restaurantName : getCategoryName(item.category),
      dicount: item.discount,
      discountprice: (item.discountprice != 0) ? basket.makePriceSctring(item.discountprice) : "",
      price: basket.makePriceSctring(item.price),
      textStyle2: theme.text18boldPrimaryUI,
      textStyle: theme.text18boldPrimaryUI,
      textStyle3: theme.text16UI,
      callback: callback,
      onAddToCartClick: onAddToCartClick,
    );
    list.add(Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: t2
    ));
  }
}

horizontalCategoriesCircleRestaurant(List<CategoriesData> cat, double windowWidth, Function(String id, String hero, String image) _onCategoriesClick){
  var list = List<Widget>();
  list.add(SizedBox(width: 10,));
  var height = windowWidth*appSettings.categoryCardHeight/100;
  for (var item in cat) {
    if (categoriesSearchValue != "0" && item.id != categoriesSearchValue)
      continue;

    if (item.parent == "0" || item.parent == "-1") {
      list.add(ICard30FileCaching(
        shadow: appSettings.shadow,
        radius: appSettings.radius,
        color: theme.colorBackground,
        colorProgressBar: theme.colorPrimary,
        text: item.name,
        width: windowWidth * appSettings.categoryCardWidth / 100,
        height: height,
        image: item.image,
        id: item.id,
        textStyle: theme.text18boldPrimaryUI,
        callback: _onCategoriesClick,
      ));
      list.add(SizedBox(width: 10,));
    }
  }
  if (list.length == 1)
    return Container();
  return Container(
    color: appSettings.categoriesBackgroundColor,
    padding: EdgeInsets.only(top: 10),
    height: height+30,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list,
    ),
  );
}

horizontalCategoriesCircle(double windowWidth, Function(String id, String hero, String image) _onCategoriesClick){
  var list = List<Widget>();
  list.add(SizedBox(width: 10,));
  var height = windowWidth*appSettings.categoryCardHeight/100;
  for (var item in categories) {
    if (categoriesSearchValue != "0" && item.id != categoriesSearchValue)
      continue;

    if (item.parent == "0" || item.parent == "-1") {
      list.add(ICard30FileCaching(
        shadow: appSettings.shadow,
        radius: appSettings.radius,
        color: theme.colorBackground,
        colorProgressBar: theme.colorPrimary,
        text: item.name,
        width: windowWidth * appSettings.categoryCardWidth / 100,
        height: height,
        image: item.image,
        id: item.id,
        textStyle: theme.text18boldPrimaryUI,
        callback: _onCategoriesClick,
      ));
      list.add(SizedBox(width: 10,));
    }
  }
  if (list.length == 1)
    return Container();
  return Container(
    color: appSettings.categoriesBackgroundColor,
    padding: EdgeInsets.only(top: 10),
    height: height+30,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list,
    ),
  );
}

horizontalCategories(double windowWidth, Function(String id, String hero, String image) _onCategoriesClick){
  var list = List<Widget>();
  list.add(SizedBox(width: 10,));
  var height = windowWidth*appSettings.categoryCardHeight/100;
  for (var item in categories) {
    if (categoriesSearchValue != "0" && item.id != categoriesSearchValue)
      continue;
    if (item.parent == "0" || item.parent == "-1") {
      list.add(ICard12FileCaching(
        shadow: appSettings.shadow,
        radius: appSettings.radius,
        color: theme.colorBackground,
        colorProgressBar: theme.colorPrimary,
        text: item.name,
        width: windowWidth * appSettings.categoryCardWidth / 100,
        height: height,
        image: item.image,
        id: item.id,
        textStyle: theme.text18boldPrimaryUI,
        callback: _onCategoriesClick,
      ));
      list.add(SizedBox(width: 10,));
    }
  }
  if (list.length == 1)
    return Container();
  return Container(
    color: appSettings.categoriesBackgroundColor,
    padding: EdgeInsets.only(top: 10),
    height: height+20,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list,
    ),
  );
}

horizontalCategoriesRestaurant(List<CategoriesData> cat, double windowWidth, Function(String id, String hero, String image) _onCategoriesClick){
  var list = List<Widget>();
  list.add(SizedBox(width: 10,));
  var height = windowWidth*appSettings.categoryCardHeight/100;
  for (var item in cat) {
    if (categoriesSearchValue != "0" && item.id != categoriesSearchValue)
      continue;
    if (item.parent == "0" || item.parent == "-1") {
      list.add(ICard12FileCaching(
        shadow: appSettings.shadow,
        radius: appSettings.radius,
        color: theme.colorBackground,
        colorProgressBar: theme.colorPrimary,
        text: item.name,
        width: windowWidth * appSettings.categoryCardWidth / 100,
        height: height,
        image: item.image,
        id: item.id,
        textStyle: theme.text18boldPrimaryUI,
        callback: _onCategoriesClick,
      ));
      list.add(SizedBox(width: 10,));
    }
  }
  if (list.length == 1)
    return Container();
  return Container(
    color: appSettings.categoriesBackgroundColor,
    padding: EdgeInsets.only(top: 10),
    height: height+20,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list,
    ),
  );
}
