//import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/model/server/changeStatus.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/server/arrived.dart';
import 'package:fooddelivery/model/server/getOrders.dart';
import 'package:fooddelivery/ui/main/home.dart';
import 'package:fooddelivery/ui/main/orders.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/iCard14FileCaching.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/widgets.dart';
import 'package:fooddelivery/model/utils.dart';
import 'package:fooddelivery/model/server/facturaOrder.dart';
import 'package:intl/intl.dart' as myintl;

class OrderDetailsScreen extends StatefulWidget {
  final Function(String) onBack;
  OrderDetailsScreen({Key key, this.onBack}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final formKey  = GlobalKey<FormState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  DateTime alert;

  final editControllerRfc = TextEditingController();
  final editControllerBusinessName = TextEditingController();
  final editControllerEmail = TextEditingController();

  _arrived(){
    _waits(true);
    curbSidePickupArrived(idOrder, account.token, _arrivedSuccess, _arrivedError);
  }

  _moreDetails(String orderDetails){
    for (var item in _data)
      if (item.orderid == orderDetails){
        openDialogOrderDetails(item); 
      } 
  }

  _arrivedSuccess(){
    _waits(false);
    for (var item in _data)
      if (item.orderid == idOrder){
        item.arrived = "true";
        setState(() {
        });
        return;
      }
  }

  _arrivedError(String err){
    _waits(false);
    openDialog("${strings.get(128)} $err"); // "Something went wrong. ",
  }

  bool _wait = false;

  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  double windowWidth = 0.0;
  double windowHeight = 0.0;

  @override
  void dispose() {
    route.disposeLast();
    super.dispose();
  }

  List<OrdersData> _data;
  String _currency;

  _success(List<OrdersData> data, String currency){
    _data = data;
    _currency = currency;
    setState(() {
    });
  }

  @override
  void initState() {
    ordersData.init(_success, _onError);
    account.addCallback(this.hashCode.toString(), callback);

    account.realoadOrder = false;
    super.initState();
    // _startLoading();
  }
  _startLoading() async {
    Future.delayed(const Duration(milliseconds: 200), () {
      _refreshIndicatorKey.currentState.show();
    });
  }

  callback(bool reg){
    setState(() {
    });
  }

  _onError(String err){
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;



    return Scaffold(
        backgroundColor: theme.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Stack(
          children: <Widget>[

            headerWidget(context, widget.onBack, Colors.black, strings.get(119)), // "My Orders",

            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+40),
              child: Container(
                child: RefreshIndicator(
                  displacement: 200,
                  key: _refreshIndicatorKey,
                  onRefresh: () async {
                    _data = [];
                    print('RefreshIndicator');
                    // _success(null, null);
                    await ordersData.init(_success, _onError);
                    await Future.delayed(Duration(seconds: 2));


                    setState(() { });
                  },

                  child: ListView(
                    padding: EdgeInsets.only(top: 0),
                    children: _body(),
                  ),
                ),
              ),
            ),

            if (_wait)
                Center(
                  child: ColorLoader2(
                    color1: Colors.yellow,
                    color2: theme.colorCompanion,
                    color3: theme.colorPrimary,
                  ),
                ),

            IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
              body: _dialogBody, backgroundColor: theme.colorBackground,),

          ],
        )
    ));
  }

  _body(){
    var list = List<Widget>();
    var height = windowWidth*0.40;

    list.add(SizedBox(height: 20,));
    int _status = 1;
    int _userrolUpdate = 0;
    print('account.realoadOrders ordersdetail: '+account.realoadOrder.toString());
    if(account.realoadOrder){
      print('realoadOrder now');
      print('account.realoadOrders: '+account.realoadOrder.toString());
      _data = [];
      ordersData.init(_success, _onError);
      // Future.delayed(Duration(seconds: 2));
      account.realoadOrder = false;

    }

    var colorStatus ;
    for (var item in _data)
      if (item.orderid == idOrder) {
        _status = int.parse(item.status);
        _userrolUpdate = int.parse(item.userrolUpdate);

        var curbsidePickupLbl ='';
        var colorStatus ;
        var imageStatus ;
        var imagePickup ;
        var imageEntregado ;
        var porEl ;
        if( item.curbsidePickup=='true') curbsidePickupLbl = strings.get(247);
        else curbsidePickupLbl = strings.get(311);

        imagePickup='';
        if( item.curbsidePickup=='true') imagePickup = 'assets/pickup.png';
        else imagePickup = 'assets/domicilio.png';
        colorStatus = theme.text14Status;
        if(_status==6)  colorStatus =theme.text14StatusCancelado;
        else if(_status==5)  colorStatus =theme.text14StatusEntregado;//si está entregado

        imageEntregado = '';
        if(_status==6)  imageEntregado = 'assets/cancelado.png';
        else if(_status==5)  imageEntregado = 'assets/Palomita.png';//si está entregado

        porEl='';
        if(_status==6){
          if(_userrolUpdate==4)porEl= strings.get(326);
          if(_userrolUpdate==2)porEl= strings.get(327);
        }
        
        imageStatus = '';
        if(_status==1)  imageStatus ='assets/recibido.png';
        if(_status==2)  imageStatus ='assets/preparando.png';
        if(_status==3)  imageStatus ='assets/listo.png';
        if(_status==4)  imageStatus ='assets/encamino.png';

        list.add(Container(
            child: ICard14FileCaching(
              radius: appSettings.radius,
              shadow: appSettings.shadow,
              colorProgressBar: theme.colorPrimary,
              heroId: idHeroes,
              color: theme.colorBackground,
              ticketCode: item.ticketCode,
              text: item.restaurant,
              textStyle: theme.text14Restaurante,
              text2: curbsidePickupLbl,
              textStyle2: theme.text14TipServ,
              text3: item.date,
              textStyle3: colorStatus,
              text4: (appSettings.rightSymbol == "false") ? "$_currency${item.total.toStringAsFixed(appSettings.symbolDigits)}" :
              "${item.total.toStringAsFixed(appSettings.symbolDigits)}$_currency",
              textStyle4: theme.text18boldPrimary,
              width: windowWidth,
              height: height,
              image: "$serverImages${item.image}",
              id: item.orderid,
              text6: item.statusName + porEl,
              text6Cancelado: item.status ,
              textStyle6: colorStatus,
              text5: "${strings.get(195)}${item.orderid}", // Id #
              textStyle5: theme.text13avenir,
              textStyle7: theme.text13avenirItalic,
              image1: imageStatus,
              image2: imagePickup,
              image3: imageEntregado,

            )));

        var maxStatus = _getMaxStatus(item.ordertimes);

        list.add(SizedBox(height: 35,));

        list.add(_itemTextPastOrder("${strings.get(120)}", _getStatusTime(item.ordertimes, 1), (maxStatus >= 1))); //  "Order received",
        list.add(_timer( item ));
        list.add(_divider());
        list.add(_itemTextPastOrder(
            "${strings.get(121)}", _getStatusTime(item.ordertimes, 2), (maxStatus >= 2))); // Order preparing",
        list.add(_divider());
        list.add(_itemTextPastOrder(
            "${strings.get(122)}", _getStatusTime(item.ordertimes, 3), (maxStatus >= 3))); // Order ready
        list.add(_divider());

        if (item.curbsidePickup != "true") {
          list.add(_itemTextPastOrder(
              "${strings.get(123)}", _getStatusTime(item.ordertimes, 4),
              (maxStatus >= 4))); // On the way
          list.add(_divider());
        }

        var status = _getStatusTime(item.ordertimes, 5);
        if (status.isEmpty)
          status = _getStatusTime(item.ordertimes, 10);
        list.add(_itemTextPastOrder(
            "${strings.get(124)}", status, (maxStatus >= 5))); // Delivery

        if (_status == 6) {                   // cancelled
          list.add(SizedBox(height: 20,));

          list.add(Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: <Widget>[
                  Icon(Icons.cancel, color: Colors.red, size: 30),
                  SizedBox(height: 10,),
                  Text(strings.get(196), style: theme.text18bold,),
                  Text(_getStatusTime(item.ordertimes, 6), style: theme.text14,),
                  //Text(rightText, style: theme.text14,),
                ],
              )));
          //list.add(_itemTextPastOrder("${strings.get(196)}", "", true)); // Canceled
        }else{
          if (item.curbsidePickup == "true"){

             var datenow = _getStatusTime(item.ordertimes, 12);
             if (datenow.isEmpty){
                DateTime now = new DateTime.now();
                datenow = myintl.DateFormat('yyyy-MM-dd – kk:mm').format(now);
             }
                  

            list.add(SizedBox(height: 25,));
            if (item.arrived == "true"){
              list.add(Container(
                alignment: Alignment.center,
                child: Text(strings.get(204) + ' ' + datenow.toString(), style: theme.text12bold,),
              )); // "Notification send...",
            }else
              list.add(_buttonIveArrived());
          }
        }
        list.add(SizedBox(height: 15,));
        list.add(_buttonMoreDetails(item.orderid));
        list.add(SizedBox(height: 5,));
        
        break;
      }

    return list;
  }
  _timer( item ){
    var _status = item.status;
    DateTime dateTimeCreatedAt = DateTime.parse(item.date);
    DateTime dateTimeNow = DateTime.now();
    DateTime dateTimeLimiteCancela = dateTimeCreatedAt.add(Duration( seconds: appSettings.tiempoConfirmaPedido));
    final differenceInSeconds = dateTimeLimiteCancela.difference(dateTimeNow).inSeconds;
    print('_status: $_status');
    print('date: $item.date');
    print('dateTimeLimiteCancela: $dateTimeLimiteCancela');
    print('differenceInSeconds: $differenceInSeconds');

    var today =  DateTime.now();
    if( _status== '1' ){
      if( !dateTimeLimiteCancela.isAfter(today)){
        print('Ya pasó la fecha o status no es 1 ');
        return Container();

      }else{
        print('Dentro de la fecha');
        alert = DateTime.now().add(Duration(seconds: differenceInSeconds));
        return Container(
          alignment: Alignment.center,
          child:     TimerBuilder.scheduled([alert],
              builder: (context) {
                // This function will be called once the alert time is reached
                var now = DateTime.now();
                var reached = now.compareTo(alert) >= 0;
                final textStyle = Theme.of(context).textTheme.title;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      !reached ?
                      TimerBuilder.periodic(
                          Duration(seconds: 1),
                          alignment: Duration.zero,
                          builder: (context) {
                            var now = DateTime.now();
                            var remaining = alert.difference(now);
                            return Container(
                                alignment: Alignment.center,
                                child: Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          RaisedButton(
                                            elevation: 0,
                                            color: theme.colorPrimary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),

                                            onPressed: () async {
                                              if (await confirm(
                                                context,
                                                title: Text(strings.get(320)),
                                                content: Text(strings.get(323)),
                                                textOK: Text(strings.get(321)),
                                                textCancel: Text(strings.get(322)),
                                              )) {
                                                _changeStatus( item, '6' );
                                              }
                                              return print('pressedCancel');
                                            },
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.cancel, color: Colors.white,),
                                                Text(' '+strings.get(320), style: theme.text14White2, ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(  formatDuration(remaining), style: textStyle,),
                                    ],
                                  ),
                                ));
                            // return Text(  formatDuration(remaining), style: textStyle,);
                          }
                      )
                          :
                      Column(),
                    ],
                  ),
                );
              }
          ),

        );

      }
    }else{
      return Container();
    }


    return Container(
      alignment: Alignment.center,
      child:     TimerBuilder.scheduled([alert],
          builder: (context) {
            // This function will be called once the alert time is reached
            var now = DateTime.now();
            var reached = now.compareTo(alert) >= 0;
            final textStyle = Theme.of(context).textTheme.title;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                 !reached ?
                  TimerBuilder.periodic(
                      Duration(seconds: 1),
                      alignment: Duration.zero,
                      builder: (context) {
                        var now = DateTime.now();
                        var remaining = alert.difference(now);
                        return Container(
                            alignment: Alignment.center,
                            child: Container(
                              child: Column(
                               children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      RaisedButton(
                                        elevation: 0,
                                        color: theme.colorPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        onPressed: ()  {
                                          // _moreDetails(orderDetails);
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.cancel, color: Colors.white,),
                                            Text(' '+strings.get(320), style: theme.text14White2, ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(  formatDuration(remaining), style: textStyle,),
                                ],
                              ),
                            ));
                        // return Text(  formatDuration(remaining), style: textStyle,);
                      }
                  )
                      :
                  Column(),
                ],
              ),
            );
          }
      ),

    );
  }
  _changeStatus(OrdersData _data, String status){
    changeStatus(_data.orderid, status.toString(),
            (){
          setState(() {
            _data.status = status;
          });
        },
        _openDialogError
    );
  }
  _buttonIveArrived(){
    return Container(
        alignment: Alignment.center,
        child: Container(
          height: 40,
          child: RaisedButton(
            elevation: 0,
            color: theme.colorPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onPressed: ()  {
              _arrived();
            },
            child: Text(strings.get(203),    // "I've arrived",
              overflow: TextOverflow.clip,
              style: theme.text14boldWhite,
            ),
          ),
        ));
  }

  _buttonMoreDetails(String orderDetails){
    return Container(
        alignment: Alignment.center,
        child: Container(
          height: 40,
          child: RaisedButton(
            elevation: 0,
            color: theme.colorPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onPressed: ()  {
              _moreDetails(orderDetails);
              // _refreshIndicatorKey.currentState.show();
            },
            child: Text(strings.get(302),    // "Ver más",
              overflow: TextOverflow.clip,
              style: theme.text14boldWhite,
            ),
          ),
        ));
  }

  _getStatusTime(List<OrderTimes> times, int status){
    for (var time in times)
      if (time.status == status)
        return time.createdAt;
    return "";
  }

  int _getMaxStatus(List<OrderTimes> times){
    var ret = 0;
    for (var time in times){
      if (time.status > ret && time.status != 6)
        ret = time.status;
    }
    return ret;
  }

  _itemTextPastOrder(String leftText, String rightText, bool _delivery){
    var _icon = Icon(Icons.check_circle, color: theme.colorPrimary, size: 30);
    if (!_delivery)
        _icon = Icon(Icons.history, color: theme.colorGrey, size: 30,);
      return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Row(
              children: <Widget>[
                _icon,
                SizedBox(width: 20,),
                Text(leftText, style: theme.text14,),
              ],
            ),
            Text(rightText, style: theme.text14,),
          ],
        ));
  }

  _divider(){
    var _align = Alignment.centerLeft;
    if (strings.direction == TextDirection.rtl)
      _align = Alignment.centerRight;
    return Align(
      alignment: _align,
      child: UnconstrainedBox(
        child: Container(
          margin: EdgeInsets.only(left: 35, right: 35),
          height: 30, width: 1, color: theme.colorDefaultText,
        ),
      ),
    );
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
    _dialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155),              // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: (){
              setState(() {
                _show = 0;
              });
            }
        ),
      ],
    );

    setState(() {
      _show = 1;
    });
  }

  openDialogOrderDetails(order) {
    _dialogBody = Column(
      children: [
        SizedBox(height: 5,),
        Text( strings.get(295), style: theme.text16Red,),
        SizedBox(height: 20,),

        Container(
              padding: EdgeInsets.only(left: 10,right: 10, bottom: 10,top: 10),
              width:  MediaQuery.of(context).size.width - 35,
              height: (MediaQuery.of(context).size.height / 2) - 90,

              decoration: BoxDecoration(
                border: Border(
                        top: BorderSide( //  <--- top side
                                color:  Colors.grey[300],
                                width:  1.0,
                              ),

                        ),
                      ),


               child: SingleChildScrollView(
                  child:Column(
                    children: _printItemOrderDetails(order),
              ),

            ),
        ),

        SizedBox(height: 5,),

        Container(
              padding: EdgeInsets.only(left: 10,right: 10, bottom: 10,top: 10),
              width:  MediaQuery.of(context).size.width - 35,
              decoration: BoxDecoration(
                border: Border(
                        top: BorderSide( //  <--- top side
                                color:  Colors.grey[300],
                                width:  1.0,
                              ),
                        bottom: BorderSide( //  <--- top side
                                color:  Colors.grey[300],
                                width:  1.0,
                              ),
                        ),
                      ),

              child: _bottomBar( order ),

        ),

        SizedBox(height: 25,),
        _facturarBottons(order),

      ],
    );

    setState(() {
      _show = 1;
    });
  }
  _bottomBar( order ){
    if(order.couponName!=''){
      var couponMsg='';
      // print('order.enviogratis': + order.enviogratis );
      if(order.enviogratis=='1')couponMsg=strings.get(315);
      else{

        if(order.couponInpercents=='1')couponMsg=order.couponDiscount+'% '+strings.get(316);
        else couponMsg=appSettings.currency+' '+order.couponDiscount+' '+strings.get(316);
      }


      return Column(
        children: [
          _textLineExpandedZero(strings.get(93), subTotal(order).toStringAsFixed(2)),//subtotal de productos
          _textLineExpandedZero(strings.get(95),  getTax(order).toStringAsFixed(2)),//impuestos de productos
          _textLineExpandedZero(strings.get(94), double.parse(order.fee).toStringAsFixed(2) ),//gastos de envío

          _textLineExpandedZero(strings.get(312),  getShoppingTaxes(order).toStringAsFixed(2)),//"Impuestos de envío",
          _textLineExpandedZero(strings.get(258)+' '+couponMsg,order.couponTotal.toString(), pcolor2: Colors.red),//cupones
          _textLineExpandedZero('Total', getTotal(order),pfontWeight:FontWeight.bold),
          // }
        ],
      );

    }else{
      return Column(
        children: [
          _textLineExpandedZero(strings.get(93), subTotal(order).toString()),//subtotal de productos
          _textLineExpandedZero(strings.get(95),  getTax(order).toStringAsFixed(2)),//impuestos de productos
          _textLineExpandedZero(strings.get(94), double.parse(order.fee).toStringAsFixed(2) ),//gastos de envío
          _textLineExpandedZero(strings.get(312),  getShoppingTaxes(order).toStringAsFixed(2)),//"Impuestos de envío",
          _textLineExpandedZero('Total', getTotal(order),pfontWeight:FontWeight.bold),
          // }
        ],
      );

    }

  }

  _facturarBottons(order) {
    int _status = int.parse(order.status);
    if( _status==5 ){//si está entregado se factura
      return Container(
          width: windowWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: windowWidth/2-45,
                  child: IButton3(
                      color: theme.colorPrimary,
                      text: strings.get(288),                  // facturar
                      textStyle: theme.text14boldWhite,
                      pressButton: (){
                        openDialogOrderDetailsFactura( order );
                      }

                  )),
              SizedBox(width: 10,),
              Container(
                  width: windowWidth/2-45,
                  child: IButton3(
                      color: theme.colorPrimary,
                      text: strings.get(155),              // Cancel
                      textStyle: theme.text14boldWhite,
                      pressButton: (){
                        setState(() {
                          _show = 0;
                        });
                      }
                  )),
            ],
          ));

    }else{//si está cancelado o sin entregar no se factura
      return Container(
          width: windowWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                  width: windowWidth/2-45,
                  child: IButton3(
                      color: theme.colorPrimary,
                      text: strings.get(155),              // Cancel
                      textStyle: theme.text14boldWhite,
                      pressButton: (){
                        setState(() {
                          _show = 0;
                        });
                      }
                  )),
            ],
          ));

    }
  }
  openDialogOrderDetailsFactura(order) {
    _dialogBody = Column(
      children: [
        SizedBox(height: 5,),
        Text( strings.get(288) , style: theme.text16Red,),
        SizedBox(height: 20,),

        Container(
            padding: EdgeInsets.only(left: 10,right: 10, bottom: 10,top: 10),
            width:  MediaQuery.of(context).size.width - 35,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide( //  <--- top side
                  color:  Colors.grey[300],
                  width:  1.0,
                ),
                bottom: BorderSide( //  <--- top side
                  color:  Colors.grey[300],
                  width:  1.0,
                ),
              ),
            ),

            child: Column(
              children: _printItemOrderDetailsFactura(order),

            )
        ),

        SizedBox(height: 5,),

        _formFactura( order ),

        SizedBox(height: 25,),
        Container(
            width: windowWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: windowWidth/2-45,
                    child: IButton3(
                        color: theme.colorPrimary,
                        text: strings.get(295)+'s',                  // detalles de pago
                        textStyle: theme.text14boldWhite,
                        pressButton: (){
                          openDialogOrderDetails( order );
                        }

                    )),
                SizedBox(width: 10,),
                Container(
                    width: windowWidth/2-45,
                    child: IButton3(
                        color: theme.colorPrimary,
                        text: strings.get(155),              // Cancel
                        textStyle: theme.text14boldWhite,
                        pressButton: (){
                          setState(() {
                            _show = 0;
                          });
                        }
                    )),
              ],
            )),

      ],
    );

    setState(() {
      _show = 1;
    });
  }
  List<Widget> _printItemOrderDetails(order)
  {
    String delivery = strings.get(247);
      if(order.curbsidePickup.toString() == 'false')
          delivery = order.address;
       // print( jsonEncode(order) );

        List<Widget> list = [ 
                  _textLine('Ticket:',order.ticketCode),
                  _textLine(strings.get(301)+':',order.method),
                  _textLine(strings.get(66)+':',delivery),
                  _textLine(strings.get(300)+':',order.date),
                  SizedBox(height:20),
                ]; 

        for (var item  in order.orderdetails) 
        {
            double price = item.foodprice;
            int count = item.count;
            String food = item.food;
            if(item.foodprice  == 0.0){
              price = double.parse(item.extrasprice);
              count = int.parse(item.extrascount);
              food = '  -Extra '+ item.extras;
            } 
           
            double total = count * price;
            String leftText = food + ' (' + count.toString() + ' x \$' + price.toString() + ')'; 
            list.add(_textLineExpanded(leftText,'\$'+total.toString()));
        }

        return list;
  }
  List<Widget> _printItemOrderDetailsFactura(order)
  {
    String delivery = strings.get(247);
    if(order.curbsidePickup.toString() == 'false')
      delivery = order.address;
    // print( jsonEncode(order) );

    List<Widget> list = [
      _textLine('Ticket:',order.ticketCode),
      _textLine(strings.get(301)+':',order.method),
      _textLine(strings.get(66)+':',delivery),
      _textLine(strings.get(300)+':',order.date),
      SizedBox(height:5),
      _textLineFecha(strings.get(299)+':',order.fecha_lim_fac),
      SizedBox(height:5),
      _textLine('Total', '\$'+getTotal(order) ),
      SizedBox(height:10),
    ];



    return list;
  }
  _formFactura( order ){
    String dropdownValue = 'One';
    List<String> _locations = ['A', 'B', 'C', 'D'];
    String _selected = '';

    editControllerRfc.text    = account.rfc;
    editControllerEmail.text  = account.email;
    editControllerBusinessName.text = account.businessName;

    if(order.facturada.toString()=='0' || order.facturada.toString()=='null') {
      var fechaLimFac ;
      var today =  DateTime.now();
      if( order.fecha_lim_fac.toString()!='null' ) fechaLimFac = DateTime.parse(order.fecha_lim_fac);

     //  fechaLimFac = DateTime.parse('2021-03-11 11:49:02');
      //print('fechaLimFac:');
     // print(fechaLimFac);
     // print('today:');
     // print(today);
      if( fechaLimFac.isAfter(today)){
        print('fecha NO vencida de factura');
        return   Container(
          width: double.maxFinite,
          height: (MediaQuery.of(context).size.height / 2) - 50,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20,),

                  Text("${strings.get(289)}:", style: theme.text12bold,),
                  // RFC
                  _edit(editControllerRfc, strings.get(289), false, 'rfc'),


                  SizedBox(height: 20,),
                  Text("${strings.get(290)}:", style: theme.text12bold,),
                  // Razon Social
                  _edit(editControllerBusinessName, strings.get(290), false,
                      'notempty'),

                  SizedBox(height: 20,),

                  Text("${strings.get(289)}:", style: theme.text12bold,),
                  // RFC
                  new DropdownButton<String>(
                    items: <String>[ 'G01', 'P01' ].map((String value) {
                      if(value=='G01')_selected='G01- Gastos en General';
                      if(value=='P01')_selected='P01- Por definor';
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(_selected),
                      );
                    }).toList(),
                    value:'G01',
                    isExpanded: true,
                    onChanged: (_) {},
                  ),


                  SizedBox(height: 20,),
                  Text("${strings.get(159)}:", style: theme.text12bold,),
                  // Razon Social
                  if (account.typeReg == "email")
                    _edit(
                        editControllerEmail, strings.get(160), false, 'email'),
                  //  "Enter your User E-mail",
                  //  "Enter your User Phone",
                  SizedBox(height: 30,),

                  Container(
                      width: windowWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: windowWidth / 2 - 45,
                              child: IButton3(
                                  color: theme.colorPrimary,
                                  text: strings.get(296), // Change
                                  textStyle: theme.text14boldWhite,
                                  pressButton: () {
                                    if ( !formKey.currentState.validate() ) return;
                                    formKey.currentState.save();

                                    setState(() {
                                     //_show = 0;
                                    });
                                    //_openDiaSendSAT();
                                    _callbackFacturar( order );

                                  }
                              )),

                        ],
                      )),

                ],
              ),
            ),
          ),
        );

      }
      else{
        print('fecha vencida de factura');
        return Container(
          width: double.maxFinite,
          height: (MediaQuery
              .of(context)
              .size
              .height / 3) - 50,
          margin: EdgeInsets.only(left: 10, right: 10),

          child: SingleChildScrollView(
            child:Column(
              children: [
                SizedBox(height: 20,),
                Text('¡Oops!', style: TextStyle(fontSize: 32,color: Colors.black, fontWeight: FontWeight.w600),),
                SizedBox(height: 20,),
                Text(strings.get(303), style: theme.text14bold,),//No es posible generar su factura

                SizedBox(height: 5,),
                Text(strings.get(304), style: theme.text14boldPimary,),//La fecha límite ha vencido



              ],
            ),

          ),




        );

      }

    }else{

        return Container(
          width: double.maxFinite,
          height: (MediaQuery
              .of(context)
              .size
              .height / 3) - 50,
          margin: EdgeInsets.only(left: 10, right: 10),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20,),

                Row(
                  children: <Widget>[

                    Icon( FontAwesomeIcons.solidCheckCircle, color: Colors.lightGreen,),//Se ha generado su factura exitosamente
                    Text(strings.get(307), style: theme.text12bold),
                  ],
                ),
                SizedBox(height: 40,),
                Row(
                  children: <Widget>[

                    Container(
                       // width: windowWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: windowWidth/2-45,
                                child: socialMediaBtn(appSettings.twitterText, new Image.asset('assets/xml.png',color: Colors.brown,))),
                            SizedBox(width: 10,),
                            Container(
                                width: windowWidth/2-45,
                                child: socialMediaBtn(appSettings.twitterText, Image.asset('assets/pdf.png',color: Colors.red,))),
                          ],
                        )),
                  ],
                ),



              ],
            ),

          ),




        );

      }

  }
  facturasBtn(String link,var icon)
  {
    return IconButton(
      // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
        iconSize: 30,
        icon: icon,
        onPressed: () {
          //launch(link);
        }
    );

  }
  _callbackFacturar( order ){
    _dialogBody = Column(
      children: [
        Text(strings.get(306), style: theme.text14boldPimary,),//Enviando los datos al SAT
        SizedBox(height: 20,),
        Image.asset(
          "assets/load.gif",
          //color: Colors.red,
        ),
        SizedBox(height: 20,),


      ],
    );
    print("factura");
    print(" orden: ${order.orderid},E-mail: ${editControllerEmail.text},  RFC: ${editControllerRfc.text}, BusinessName: ${editControllerBusinessName.text}");
    facturaOrder(order.orderid, account.token, editControllerRfc.text, editControllerBusinessName.text, 'G01',editControllerEmail.text,
        _successFactura, _errorFactura);
  }
  _errorFactura(String error){
    setState(() {
      //_show = 0;
    });

    _openDialogError(error); // "Something went wrong. ",
  }
  _successFactura( String txt ){
    setState(() {
      //_show = 0;
    });
   _dialogBody = Column(
      children: [
        Row(
          children: <Widget>[
            Icon( FontAwesomeIcons.solidCheckCircle, color: Colors.lightGreen,),//Se ha generado su factura exitosamente
           Text(strings.get(307), style: theme.text12bold),
          ],
        ),
        Text(txt, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(305),              // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: (){
              setState(() {
                _show = 0;
              });
            }
        ),
      ],
    );





    print(' _successFactura ');


   // setState(() {
   // });
  }
  _openDialogError(String _text) {
    _dialogBody = Column(
      children: [
        Row(
          children: <Widget>[
            Icon( FontAwesomeIcons.timesCircle, color: Colors.red,),//Hemos tenido un error al generar sus facturas
            Text("  "+strings.get(308), style: theme.text12bold),
          ],
        ),
        SizedBox(height: 5,),
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(305),              // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: (){
              setState(() {
                _show = 0;
              });
            }
        ),
      ],
    );
  }
  _edit(TextEditingController _controller, String _hint, bool _obscure, String _type){
    return Container(
        child: Directionality(
          textDirection: strings.direction,
          child: TextFormField(
            controller: _controller,
            onChanged: (String value) async {

            },
            validator: (value) => validators(value,_type),
            cursorColor: theme.colorDefaultText,
            style: theme.text14,
            cursorWidth: 1,
            obscureText: _obscure,
            maxLines: 1,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: _hint,
                hintStyle: theme.text14
            ),
          ),
        ));
  }
  double subTotal(order)
  {
      double subtotal = 0.0; 

      for (var item  in order.orderdetails) 
        {
            double price = item.foodprecioUnit;
            int count = item.count; 
            if(item.foodprice  == 0.0){
              price = double.parse(item.extrasprecioUnit);
              count = int.parse(item.extrascount); 
            } 
           
            double total = count * price;
            subtotal = subtotal + total;
        }

      return subtotal;
  }

  double getTax(order)
  {
    double subtotaltax = 0.0;

    for (var item  in order.orderdetails)
    {
      double price = item.foodtaxFood;
      int count = item.count;
      if(item.foodprice  == 0.0){
        price = double.parse(item.extrastaxFood);
        count = int.parse(item.extrascount);
      }

      double total = count * price;
      subtotaltax = subtotaltax + total;
    }

    return subtotaltax;
  }
  double getShoppingTaxes( order ){
    // if (_percentage == '1') {
    double taxdelivery = double.parse(order.taxDelivery) ;
    taxdelivery = double.parse(order.fee) * ( taxdelivery /100);
    //   return total;
    // }else
    return taxdelivery;
  }

  String getTotal(order)
  {
     double total = order.total;

     return  total.toStringAsFixed(appSettings.symbolDigits);
  }
 

  Widget _textLine(text1,text2){

    if(text2.toString().isEmpty)
      text2 = '-';

    return Row(
      children: [
        Text(text1,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        SizedBox(width:10),
        Text(text2 ),
        // AutoSizeText(
        //   text2,
        // ),
      ],
    );
  }
  Widget _textLineFecha(text1,text2){
    var fechaLimFac ;
    var today =  DateTime.now();
    if( text2.toString()!='null' ) fechaLimFac = DateTime.parse(text2);

    if( fechaLimFac.isAfter(today)){
      return Row(
        children: [
          Text(text1,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          SizedBox(width:10),
          Text(text2),
        ],
      );
    }else{

      return Row(
        children: [
          Text(text1,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          SizedBox(width:10),
          Text(text2,style: theme.text14primary),
        ],
      );
    }




  }

  Widget _textLineExpanded(text1,text2,{pfontWeight = FontWeight.normal, pcolor1 = Colors.black,pcolor2 = Colors.black}){

    if(text2.toString().isEmpty)
      text2 = '-';

    return Padding(
      padding: const EdgeInsets.only(top:2.0),
      child: Row(
        children: [ 
          Text(text1,style: TextStyle(color: pcolor1, fontWeight: pfontWeight),),
          Expanded(child: SizedBox(width:10),),
          Text(text2,style: TextStyle(color: pcolor2, fontWeight: pfontWeight),),
        ],
      ),
    );
  }
  Widget _textLineExpandedZero(
                              text1,
                                text2 ,{pfontWeight = FontWeight.normal, pcolor1 = Colors.black,pcolor2 = Colors.black}){

  //  if(text2.toString().isEmpty || double.parse( text2 )==0)
 //     text2 = '-';
  //  else
  //    text2 = '\$' +text2;
    //if(  int.parse( order.fee )==0 ){
    if(text2.toString().isEmpty || double.parse( text2 )==0){

      return Padding(
        padding: const EdgeInsets.only(top:2.0),

      );
    }else{
      text2 = '\$' +text2;
      return Padding(
        padding: const EdgeInsets.only(top:2.0),
        child: Row(
          children: [
            Text(text1,style: TextStyle(color: pcolor1, fontWeight: pfontWeight),),
            Expanded(child: SizedBox(width:10),),
            Text(text2,style: TextStyle(color: pcolor2, fontWeight: pfontWeight),),
          ],
        ),
      );
    }
  }
  String formatDuration(Duration d) {
    String f(int n) {
      return n.toString().padLeft(2, '0');
    }
    // We want to round up the remaining time to the nearest second
    d += Duration(microseconds: 999999);
    return "${f(d.inMinutes)}:${f(d.inSeconds%60)}";
  }

}

