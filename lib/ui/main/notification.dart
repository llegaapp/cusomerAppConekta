import 'package:flutter/material.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/server/notify.dart';
import 'package:fooddelivery/model/server/notifyDelete.dart';
import 'package:fooddelivery/widget/ICard29FileCaching.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/widgets.dart';

class NotificationScreen extends StatefulWidget {
  final Function(String) onBack;
  NotificationScreen({Key key, this.onBack}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  _dismissItem(String id){
    print("Dismiss item: $id");

    notifyDelete(account.token, id, (){
      Notifications _delete;
      for (var item in _this)
        if (item.id == id)
          _delete = item;

      if (_delete != null) {
        _this.remove(_delete);
        setState(() {
        });
      }
    }, _error);

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
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  bool _wait = true;
  List<Notifications> _this;

  @override
  void initState() {
    account.notifyCount = 0;
    account.redraw();
    if (account.isAuth())
      getNotify(account.token, _success, _error);
    else
      _waits(false);
    account.addCallback(this.hashCode.toString(), callback);
    account.addNotifyCallback(callbackReload);
    super.initState();
  }

  callbackReload(){
    if (account.isAuth())
      getNotify(account.token, _success, _error);
  }

  _error(String error){
    _waits(false);
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _waits(bool value){
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  _success(List<Notifications> _data) {
    _waits(false);
    _this = _data;
    setState(() {
    });
  }

  callback(bool reg){
    setState(() {
    });
  }

  @override
  void dispose() {
    account.addNotifyCallback(null);
    route.disposeLast();
    account.removeCallback(this.hashCode.toString());
    account.redraw();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: theme.colorBackground,
        body:
        Directionality(
        textDirection: strings.direction,
        child:
        Stack(
          children: <Widget>[

          headerWidget(context, widget.onBack, Colors.black, strings.get(35)), // "Notifications",

        if (account.isAuth())(
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+42),
              child: _body(),
            ))else (
              _mustAuth()
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
                body: _dialogBody, backgroundColor: theme.colorBackground),

          ],
        )
    ));
  }

  _body(){
    var size = 0;
    if (_this == null)
      return Container();
    for (var _ in _this)
      size++;
    if (size == 0)
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UnconstrainedBox(
                  child: Container(
                      height: windowHeight/3,
                      width: windowWidth/2,
                      child: Container(
                        child: Image.asset("assets/nonotify.png",
                            fit: BoxFit.contain,
                        ),
                      )
                  )),
              SizedBox(height: 20,),
              Text(strings.get(44),    // "Not Have Notifications",
                  overflow: TextOverflow.clip,
                  style: theme.text16bold
                  ),
              SizedBox(height: 50,),
            ],
          )

      );
    return ListView(
      children: _body2(),
    );
  }

  _body2(){
    var list = List<Widget>();

    list.add(Container(
      color: theme.colorBackgroundDialog,
      child: ListTile(
        leading: UnconstrainedBox(
      child: Container(
      height: 35,
          width: 35,
          child: Image.asset("assets/notifyicon.png",
              fit: BoxFit.contain,
          ))),
        title: Text(strings.get(45), style: theme.text20bold,),  // "Notifications",
        subtitle: Text(strings.get(46), style: theme.text14,),  // "Swipe left the notification to delete it",
      ),
    ));

    list.add(SizedBox(height: 20,));

    for (var _data in _this) {
      list.add(
          ICard29FileCaching(
              key: UniqueKey(),
              id: _data.id,
              color: theme.colorGrey.withOpacity(0.1),
              title: _data.title,
              titleStyle: theme.text14bold,
              userAvatar: "$serverImages${_data.image}",
              colorProgressBar: theme.colorPrimary,
              text: _data.text,
              textStyle: theme.text14,
              balloonColor: theme.colorPrimary,
              date: _data.date,
              dateStyle: theme.text12grey,
              callback: _dismissItem
          )
      );
    }
    return list;
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
              Text(strings.get(125)), // "You must sign-in to access to this section",
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

}

