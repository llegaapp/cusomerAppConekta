import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/categories.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/model/foods.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/server/category.dart';
import 'package:fooddelivery/model/server/mainwindowdata.dart';
import 'package:fooddelivery/ui/main/home.dart';
import 'package:fooddelivery/widget/ICard12FileCaching.dart';
import 'package:fooddelivery/widget/ICard30FileCaching.dart';
import 'package:fooddelivery/widget/buttonadd.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/ilist1.dart';
import 'package:fooddelivery/widget/widgets.dart';
import 'package:fooddelivery/widget/wproducts.dart';

import 'mainscreen.dart';

class CategoryDetailsScreen extends StatefulWidget {
  CategoryDetailsScreen({Key key}) : super(key: key);
  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> with SingleTickerProviderStateMixin {

  ///////////////////////////////////////////////////////////////////////////////
  //
  List<String> listCategoryBack = [];
  _onBack(){
    if (listCategoryBack.length > 1) {
      idCategory = listCategoryBack[listCategoryBack.length - 2];
      listCategoryBack.removeAt(listCategoryBack.length - 1);
      _waits(true);
      category.get(idCategory, _success, _error);
      _controller.animateTo(
          0, duration: Duration(seconds: 1), curve: Curves.ease);
    }else
      Navigator.pop(context);
  }

  _onCategoriesClick(String id, String heroId, String image) {
    print("User pressed Category item with id: $id");
    idCategory = id;
    listCategoryBack.add(id);
    imageCategory = image;
    _waits(true);
    category.get(idCategory, _success, _error);
    _controller.animateTo(
        0, duration: Duration(seconds: 1), curve: Curves.ease);
  }

  _onDishesClick(String id, String heroId) {
    dprint("User pressed Most Popular item with id: $id");
    idHeroes = heroId;
    idDishes = id;
    route.setDuration(1);
    route.push(context, "/dishesdetails");
  }

  ///////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  var _controller = ScrollController();
  Category category = Category();
  bool _wait = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    noMain = true;
    mainCurrentDialogShow = 0;
    _controller.addListener(() {});
    listCategoryBack.add(idCategory);
    _categoryImage = imageCategory;
    category.get(idCategory, _success, _error);
    account.addCallback(this.hashCode.toString(), callback);
    super.initState();
  }

  @override
  void dispose() {
    noMain = false;
    account.removeCallback(this.hashCode.toString());
    route.disposeLast();
    _controller.dispose();
    super.dispose();
  }

  callback(bool reg){
    if (mounted)
      setState(() {
      });
  }

  String _categoryName = "";
  String _categoryDesc = "";
  String _categoryImage;

  _success(List<DishesData> _data, String currency, String desc, String image,
      String name) {
    _waits(false);
    _categoryName = name;
    _categoryDesc = desc;
    _categoryImage = image;
    dishData = _data;
    setState(() {});
  }

  _error(String error) {
    _waits(false);
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _waits(bool value) {
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery
        .of(context)
        .size
        .width;
    windowHeight = MediaQuery
        .of(context)
        .size
        .height;
    return WillPopScope(
        onWillPop: () async {
      if (mainCurrentDialogShow != 0) {
        setState(() {
          mainCurrentDialogShow = 0;
        });
        return false;
      }
      _onBack();
      return false;
    },
    child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: theme.colorBackground,
        body: Directionality(
            textDirection: strings.direction,
            child: Stack(
                children: [
                  NestedScrollView(
                      controller: _controller,
                      headerSliverBuilder: (BuildContext context,
                          bool innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            expandedHeight: windowHeight * 0.35,
                            automaticallyImplyLeading: false,
                            elevation: 0,
                            backgroundColor: theme.colorBackground,
                            flexibleSpace: FlexibleSpaceBar(
                              collapseMode: CollapseMode.parallax,
                              background: _imageBuild(),
                            ),
                          )
                        ];
                      },

                      body: Stack(
                        children: <Widget>[

                          Container(
                            child: _body(),
                          ),

                          if (_addToBasketItem != null)
                            buttonAddToCart(_addToBasketItem, (){setState(() {});}, ( ){_addToBasketItem = null; setState(() {});},
                                _scaffoldKey),

                          if (_wait)
                              Container(
                                  alignment: Alignment.center,
                                  child: ColorLoader2(
                                    color1: theme.colorPrimary,
                                    color2: theme.colorCompanion,
                                    color3: theme.colorPrimary,
                                  ),
                              ),


                          IEasyDialog2(setPosition: (double value) {mainCurrentDialogShow = value;}, getPosition: () {return mainCurrentDialogShow;},
                            color: theme.colorGrey, body: mainCurrentDialogBody, backgroundColor: theme.colorBackground,),

                        ],
                      )
                  ),
                  headerBackButtonWithBack(context, Colors.white, _onBack)
                ])
        )));
  }

  _body() {
    return Container(
      child: RefreshIndicator(
        onRefresh: () async {
                     setState(() {
                      // initState();
                     });
                  },
              child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: _children(),
        ),
      ),
    );
  }

  _children() {
    var list = List<Widget>();

    list.add(SizedBox(height: 20,));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: IList1(
          imageAsset: "assets/orders.png", text: _categoryName, //  name
          textStyle: theme.text16bold, imageColor: theme.colorDefaultText),
    ));

    if (_categoryDesc.isNotEmpty) {
      list.add(SizedBox(height: 20,));
      list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Text(_categoryDesc, style: theme.text14), // description
      ));
    }

    for (var item in categories) {
      if (item.parent == idCategory) {
        list.add(SizedBox(height: 20,));
        list.add(Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: IList1(imageAsset: "assets/categories.png",
              text: strings.get(41),                                    // Subcategories
              textStyle: theme.text16bold,
              imageColor: theme.colorDefaultText),
        ));
        list.add(SizedBox(height: 10,));

        if (appSettings.categoryCardCircle == "true")
          list.add(_horizontalCategoriesCircle());
        else
          list.add(_horizontalCategories());
        break;
      }
    }
    list.add(SizedBox(height: 20,));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: IList1(
          imageAsset: "assets/top.png", text: strings.get(91), // Dishes
          textStyle: theme.text16bold, imageColor: theme.colorDefaultText),
    ));

    if (appSettings.typeFoods == "type2")
      dishList2(list, dishData, context, _onDishesClick, windowWidth, "", _onAddToCartClick);
    else {
      if (appSettings.oneInLine == "false")
        dishList(list, dishData, context, _onDishesClick, windowWidth, _onAddToCartClick);
      else
        dishListOneInLine(list, dishData, _onDishesClick, windowWidth, _onAddToCartClick);
    }
    list.add(SizedBox(height: 150,));
    return list;
  }

  DishesData _addToBasketItem;

  _onAddToCartClick(String id){
    dprint("add to cart click id=$id");
    _addToBasketItem = loadFood(id);
    _addToBasketItem.count = 1;
    setState(() {
    });
  }

  _horizontalCategories() {
    var list = List<Widget>();
    list.add(SizedBox(width: 10,));
    var height = windowWidth * appSettings.categoryCardHeight / 100;
    for (var item in categories) {
      if (item.id != idCategory) {
        if (item.parent == idCategory) {
          list.add(ICard12FileCaching(
            shadow: appSettings.shadow,
            radius: appSettings.radius,
            color: theme.colorBackground,
            text: item.name,
            width: windowWidth * appSettings.categoryCardWidth / 100,
            height: height,
            image: item.image,
            id: item.id,
            textStyle: theme.text16bold,
            colorProgressBar: theme.colorPrimary,
            callback: _onCategoriesClick,
          ));
          list.add(SizedBox(width: 10,));
        }
      }
    }
    return Container(
      height: height + 20,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  _horizontalCategoriesCircle() {
    var list = List<Widget>();
    list.add(SizedBox(width: 10,));
    var height = windowWidth * appSettings.categoryCardHeight / 100;
    for (var item in categories) {
      if (item.parent == idCategory) {
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
    return Container(
      color: appSettings.categoriesBackgroundColor,
      padding: EdgeInsets.only(top: 10),
      height: height + 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  _imageBuild(){
    // dprint("Food -> idHeroes=$idHeroes");
    // print(_this.restaurantActive);
    return Container(
        child: Hero(
            tag: idHeroes,
            child: Stack(
              children: [
                CachedNetworkImage(
                  placeholder: (context, url) =>
                      CircularProgressIndicator(),
                  imageUrl: _categoryImage,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  errorWidget: (context,url,error) => new Icon(Icons.error),
                ),

                // if(_this.active == false || _this.restaurantActive == false)(

                    Container(
                      width: windowWidth,
                      color: Color(0x77a7a7a7),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Icon(Icons.visibility_off_rounded, color: Colors.white, size: 60,),
                            Text(_categoryName.toUpperCase(), style: theme.text40boldWhiteShadow),
                          ],
                        ),
                      ),
                    )

                // ),



              ],
            )
        )
    );
  }


  openDialog(String _text) {
    mainCurrentDialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155), // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: () {
              setState(() {
                mainCurrentDialogShow = 0;
              });
            }
        ),
      ],
    );

    setState(() {
      mainCurrentDialogShow = 1;
    });
  }
}