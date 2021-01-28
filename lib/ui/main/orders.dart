import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/orders.dart';
import 'package:fooddelivery/model/server/getOrders.dart';
import 'package:fooddelivery/ui/main/home.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/iCard14FileCaching.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/ilist1.dart';

class OrdersScreen extends StatefulWidget {
  final Function(String) onErrorDialogOpen;
  final Function(String) onBack;
  OrdersScreen({this.onErrorDialogOpen, this.onBack});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

Orders ordersData = Orders();

class _OrdersScreenState extends State<OrdersScreen> {


  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //

  _onItemClick(String id, String heroId){
    print("User pressed item with id: $id");
    idOrder = id;
    idHeroes = heroId;
    // route.setDuration(1);
    // route.push(context, "/");
    widget.onBack("order_details");
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

  @override
  void initState() {
    if (account.isAuth()) {
      _waits(true);
      ordersData.init(_success, _onError);
    }
    account.addCallback(this.hashCode.toString(), callback);
    super.initState();
  }

  List<OrdersData> _data;
  String _currency;

  _success(List<OrdersData> data, String currency){
    _waits(false);
    _data = data;
    _currency = currency;
    if (mounted)
      setState(() {
      });
  }

  bool _wait = false;

  _waits(bool value){
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  _onError(String err){
    _waits(false);
    if (err != "401")
      widget.onErrorDialogOpen("${strings.get(128)} $err"); // "Something went wrong. ",
  }

  callback(bool reg){
    if (mounted)
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
    Widget _body = _mustAuth();
    if (account.isAuth()) {
      if (_data != null && _data.isEmpty)
        _body = Center(
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
                Text(strings.get(180),    // "Not Have Orders",
                    overflow: TextOverflow.clip,
                    style: theme.text16bold
                ),
                SizedBox(height: 50,),
              ],
            )
        );
      else
        _body = Container(
            margin: EdgeInsets.only(top: MediaQuery
                .of(context)
                .padding
                .top + 50),
            child: ListView(
                padding: EdgeInsets.only(top: 0, left: 10, right: 10),
                shrinkWrap: true,
                children: _children()
            )
        );

    }

    return Directionality(
        textDirection: strings.direction,
        child: Stack(children: [
      _body,
      if (_wait)(
          Container(
            color: Color(0x80000000),
            width: windowWidth,
            height: windowHeight,
            child: Center(
              child: ColorLoader2(
                color1: theme.colorPrimary,
                color2: theme.colorCompanion,
                color3: theme.colorPrimary,
              ),
            ),
          ))else(Container()),
    ],));
  }

  _children(){
    var list = List<Widget>();

    list.add(SizedBox(height: 10,));

    list.add(Container(
      child: IList1(imageAsset: "assets/orders.png",
        text: strings.get(36),                      // "My Orders",
        textStyle: theme.text16bold,
        imageColor: theme.colorDefaultText,
      )
    ));

    list.add(SizedBox(height: 10,));

    _list(list);

    list.add(SizedBox(height: 200,));

    return list;
  }

  _list(List<Widget> list){
    var height = windowWidth*0.3;
    if (_data == null)
      return;
    for (var item in _data) {
      list.add(Container(
          child: ICard14FileCaching(
            radius: appSettings.radius,
            shadow: appSettings.shadow,
            color: theme.colorBackground,
            colorProgressBar: theme.colorPrimary,
            text: item.name,
            textStyle: theme.text16bold,
            text2: item.restaurant,
            textStyle2: theme.text14,
            text3: item.date,
            textStyle3: theme.text14,
            text4: (appSettings.rightSymbol == "false") ? "$_currency${item.total.toStringAsFixed(appSettings.symbolDigits)}" :
            "${item.total.toStringAsFixed(appSettings.symbolDigits)}$_currency",
            textStyle4: theme.text18boldPrimary,
            width: windowWidth,
            height: height,
            image: "$serverImages${item.image}",
            id: item.orderid,
            text6: item.statusName,
            textStyle6: theme.text16Companyon,
            text5: "${strings.get(195)}${item.orderid}", // Id #
            textStyle5: theme.text16bold,
            callback: _onItemClick,
        )));
      list.add(SizedBox(height: 10,));
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