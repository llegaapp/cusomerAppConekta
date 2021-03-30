import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/widget/ibackground4.dart';
import 'package:fooddelivery/widget/iline.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

class Menu extends StatelessWidget {
  @required final BuildContext context;
  final Function(String) callback;
  Menu({this.context, this.callback});

  //////////////////////////////////////////////////////////////////
  //
  //
  //
  _onMenuClickItem(int id){
    print("User click menu item: $id");
    switch(id){
      case 1:   // home
        callback("home");
        break;
      case 2:   // notifications
        callback("notify");
        break;
      case 3:   // My Orders
        callback("orders");
        break;
      case 4:   // Wish List
        callback("favorites");
        break;
      case 12:   // Chat
        //callback("chat");
        break;
      case 13:   // Wallet
        callback("wallet");
        break;
      case 7:   // Help - faq
        callback("faq");
        break;
      case 8:   // Settings
        callback("account");
        break;
      case 9:   // Language
        callback("language");
        break;
      case 10:   // dark & light mode
        theme.changeDarkMode();
        callback("redraw");
        break;
      case 11:   // sign out
        account.logOut();
        break;

      case 20:   // about
        callback("about");
        break;
      case 21:   // delivery
        callback("delivery");
        break;
      case 22:   // privacy
        callback("privacy");
        break;
      case 23:   // terms
        callback("terms");
        break;
      case 24:   // refund
        callback("refund");
        break;
    }
  }

  // _changeNotify(bool value){
  //   print("Notification button change value: $value");
  // }
  //
  //
  //
  //////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: strings.direction,
        child: Drawer(
        child: Container(
          color: theme.colorBackground,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              if (!account.isAuth())
              Container(
                height: 100+MediaQuery
                    .of(context)
                    .padding
                    .top,
                child: IBackground4(colorsGradient: theme.colorsGradient),
              ),
              if (account.isAuth())
              SizedBox(height: MediaQuery
                  .of(context)
                  .padding
                  .top,),
              if (account.isAuth())
              Container(
                  height: 100,
                  child: Row(
                    children: <Widget>[
                      UnconstrainedBox(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(1, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: _avatar(),
                          margin: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
                        )
                      ),
                      SizedBox(width: 20,),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(account.userName, style: theme.text18boldPrimary,),
                            if (account.typeReg == "email")
                              Text(account.email, style: theme.text16,),
                          ],
                        ),
                      ),

                    ],

                  )
              ),
              if (account.isAuth())
                ILine(),

              _item(1, strings.get(33), "assets/home.png"), // 'Home'
              _item(3, strings.get(36), "assets/prod.png"),  // 'My orders'
              _item(4, strings.get(38), "assets/heart.png"), // "Favorites",
              if (appSettings.walletEnable == "true")
                _item(13, strings.get(206), "assets/wallet.png"), // "Wallet",
              ILine(),
              _item(2, strings.get(35), "assets/notifyicon.png"),  // Notifications
              //_item(12, strings.get(205), "assets/chat.png"), // Chat
              _item(8, strings.get(37), "assets/settings.png"), // "Account",
              _item(9, strings.get(62), "assets/language.png"), // Languages

              if (appSettings.faq == "true" || appSettings.about == "true" || appSettings.delivery == "true" ||
                  appSettings.privacy == "true" || appSettings.terms == "true" || appSettings.refund == "true")
                ILine(),
              if (appSettings.faq == "true")
                _item(7, strings.get(51), "assets/help.png"), // Help & Support
              if (appSettings.about == "true")
                _item(20, (appSettings.aboutTextName == null) ? "" : appSettings.aboutTextName, "assets/doc.png"),
              if (appSettings.delivery == "true")
                _item(21, (appSettings.deliveryTextName == null) ? "" : appSettings.deliveryTextName, "assets/doc.png"),
              if (appSettings.privacy == "true")
                _item(22, (appSettings.privacyTextName == null) ? "" : appSettings.privacyTextName, "assets/doc.png"),
              if (appSettings.terms == "true")
                _item(23, (appSettings.termsTextName == null) ? "" : appSettings.termsTextName, "assets/doc.png"),
              if (appSettings.refund == "true")
                _item(24, (appSettings.refundTextName == null) ? "" : appSettings.refundTextName, "assets/doc.png"),

              if (account.isAuth())
                ILine(),
              if (account.isAuth())
                _closeSession(11, strings.get(132), "assets/signout.png"), // "Sign Out",

            ],
          ),
        )
    ));
  }

  _avatar(){
    if (!account.isAuth())
      return Container();
    else
      return Container(
        width: 55,
        height: 55,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(55),
          child: Container(
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  CircularProgressIndicator(),
              imageUrl: account.userAvatar,
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
          ),
        ),
      );
  }

//  _darkMode(){
//    if (theme.darkMode)
//      return _item(10, "Light colors", "assets/brands.png");
//    return _item(10, "Dark colors", "assets/brands.png");
//  }

  _item(int id, String name, String imageAsset){
    return Stack(
      children: <Widget>[
        ListTile(
          title: Text(name, style: theme.text16bold,),
          leading:  UnconstrainedBox(
              child: Container(
                  height: 35,
                  width: 35,
                  child: Image.asset(imageAsset,
                      fit: BoxFit.contain,
                      color: theme.colorPrimary,
                  )

              )),
        ),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  Navigator.pop(context);
                  _onMenuClickItem(id);
                }, // needed
              )),
        )
      ],
    );
  }
  _closeSession(int id, String name, String imageAsset){
    return Stack(
      children: <Widget>[
        ListTile(
          title: Text(name, style: theme.text16bold,),
          leading:  UnconstrainedBox(
              child: Container(
                  height: 35,
                  width: 35,
                  child: Image.asset(imageAsset,
                      fit: BoxFit.contain,
                      color: theme.colorPrimary,
                  )

              )),
        ),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child:  FlatButton(

                color: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                onPressed: () async {
                  if (await confirm(
                    context,
                    title: Text(strings.get(324)),
                    content: Text(strings.get(325)),
                    textOK: Text(strings.get(321)),
                    textCancel: Text(strings.get(322)),
                  )) {
                    Navigator.pop(context);
                    _onMenuClickItem(id);
                  }
                  return print('pressedCancel');
                },
              ),),
        )
      ],
    );
  }

}