import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/server/addressGet.dart';
import 'package:fooddelivery/ui/main/Delivery/payments.dart';
import 'address.dart';
import 'package:fooddelivery/model/pref.dart';
import 'package:fooddelivery/model/server/wallet.dart';
import 'package:fooddelivery/model/topRestourants.dart';
import 'package:fooddelivery/ui/main/home.dart';
import 'package:fooddelivery/ui/main/mainscreen.dart';
import 'package:fooddelivery/ui/main/vehicle.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/iCard27.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/iinkwell.dart';
import 'package:fooddelivery/widget/iinputField2.dart';

String couponName = "";
var walletId = "";

class DeliveryScreen extends StatefulWidget {
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen>
    with SingleTickerProviderStateMixin {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  bool _deliveryAddressInit = false;
  String _deliveryAddress = "";
  double _deliveryLatitude = 0;
  double _deliveryLongitude = 0;

  _pressContinueButton() async {
    if (stage == 2) {
      pay(_currVal, context, _waits, editControllerPhone.text, _openDialog, openDialog);
    }
    if (stage == 3)
      Navigator.pop(context);
    if (stage == 1) {
      print("User pressed \"Continue\" button");
      print("phone: ${editControllerPhone.text}, comments: ${editControllerComments.text}");
      print("User pressed \"Next\" button");

      if (!_deliveryAddressInit && !_checkBoxValue)
        return openDialog(strings.get(184)); // "Select Address",
      if (editControllerPhone.text.isEmpty)
        return openDialog(strings.get(185)); // "Enter Phone number",
      // if (editControllerComments.text.isEmpty)
      //   return openDialog(strings.get(186)); // "Enter Comments",
      if (_checkBoxValue && _vehicleType.isEmpty && !_checkBoxValue2)
        return openDialog(strings.get(248)); // "Select Vehicle Type",
      stage = 2;
      pref.set(Pref.deliveryPhone, editControllerPhone.text);
      var text = "";
      if (_timeArrivedInit)
        text = "${strings.get(224)}$_timeArrived";
      if (_checkBoxValue && !_checkBoxValue2)
        text = "$text - $_vehicleType";
      if (_checkBoxValue && _checkBoxValue2)
        text = "$text - ${strings.get(247)}";  // "Pickup from restaurant",
      if (_couponEnable)
        text = "$text - ${strings.get(258)}: $couponName"; // coupons
      text = "$text - ${strings.get(85)}: ${editControllerComments.text}"; // comments
      pref.set(Pref.deliveryHint, text);
      pref.set(Pref.deliveryAddress, editControllerAddress.text);
    }

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

  _onBackClick(){
    if (stage == 1 || stage == 3)
      return Navigator.pop(context);
    if (stage == 2)
      stage = 1;
    setState(() {

    });
  }

  _openDialog(){
    walletSetId(account.token, walletId, basket.orderid, (){}, (String _){});
    _waits(false);
    stage = 3;
    setState(() {
    });
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  int stage = 1;
  var windowWidth;
  var windowHeight;
  final editControllerComments = TextEditingController();
  final editControllerPhone = TextEditingController();
  final editControllerAddress = TextEditingController();
  final editControllerCoupon = TextEditingController();
  var _areakm = -1;
  var restLat = 0.0;
  var restLng = 0.0;
  var _distanceToMax = false;
  var _vehicleType = "";


  _onError(String error) {
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  @override
  void initState() {
    pref.set(Pref.deliveryCurbsidePickup, "false");

    getAddress(account.token, (List<AddressData> address) {
      for (var _data in address)
        if (_data.defaultAddress == "true"){
          _deliveryAddressInit = true;
          _deliveryAddress = _data.text;
          _deliveryLatitude = _data.lat;
          _deliveryLongitude = _data.lng;
          editControllerAddress.text = _deliveryAddress;
          editControllerAddress.selection = TextSelection.fromPosition(
            TextPosition(offset: editControllerAddress.text.length),
          );
          for (var rest in nearYourRestaurants)
            if (rest.id == basket.restaurant) {
              _areakm = rest.area;
              restLat = rest.lat;
              restLng = rest.lng;
            }
          _initDistance();
          setState(() {});
        }
    }, _onError);

    // if (pref.get(Pref.deliveryAddressInit) == "true"){
    //   _deliveryAddressInit = true;
    //   _deliveryAddress = pref.get(Pref.deliveryAddress);
    //   _deliveryLatitude = double.parse(pref.get(Pref.deliveryLatitude));
    //   _deliveryLongitude = double.parse(pref.get(Pref.deliveryLongitude));
    //   editControllerAddress.text = _deliveryAddress;
    //   editControllerAddress.selection = TextSelection.fromPosition(
    //     TextPosition(offset: editControllerAddress.text.length),
    //   );
    // }

    // _initDistance();

    editControllerPhone.text = pref.get(Pref.deliveryPhone);
    super.initState();
  }

  double distance = 0;

  _initDistance() async {
    if (_areakm != -1){
      distance = await homeScreen.location.distanceBetween(_deliveryLatitude, _deliveryLongitude, restLat, restLng);
      if (distance == -1)
        return;
      if (appSettings.distanceUnit == "km")
        distance = distance/1000;
      else
        distance = distance/1609.34;

      if (distance > _areakm)
        _distanceToMax = true;
      else
        _distanceToMax = false;
      setState(() {
      });
    }
  }

  @override
  void dispose() {
    route.disposeLast();
    editControllerComments.dispose();
    editControllerPhone.dispose();
    editControllerAddress.dispose();
    editControllerCoupon.dispose();
    super.dispose();
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

          Align(
              child: Container (
                child: ListView(
                  children: _getList(),
                ),)
          ),

          Container(
            alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10),
              child: IInkWell(child: _iconBackWidget(), onPress: _onBackClick,)
          ),

          if (_wait)
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
              ),

          IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
            body: _dialogBody, backgroundColor: theme.colorBackground,),

        ],
      ),
    ));
  }

  _iconBackWidget(){
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
      child: UnconstrainedBox(
          child: Container(
              height: 25,
              width: 25,
              child: Image.asset("assets/back.png",
                fit: BoxFit.contain, color: theme.colorDefaultText,
              )
          )),
    );
  }

  _getList(){
    var list = List<Widget>();

    list.add(SizedBox(height: 15,));
    list.add(ICard27(
      colorActive: theme.colorPrimary,
      colorInactive: theme.colorDefaultText.withOpacity(0.5),
      stage: stage,
    ));
    list.add(SizedBox(height: 15,));
    list.add(Container(height: 1, color: theme.colorGrey,));
    list.add(SizedBox(height: 30,));

    if (stage == 1) {
      _body(list);
      list.add(SizedBox(height: 50,));
      if (_checkBoxValue)
        list.add(_button());
      else
        if (!_distanceToMax)
          list.add(_button());

      list.add(SizedBox(height: 150,));
    }

    if (stage == 2) {
      list.add(SizedBox(height: 20,));
      list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: _row(strings.get(188), strings.get(194))    //  "Payment" - "All transactions are secure and encrypted.",
      ));
      list.add(SizedBox(height: 20,));

      if (homeScreen.mainWindowData.payments.cacheEnable == "true") {
        list.add(_item("assets/payment1.png", 1, strings.get(189))); // cache on delivery
        list.add(SizedBox(height: 10,));
      }
      if (appSettings.walletEnable == "true") {
        list.add(_item("assets/payment6.png", 6, "${strings.get(10)} ${strings.get(206)}")); // "Wallet",
        list.add(SizedBox(height: 10,));
      }
      if (homeScreen.mainWindowData.payments.payPalEnable == "true") {
        list.add(_item("assets/payment5.png", 5, strings.get(249))); // payPal
        list.add(SizedBox(height: 10,));
      }
      if (homeScreen.mainWindowData.payments.payStackEnable == "true") {
        list.add(_item("assets/payment7.png", 7, strings.get(251))); // payStack
        list.add(SizedBox(height: 10,));
      }
      if (homeScreen.mainWindowData.payments.stripeEnable == "true") {
        list.add(_item("assets/payment2.png", 4, strings.get(192))); // "Visa, Mastercard",
        list.add(SizedBox(height: 10,));
      }
      if (homeScreen.mainWindowData.payments.razEnable == "true") {
        list.add(_item("assets/payment4.png", 3, strings.get(191))); // razorpay
        list.add(SizedBox(height: 10,));
      }
      if (homeScreen.mainWindowData.payments.yandexKassaEnable == "true") {
        list.add(_item("assets/payment8.png", 8, strings.get(265))); // Yandex kassa
        list.add(SizedBox(height: 10,));
      }
      if (homeScreen.mainWindowData.payments.instamojoEnable == "true") {
        list.add(_item("assets/payment9.png", 9, strings.get(266))); // "Instamojo",
        list.add(SizedBox(height: 10,));
      }
      list.add(SizedBox(height: 20,));
      list.add(_button());
      list.add(SizedBox(height: 150,));
    }

    if (stage == 3)
      _finishWidget(list);

    return list;
  }

  _row(String text1, String text2){
    return Container(
        child: Row(
          children: [
            Icon(Icons.done, color: Colors.green, size: 20,),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text1, style: theme.text14bold,),
                SizedBox(height: 5,),
                Container(
                  width: windowWidth -100,
                  child: Text(text2, style: theme.text14,))
              ],
            )
          ],
        )
    );
  }

  _row2(String text1, String text2){
    return InkWell(
        onTap: () {
          openDialogTime();
    },
    child: Container(
        child: Row(
          children: [
            Icon(Icons.done, color: Colors.green, size: 20,),
            SizedBox(width: 20,),
            Expanded(child: Text(text1, style: theme.text14bold,)),
            Text(text2, style: theme.text14,)
          ],
        )
    ));
  }

  var _currVal = 1;

  _item(String image, int index, String text){
    var _align = Alignment.centerLeft;
    if (strings.direction == TextDirection.rtl)
      _align = Alignment.centerRight;

    return Container(
        color: theme.colorBackgroundGray,
        child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Expanded(child: Container(
                    child: RadioListTile(
                      activeColor: theme.colorCompanion,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: FittedBox(
                            fit: BoxFit.scaleDown,
                              child: Text(text, style: theme.text14,),
                          )),
                          Container(
                              alignment: _align,
                              child: UnconstrainedBox(
                                  child: Container(
                                      //height: windowWidth*0.1,
                                      width: windowWidth*0.2,
                                      child: Container(
                                        child: Image.asset(image,
                                            fit: BoxFit.contain
                                        ),
                                      )))
                          )
                        ],
                      ),
                      groupValue: _currVal,

                      value: index,
                      onChanged: (val) {
                        setState(() {
                          _currVal = val;
                          //_itemSelect();
                        });
                      },
                    ))),

              ],
            )


        )
    );
  }

  bool _checkBoxValue = false;
  bool _checkBoxValue2 = false;

  _body(List<Widget> list){
    for (var rest in nearYourRestaurants)
      if (rest.id == basket.restaurant) {
        list.add(Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(children: [
          Text("${strings.get(267)}: ", style: theme.text14bold),       // "Restaurant", name
          Expanded(child: Text("${rest.name}", style: theme.text14, overflow: TextOverflow.clip,)),
        ],)));
        list.add(Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 8),
            child: Row(children: [
              Text("${strings.get(48)}: ", style: theme.text14bold),       // Address
              Expanded(child: Text("${rest.address}", style: theme.text14, overflow: TextOverflow.clip,)),
            ],)));
      }
    list.add(Container(
        margin: EdgeInsets.only(left: 5),
        child: Row(
          children: [
            Checkbox(
              value: _checkBoxValue,
              activeColor: theme.colorPrimary,
              checkColor: theme.colorDefaultText,
              onChanged: (bool value){
                pref.set(Pref.deliveryCurbsidePickup, value.toString());
                setState(() {
                  _checkBoxValue = value;
                });
              },

            ),
            Text(strings.get(201), style: theme.text14bold,) // I will take the food myself
          ],
        )

    ));

    //
    if (!_checkBoxValue) {
      list.add(Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Text(
            strings.get(182), style: theme.text14bold,) // Delivery Address
      ));

      var _text = "Latitude: ${_deliveryLatitude
          .toStringAsFixed(6)}, Longitude: ${_deliveryLongitude.toStringAsFixed(
          6)}";

      list.add(Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Text((_deliveryAddressInit) ? _text : strings.get(183),
            style: theme.text14,) // "no address",
      )
      );

      if (_deliveryAddressInit){
        list.add(Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
          child: IInputField2(hint : strings.get(48),  // "Address",
            icon : Icons.location_city,
            controller : editControllerAddress,
            type : TextInputType.text,
            colorDefaultText: theme.colorDefaultText,
            colorBackground: theme.colorBackgroundDialog,
          ),
        ));
      }

      if (_deliveryAddressInit){
        if (_distanceToMax){
          list.add(Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text("${strings.get(218)} $distance${appSettings.distanceUnit} ${strings.get(261)}", style: theme.text16Red,) // ""Note!\тThe delivery distance is very long."",
          )
          );
          for (var item in nearYourRestaurants)
            if (item.id == basket.restaurant) {
              list.add(Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    "${strings.get(259)} ${item.name} ${strings.get(
                        260)} $_areakm ${appSettings.distanceUnit}", style: theme.text14,) // "The Restaurant: ",
              ));
              break;
            }
        }
      }

      list.add(IButton3(pressButton: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddressScreen(callback: (String text, double lat, double lng) {
                      _deliveryAddressInit = true;
                      _deliveryAddress = text;
                      _deliveryLatitude = lat;
                      _deliveryLongitude = lng;
                      pref.set(Pref.deliveryAddressInit, "true");
                      pref.set(Pref.deliveryAddress, _deliveryAddress);
                      pref.set(Pref.deliveryLatitude, _deliveryLatitude.toString());
                      pref.set(Pref.deliveryLongitude, _deliveryLongitude.toString());
                      editControllerAddress.text = _deliveryAddress;
                      editControllerAddress.selection = TextSelection.fromPosition(
                        TextPosition(offset: editControllerAddress.text.length),
                      );
                      _initDistance();
                      setState(() {
                      });
                      setState(() {});
                    })
            ));
      },
        text: strings.get(184), // Select Address
        color: theme.colorPrimary,
        textStyle: theme.text16boldWhite,));
      list.add(SizedBox(height: 10));



    }else {

      list.add(Container(
          margin: EdgeInsets.only(left: 5),
          child: Row(
            children: [
              Checkbox(
                value: _checkBoxValue2,
                activeColor: theme.colorPrimary,
                checkColor: theme.colorDefaultText,
                onChanged: (bool value){
                  setState(() {
                    _checkBoxValue2 = value;
                  });
                },
              ),
              Text(strings.get(247), style: theme.text14bold,) // "Pickup from restaurant",
            ],
          )

      ));

      if (!_checkBoxValue2) {
        list.add(Container(
            color: theme.colorPrimary.withAlpha(40),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
                margin: EdgeInsets.all(10),
                child: Text(strings.get(202),
                  // When your order will be ready, you will receive a message ...
                  style: theme.text14,)
            )
        ));
        list.add(Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: windowWidth*0.7,
                child: IButton3(
                  color: theme.colorPrimary,
                  text: strings.get(225), // "Enter Vehicle Information",
                  textStyle: theme.text14boldWhite,
                  pressButton: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VehicleScreen(callback: (String text) {
                                  _vehicleType = text;
                                  setState(() {});
                                })
                        ));
                  }
              )),
            ],
          ),
        ));
        if (_vehicleType.isNotEmpty) {
          list.add(SizedBox(height: 20,));
          list.add(Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(_vehicleType, style: theme.text16,)
          ));
        }
      }
    }

    list.add(SizedBox(height: 30,));

    list.add(Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: IInputField2(hint : strings.get(106),                      // Phone",
        icon : Icons.phone,
        controller : editControllerPhone,
        type : TextInputType.phone,
        colorDefaultText: theme.colorDefaultText,
        colorBackground: theme.colorBackgroundDialog,
      ),
    ));

    /*list.add(Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: IInputField2(hint : strings.get(85),                      // Comments",
        icon : Icons.chat,
        controller : editControllerComments,
        type : TextInputType.text,
        colorDefaultText: theme.colorDefaultText,
        colorBackground: theme.colorBackgroundDialog,
      ),
    ));*/

    var _time = strings.get(219);
    if (_timeArrivedInit)
      _time = "${strings.get(224)}$_timeArrived"; // "Arriving at ";

    list.add(Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: IInputField2(hint : strings.get(258),                      // Coupon
        icon : Icons.art_track,
        controller : editControllerCoupon,
        type : TextInputType.text,
        colorDefaultText: theme.colorDefaultText,
        colorBackground: theme.colorBackgroundDialog,
        onChangeText: _onCouponEnter,
      ),
    ));

    list.add(_drawCoupon());

    list.add(SizedBox(height: 20,));
    list.add(Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: _row2(_time, strings.get(220))    //  Arriving in 30-60 min - "Change >",
    ));

    list.add(SizedBox(height: 30,));
  }

  _button(){
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: windowWidth*0.15, right: windowWidth*0.15),
      child: IButton3(pressButton: _pressContinueButton,
        text: (stage == 3) ? strings.get(118) : strings.get(18), // Done or Continue
        color: theme.colorPrimary,
        textStyle: theme.text16boldWhite,),
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

  var _timeArrived = "";
  var _timeArrivedInit = false;

  openDialogTime() {
    var hour = DateTime.now().hour+2;
    _timeArrived = "$hour:00";
    var widget = CupertinoDatePicker(
      onDateTimeChanged: (DateTime picked) {
        var h = picked.hour.toString();
        if (picked.hour.toString().length == 1)
          h = "0$h";
        var m = picked.minute.toString();
        if (picked.minute.toString().length == 1)
          m = "0$m";
        _timeArrived = "$h:$m";
        dprint("$_timeArrived");
      },
      use24hFormat: true,
      initialDateTime: DateTime(0, 0, 0, hour, 0),
      //minimumDate: DateTime.now().subtract(Duration(days: 1)),
        minuteInterval: 10,
     // maximumDate: DateTime(2018, 12, 30, 13, 0),
      minimumDate: DateTime(0, 0, 0, hour, 0),
//      minimumYear: 2010,
//      maximumYear: 2022,
//      minuteInterval: 1,
      mode: CupertinoDatePickerMode.time,
    );

    _dialogBody = Column(
      children: [
        Row(
          children: [
            Container(
                width: windowWidth/2-25,
                child: IButton3(
                    color: theme.colorBackgroundGray,
                    text: strings.get(221),              // Now
                    textStyle: theme.text14,
                    pressButton: (){
                      setState(() {
                        _show = 0;
                      });
                    }
                )),
            SizedBox(width: 10,),
            Container(
                width: windowWidth/2-25,
                child: IButton3(
                    color: theme.colorPrimary,
                    text: strings.get(222),              // Later
                    textStyle: theme.text14boldWhite,
                    pressButton: (){
                      setState(() {
                      });
                    }
                )),
          ],
        ),
        SizedBox(height: 30,),
        Container(
          width: windowWidth,
            height: 200,
            child: widget,
        ),
        SizedBox(height: 30,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(223),              // Confirm
            textStyle: theme.text14boldWhite,
            pressButton: (){
              setState(() {
                _timeArrivedInit = true;
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

  _finishWidget(List<Widget> list){
    //      list.add(UnconstrainedBox(
//          child: Container(
//              height: windowWidth*0.4,
//              width: windowWidth*0.8,
//              child: Image.asset("assets/success2.png",
//                  fit: BoxFit.contain
//              )
//          )),
//      );
    list.add(Container(
        color: Colors.black.withAlpha(60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15,),
            Container(
              width: windowWidth,
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text(strings.get(252), style: theme.text16, textAlign: TextAlign.center,), // "It's ordered!",
            ),
            SizedBox(height: 5,),
            Container(
              width: windowWidth,
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("${strings.get(253)}${basket.orderid} Código del Ticket:${basket.ticketCode}", textAlign: TextAlign.start, style: theme.text14,), // "Order No. #",
            ),
            SizedBox(height: 15,),
          ],
        )
    ));

    list.add(SizedBox(height: 25,));
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.centerLeft,
        child: Text(strings.get(254), style: theme.text16bold,)  // "You've successfully placed the order",
    ));
    list.add(SizedBox(height: 35,));
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.centerLeft,
        child: Text(strings.get(255), style: theme.text14,)  // You can check status of your...
    ));
    list.add(SizedBox(height: windowHeight*0.2,));
    list.add(IButton3(
      color: theme.colorPrimary, text: strings.get(256).toUpperCase(), textStyle: theme.text14boldWhite,
        pressButton: (){
          mainScreenState.onBack("orders");
          // route.mainScreen.route("orders");
          // route.popToMain(context);
        }) // Show All my orders
    );
    // pressButton: _pressContinueButton
    list.add(SizedBox(height: 10,));
    list.add(IButton3(
        color: theme.colorPrimary, text: strings.get(257).toUpperCase(), textStyle: theme.text14bold, onlyBorder: true,
    pressButton: (){          // "Back to shop",
      mainScreenState.onBack("home");
      // route.mainScreen.route("home");
      // route.popToMain(context);
    },)
    );
  //  list.add(_button());
  }

  bool _couponEnable = false;


  _onCouponEnter(String value){
    _couponEnable = false;
    for (var coupon in homeScreen.mainWindowData.coupons)
      if (value.toUpperCase() == coupon.name.toUpperCase()) {
        var dateStart = DateTime.parse(coupon.dateStart);
        var dateEnd = DateTime.parse(coupon.dateEnd);
        var t = dateStart.isBefore(DateTime.now());
        var m = dateEnd.isAfter(DateTime.now());
        if (t && m) {
          _couponEnable = true;
          couponName = value;
          basket.setCoupon(coupon);
        }
      }
    if (!_couponEnable)
      basket.setCoupon(null);
    setState(() {
    });
  }

  _itemTextLine(String leftText, String rightText, String rightText2){
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(leftText, style: theme.text14,),
          ),
          Text(rightText, style: theme.text14l,),
          SizedBox(width: 5,),
          Text(rightText2, style: theme.text16Red,),
        ],
      ),
    );
  }

  _drawCoupon(){
    if (!_couponEnable)
      return Container();

    var list = List<Widget>();
    var t2 = basket.getSubTotal(true);
    var t = basket.getSubTotal(false);

    list.add(SizedBox(height: 5,));
    if (basket.couponComment.isNotEmpty)
      list.add(Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Text(basket.couponComment, style: theme.text14R, textAlign: TextAlign.center,),
        )
      );

    list.add(_itemText(strings.get(93), basket.makePriceSctring(t2),false));  // "Subtotal",
    list.add(SizedBox(height: 5,));
    list.add(_itemText(strings.get(94), basket.makePriceSctring(basket.getShoppingCost(true)),false));                            // "Shopping costs",
    list.add(SizedBox(height: 5,));
    list.add(_itemText(strings.get(95),basket.makePriceSctring(basket.getTaxes(true)),false));  // "Taxes",
    list.add(SizedBox(height: 5,));
    
    list.add(_itemTextLine('Cupón','',
       '-' + basket.makePriceSctring(basket.getCoupons())));  // "Taxes",
    list.add(SizedBox(height: 5,));
    list.add(_itemText(strings.get(96), basket.makePriceSctring(basket.getTotal(true)),true));  // "Total",

    list.add(SizedBox(height: 15,));

    return Container(
        color: Colors.black.withAlpha(40),
        child: Column(children: list,));
  }

   _itemText(String leftText, String rightText, bool bold){
    var _style = theme.text14;
    if (bold)
      _style = theme.text14bold;
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(leftText, style: _style,),
          ),
          Text(rightText, style: _style,),
        ],
      ),
    );
  }

}