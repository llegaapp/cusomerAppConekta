import 'package:flutter/material.dart';
import 'package:fooddelivery/config/api.dart';
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

class OrderDetailsScreen extends StatefulWidget {
  final Function(String) onBack;
  OrderDetailsScreen({Key key, this.onBack}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

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
    super.initState();
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
                child: ListView(
                  padding: EdgeInsets.only(top: 0),
                  children: _body(),
                ),
              ),
            ),

            if (_wait)
                Center(
                  child: ColorLoader2(
                    color1: theme.colorPrimary,
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
    var height = windowWidth*0.35;

    list.add(SizedBox(height: 20,));
    int _status = 1;

    for (var item in _data)
      if (item.orderid == idOrder) {
        _status = int.parse(item.status);
        list.add(Container(
            child: ICard14FileCaching(
              radius: appSettings.radius,
              shadow: appSettings.shadow,
              colorProgressBar: theme.colorPrimary,
              heroId: idHeroes,
              color: theme.colorBackground,
              ticketCode: item.ticketCode,
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

            )));

        var maxStatus = _getMaxStatus(item.ordertimes);

        list.add(SizedBox(height: 35,));

        list.add(_itemTextPastOrder("${strings.get(120)}", _getStatusTime(item.ordertimes, 1), (maxStatus >= 1))); //  "Order received",
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
            list.add(SizedBox(height: 25,));
            if (item.arrived == "true"){
              list.add(Container(
                alignment: Alignment.center,
                child: Text(strings.get(204), style: theme.text18bold,),
              )); // "Notification send...",
            }else
              list.add(_buttonIveArrived());
          }
        }
        list.add(SizedBox(height: 5,));
        list.add(_buttonMoreDetails(item.orderid));
        list.add(SizedBox(height: 5,));
        
        break;
      }

    return list;
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
            },
            child: Text('Mas detalles',    // "I've arrived",
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
        Text('Detalles de Pago', style: theme.text16Red,),
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
                       
                        ),
                      ),

              child: Column(
                children: _printItemOrderDetails(order),
                
              )
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

              child: Column(
                children: [
                  _textLineExpanded('Subtotal de Productos','\$' + subTotal(order).toString()),
                  _textLineExpanded('Gastos de Envío','\$' +order.fee.toString()),
                  _textLineExpanded('I:V.A', '\$' + getTax(order)),
                  _textLineExpanded('Cupón','\$' + order.couponTotal.toString()),
                  _textLineExpanded('Total',"\$" + getTotal(order),pfontWeight:FontWeight.bold),
                ],
              )
        ),

        SizedBox(height: 25,),
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

  List<Widget> _printItemOrderDetails(order)
  {
        List<Widget> list = [ 
                  _textLine('Ticket:',order.ticketCode),
                  _textLine('Método Pago:','PayPal'),
                  _textLine('Entrega:',order.address),
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

  double subTotal(order)
  {
      double subtotal = 0.0; 

      for (var item  in order.orderdetails) 
        {
            double price = item.foodprice;
            int count = item.count; 
            if(item.foodprice  == 0.0){
              price = double.parse(item.extrasprice);
              count = int.parse(item.extrascount); 
            } 
           
            double total = count * price;
            subtotal = subtotal + total;
        }

      return subtotal;
  }

  String getTax(order)
  {
    int tax = int.parse(order.tax);
    double ptotal = subTotal(order) + double.parse(order.fee);
    double total = ptotal * (tax/100); 
    return  total.toStringAsFixed(appSettings.symbolDigits);
  }

  String getTotal(order)
  {
     double total = order.total - order.couponTotal;

     return  total.toStringAsFixed(appSettings.symbolDigits);
  }
 

  Widget _textLine(text1,text2){

    if(text2.toString().isEmpty)
      text2 = '-';

    return Row(
      children: [
        Text(text1,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        SizedBox(width:10),
        Text(text2),
      ],
    );
  }

  Widget _textLineExpanded(text1,text2,{pfontWeight = FontWeight.normal}){

    if(text2.toString().isEmpty)
      text2 = '-';

    return Padding(
      padding: const EdgeInsets.only(top:2.0),
      child: Row(
        children: [ 
          Text(text1,style: TextStyle(color: Colors.black, fontWeight: pfontWeight),),
          Expanded(child: SizedBox(width:10),),
          Text(text2),
        ],
      ),
    );
  }

}

