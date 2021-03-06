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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
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
      // _waits(true);
      ordersData.init(_success, _onError);
    }else{
      _waits(false);
      _data = [];
    }
    account.addCallback(this.hashCode.toString(), callback);
    account.realoadOrders = false;
    super.initState();
    _startLoading();
  }
  _startLoading() async {
    Future.delayed(const Duration(milliseconds: 1), () {
      _refreshIndicatorKey.currentState.show();
    });
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

        if(account.realoadOrders){
          print('account.realoadOrders: '+account.realoadOrders.toString());
          _data = [];
          ordersData.init(_success, _onError);
          // Future.delayed(Duration(seconds: 2));
          account.realoadOrders = false;

        }
        print('account.realoadOrders: '+account.realoadOrders.toString());
        _body = Container(
            margin: EdgeInsets.only(top: MediaQuery
                .of(context)
                .padding
                .top + 50),
            child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  displacement: 200,
                 onRefresh: () async {
                   _data = [];
                   print('RefreshIndicator');
                   await ordersData.init(_success, _onError);
                   await Future.delayed(Duration(seconds: 2));


                     setState(() { });
                  },
                    // onRefresh: () async {
                    //   _data = [];
                    //   await Future.delayed(Duration(seconds: 2), () {
                    //      ordersData.init(_success, _onError);
                    //     // do something
                    //     //getData();
                    //   });
                    //   setState(() { });
                    // },
                          child: ListView(
                  padding: EdgeInsets.only(top: 0, left: 10, right: 10),
                  shrinkWrap: true,
                  children: _children(),
              ),
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
                // color1: theme.colorPrimary,
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
    var height = windowWidth*0.40;
    int _status = 1;
    int _userrolUpdate = 0;
    var curbsidePickupLbl ='';
    var colorStatus ;
    var imageStatus ;
    var imagePickup ;
    var imageEntregado ;
    var porEl ;
    if (_data == null)
      return;
    for (var item in _data) {
      //print('curbsidePickup:');
      //print(item.orderid+': ' +item.curbsidePickup);
      _status = int.parse(item.status);
      _userrolUpdate = int.parse(item.userrolUpdate);
      //print(item.orderid.toString()+'_status: '+_status.toString());

      if( item.curbsidePickup=='true') curbsidePickupLbl = strings.get(247);
      else curbsidePickupLbl = strings.get(311);

      imagePickup='';
      if( item.curbsidePickup=='true') imagePickup = 'assets/pickup.png';
      else imagePickup = 'assets/domicilio.png';
      colorStatus = theme.text14Status;
      if(_status==6)  colorStatus =theme.text14StatusCancelado;
      else if(_status==5)  colorStatus =theme.text14StatusEntregado;//si est?? entregado

      porEl='';
      if(_status==6){
        if(_userrolUpdate==4)porEl= strings.get(326);
        if(_userrolUpdate==2)porEl= strings.get(327);
      }

      imageEntregado = '';
      if(_status==6)  imageEntregado = 'assets/cancelado.png';
      else if(_status==5)  imageEntregado = 'assets/Palomita.png';//si est?? entregado

      imageStatus = '';
      if(_status==1)  imageStatus ='assets/recibido.png';
      if(_status==2)  imageStatus ='assets/preparando.png';
      if(_status==3)  imageStatus ='assets/listo.png';
      if(_status==4)  imageStatus ='assets/encamino.png';


      list.add(Container(
          child: ICard14FileCaching(
            radius: appSettings.radius,
            shadow: appSettings.shadow,
            color: theme.colorBackground,
            colorProgressBar: theme.colorPrimary,
            ticketCode: item.ticketCode,
            text: item.restaurant,
            textStyle: theme.text14Restaurante,
            text2: curbsidePickupLbl,
            textStyle2: theme.text14TipServ,
            text3: item.date,
            textStyle3: colorStatus,
            text4: (appSettings.rightSymbol == "false") ? "$_currency${item.total.toStringAsFixed(appSettings.symbolDigits)}" :
            "${item.total.toStringAsFixed(appSettings.symbolDigits)}$_currency",
            textStyle4: theme.text18total,
            width: windowWidth,
            height: height,
            image: "$serverImages${item.image}",
            id: item.orderid,
            text6: item.statusName + porEl ,
            text6Cancelado: item.status ,
            textStyle6: colorStatus,
            text5: "${strings.get(195)}${item.orderid}", // Id #
            textStyle5: theme.text13avenir,
            textStyle7: theme.text13avenirItalic,
            image1: imageStatus,
            image2: imagePickup,
            image3: imageEntregado,
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