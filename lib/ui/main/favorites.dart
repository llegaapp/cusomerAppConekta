import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/model/foods.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/ui/main/home.dart';
import 'package:fooddelivery/widget/buttonadd.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/iinkwell.dart';
import 'package:fooddelivery/widget/ilist2.dart';
import 'package:fooddelivery/widget/wproducts.dart';

class FavoritesScreen extends StatefulWidget {
  final Function(String) callback;
  final scaffoldKey;
  FavoritesScreen({this.callback, this.scaffoldKey});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {


  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //

  _onItemClick(String id, String heroId){
    print("User pressed item with id: $id");
    idHeroes = heroId;
    idDishes = id;
    route.setDuration(1);
    route.push(context, "/dishesdetails");
  }

  _pressLoginButton(){
    print("User pressed \"LOGIN\" button");
    route.push(context, "/login");
  }

  _pressDontHaveAccountButton(){
    print("User press \"Don't have account\" button");
    route.push(context, "/createaccount");
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  bool _selectList = false;

  @override
  void initState() {
    account.addCallback(this.hashCode.toString(), callback);
    super.initState();
  }

  callback(bool reg){
      setState(() {
      });
  }

  @override
  void dispose() {
    account.removeCallback(this.hashCode.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    if (account.isAuth())
      return Directionality(
          textDirection: strings.direction,
          child: Stack(
        children: [

          if (userFavorites.isNotEmpty)
          Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+50),
              child: ListView(
                  padding: EdgeInsets.only(top: 0),
                  shrinkWrap: true,
                  children: _children()
              )
          ),

          if (userFavorites.isEmpty)
            Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    UnconstrainedBox(
                        child: Container(
                            height: windowHeight/3,
                            width: windowWidth/2,
                            child: Container(
                              child: Image.asset("assets/noorders.png",
                                fit: BoxFit.contain,
                              ),
                            )
                        )),
                    SizedBox(height: 20,),
                    Text(strings.get(179),    // "Not Have Favorites Food",
                        overflow: TextOverflow.clip,
                        style: theme.text16bold
                    ),
                    SizedBox(height: 50,),
                  ],
                )
            ),

          if (_addToBasketItem != null)
            Container(
              margin: EdgeInsets.only(bottom: 60),
              child: buttonAddToCart(_addToBasketItem, (){setState(() {});}, ( ){_addToBasketItem = null; setState(() {});},
                  widget.scaffoldKey),
            ),
        ],
      ));
    else
      return _mustAuth();
  }

  _children(){
    var list = List<Widget>();

    list.add(SizedBox(height: 10,));

    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: IList2(imageAsset: "assets/favorites.png",
        text: strings.get(38),                      // "Favorites",
        textStyle: theme.text16bold,
        imageColor: theme.colorDefaultText,
        child1: IInkWell(child: _listIcon(), onPress: _onListIconClick,),
        child2: IInkWell(child: _tileIcon(), onPress: _onTileIconClick,),
      )
    ));

    list.add(SizedBox(height: 10,));

    if (!_selectList) {
      if (appSettings.typeFoods == "type2")
        dishList2(list, userFavorites, context, _onItemClick, windowWidth, "", _onAddToCartClick);
      else
        dishList(list, userFavorites, context, _onItemClick, windowWidth, _onAddToCartClick, true);
    }else
      dishListOneInLine(list, userFavorites, _onItemClick, windowWidth, _onAddToCartClick);

    list.add(SizedBox(height: 200,));

    return list;
  }

  _onAddToCartClick(String id){
    dprint("add to cart click id=$id");
    _addToBasketItem = loadFood(id);
    _addToBasketItem.count = 1;
    setState(() {
    });
  }

  DishesData _addToBasketItem;

  _listIcon(){
    if (_selectList)
      return UnconstrainedBox(
          child: Container(
              height: 30,
              width: 30,
              child: Image.asset("assets/list.png",
                fit: BoxFit.contain, color: theme.colorPrimary,
              )
          ));
    else
      return UnconstrainedBox(
          child: Container(
              height: 20,
              width: 20,
              child: Image.asset("assets/list.png",
                fit: BoxFit.contain, color: theme.colorDefaultText,
              )
          ));
  }

  _tileIcon(){
    if (!_selectList)
      return UnconstrainedBox(
          child: Container(
              height: 30,
              width: 30,
              child: Image.asset("assets/tile.png",
                fit: BoxFit.contain, color: theme.colorPrimary,
              )
          ));
    else
      return UnconstrainedBox(
          child: Container(
              height: 20,
              width: 20,
              child: Image.asset("assets/tile.png",
                fit: BoxFit.contain, color: theme.colorDefaultText,
              )
          ));
  }
  //
  // _revertFavoriteState(String id){
  //   var state = account.revertFavoriteState(id);
  //
  //   if (!state) { // delete
  //     DishesData temp;
  //     for (var item in userFavorites)
  //       if (item.id == id)
  //         temp = item;
  //       if (temp != null)
  //         userFavorites.remove(temp);
  //   }
  //
  //   setState(() {
  //   });
  // }

  // _mostPopularList(List<Widget> list)
  //   if (userFavorites == null)
  //     return;
  //   var height = (windowWidth/2)*appSettings.dishesCardHeight/100;
  //   for (var item in userFavorites) {
  //     list.add(Container(
  //       margin: EdgeInsets.only(left: 10, right: 10),
  //         child: ICard21FileCaching(
  //           radius: appSettings.radius,
  //           shadow: appSettings.shadow,
  //           color: theme.colorBackground,
  //           text: item.name,
  //           width: windowWidth,
  //           height: height,
  //           image: "$serverImages${item.image}",
  //           text3: item.restaurantName,
  //           textStyle3: theme.text14,
  //           id: item.id,
  //           dicount: item.discount,
  //           discountprice: (item.discountprice != 0) ? basket.makePriceSctring(item.discountprice) : "",
  //           price: basket.makePriceSctring(item.price),
  //           colorProgressBar: theme.colorPrimary,
  //           getFavoriteState: account.getFavoritesState,
  //           textStyle2: theme.text14primary,
  //           revertFavoriteState: _revertFavoriteState,
  //           textStyle: theme.text16bold,
  //           callback: _onItemClick,
  //       )));
  //   }
  // }

  _onListIconClick(){
    if (!_selectList){
      setState(() {
        _selectList = true;
      });
    }
  }
  _onTileIconClick(){
    if (_selectList){
      setState(() {
        _selectList = false;
      });
    }
  }

  _mustAuth(){
    return Center(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UnconstrainedBox(
                child: Container(
                    width: windowWidth/3,
                    child: Image.asset("assets/auth.png",
                        fit: BoxFit.contain, color: Colors.black.withAlpha(80),
                    )
                )
            ),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.only(left: windowWidth*0.15, right: windowWidth*0.15),
                child: Text(strings.get(125), textAlign: TextAlign.center,), // "You must sign-in to access to this section",
            ),
            SizedBox(height: 40,),
            Container(
              margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
              child: IButton3(pressButton: _pressLoginButton, text: strings.get(22), // LOGIN
                color: theme.colorPrimary,
                textStyle: theme.text16boldWhite,),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
              child: InkWell(
                onTap: () {
                  _pressDontHaveAccountButton();
                }, // needed
                child:Text(strings.get(19),                    // ""Don't have an account? Create",",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: theme.text14primary
              )),
            )
          ],
        )
      ),
    );
  }
}