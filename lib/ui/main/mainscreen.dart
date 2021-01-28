import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/basket.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/notification.dart';
import 'package:fooddelivery/model/pref.dart';
import 'package:fooddelivery/model/server/changePassword.dart';
import 'package:fooddelivery/model/server/changeProfile.dart';
import 'package:fooddelivery/model/server/uploadavatar.dart';
import 'package:fooddelivery/model/utils.dart';
import 'package:fooddelivery/ui/main/account.dart';
import 'package:fooddelivery/ui/main/favorites.dart';
import 'package:fooddelivery/ui/main/home.dart';
import 'package:fooddelivery/ui/main/map.dart';
import 'package:fooddelivery/ui/main/orderdetails.dart';
import 'package:fooddelivery/ui/main/orders.dart';
import 'package:fooddelivery/ui/menu/chat.dart';
import 'package:fooddelivery/ui/menu/documents.dart';
import 'package:fooddelivery/ui/menu/help.dart';
import 'package:fooddelivery/ui/menu/language.dart';
import 'package:fooddelivery/ui/menu/menu.dart';
import 'package:fooddelivery/ui/menu/wallet.dart';
import 'package:fooddelivery/widget/IBottomBar2.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/ibottombar.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'basket.dart';
import 'notification.dart';

double mainDialogShow = 0;
Widget mainDialogBody = Container();

double mainCurrentDialogShow = 0;
Widget mainCurrentDialogBody = Container();
bool noMain = false;

Basket basket = Basket();
_MainScreenState mainScreenState;
BuildContext mainContext;

// ignore: must_be_immutable
class MainScreen extends StatefulWidget  {
  @override
  _MainScreenState createState() {
    mainScreenState = _MainScreenState();
    return mainScreenState;
  }
  route(String value){
    mainScreenState.routes(value);
  }
  onBack(String value){
    mainScreenState.onBack(value);
  }
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {

  var windowWidth;
  var windowHeight;
  bool wait = false;
  String _currentState = "";
  final formKey  = GlobalKey<FormState>();

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _callbackChange(){
    print("User pressed Change password");
    print("Old password: ${editControllerOldPassword.text}, New password: ${editControllerNewPassword1.text}, "
        "New password 2: ${editControllerNewPassword2.text}");
    if (editControllerNewPassword1.text != editControllerNewPassword2.text)
      return _openDialogError(strings.get(167)); // "Passwords don't equals",
    if (editControllerNewPassword1.text.isEmpty || editControllerNewPassword2.text.isEmpty)
      return _openDialogError(strings.get(170)); // "Enter New Password",
    changePassword(account.token, editControllerOldPassword.text, editControllerNewPassword1.text,
        _successChangePassword, _errorChangePassword);
  }

  _errorChangePassword(String error){
    if (error == "1")
      return _openDialogError(strings.get(168)); // Old password is incorrect
    if (error == "2")
      return _openDialogError(strings.get(169)); // The password length must be more than 5 chars
    _openDialogError("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _successChangePassword(){
    _openDialogError(strings.get(166)); // "Password change",
    pref.set(Pref.userPassword, editControllerNewPassword1.text);
  }

  _callbackSave(){ 

    print("User pressed Save profile");
    print("User Name: ${editControllerName.text}, E-mail: ${editControllerEmail.text}, Phone: ${editControllerPhone.text}, RFC: ${editControllerRfc.text}, BusinessName: ${editControllerBusinessName.text}");
    
    changeProfile(account.token, editControllerName.text, editControllerEmail.text, editControllerPhone.text, editControllerRfc.text, editControllerBusinessName.text,
        _successChangeProfile, _errorChangeProfile);
  }

  _errorChangeProfile(String error){
    _openDialogError("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _successChangeProfile(){
    _openDialogError(strings.get(171)); // "User Profile change",
    account.userName = editControllerName.text;
    account.phone = editControllerPhone.text;
    account.email = editControllerEmail.text;
    account.rfc = editControllerRfc.text;
    account.businessName = editControllerBusinessName.text;
     
    setState(() {
    });
  }

  _bottonBarChange(int index){
    print("User pressed bottom bar button with index: $index");
    setState(() {
      _currentPage = index;
    });
  }

  _openMenu(){
    print("Open menu");
    if (strings.direction == TextDirection.rtl)
      _scaffoldKey.currentState.openEndDrawer();
      else
      _scaffoldKey.currentState.openDrawer();
    setState(() {

    });
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////

  var _currentPage = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final editControllerName = TextEditingController();
  final editControllerEmail = TextEditingController();
  final editControllerPhone = TextEditingController();
  final editControllerRfc = TextEditingController();
  final editControllerBusinessName = TextEditingController(); 
  final editControllerOldPassword = TextEditingController();
  final editControllerNewPassword1 = TextEditingController();
  final editControllerNewPassword2 = TextEditingController();

  @override
  void initState() {
    account.addCallback(this.hashCode.toString(), callback);
    Future.delayed(Duration(milliseconds: 100), () async {
      await firebaseGetToken();
    });
    super.initState();
  }

  callback(bool reg){
    setState(() {
    });
  }

  @override
  void dispose() {
    route.disposeLast();
    editControllerName.dispose();
    editControllerEmail.dispose();
    editControllerPhone.dispose();
    editControllerRfc.dispose();
    editControllerBusinessName.dispose(); 
    editControllerOldPassword.dispose();
    editControllerNewPassword1.dispose();
    editControllerNewPassword2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    //
    String _headerText = strings.get(47); // "Map",
    switch(_currentPage){
      case 1:
        _headerText = strings.get(36); // "My Orders",
        break;
      case 2:
        _headerText = strings.get(33); // "Home",
        break;
      case 3:
        _headerText = strings.get(37); // "Account",
        break;
      case 4:
        _headerText = strings.get(38); // "Favorites",
        break;
    }

    return WillPopScope(
        onWillPop: () async {
          if (wait) {
            wait = false;
            setState(() {
            });
            return false;
          }
          if (_currentState == "about" || _currentState == "delivery" || _currentState == "privacy"
              || _currentState == "terms" || _currentState == "refund" || _currentState == "faq"
              || _currentState == "language" || _currentState == "chat" || _currentState == "notify"
              || _currentState == "wallet" || _currentState == "order_details" || _currentState == "basket") {
            _currentState = "";
            setState(() {});
            return false;
          }

          return true;
        },
    child: Scaffold(
      key: _scaffoldKey,
      drawer: Menu(context: context, callback: routes,),
      endDrawer: Menu(context: context, callback: routes,),
      backgroundColor: theme.colorBackground,
      body: Stack(
        children: <Widget>[

          if (_currentPage == 0)
            MapScreen(),
          if (_currentPage == 1)
            OrdersScreen(onErrorDialogOpen: _openDialogError, onBack: onBack),
          if (_currentPage == 2)
            HomeScreen(onErrorDialogOpen: _openDialogError, redraw: (){setState(() {});}, callback: routes, scaffoldKey: _scaffoldKey),
          if (_currentPage == 3)
            AccountScreen(onDialogOpen: _openDialogs),
          if (_currentPage == 4)
            FavoritesScreen(scaffoldKey: _scaffoldKey),

          headerMenuWidget(context, onBack, Colors.black, _headerText),

      if (appSettings.bottomBarType == "type1")
            IBottomBar(colorBackground: appSettings.bottomBarColor, colorSelect: theme.colorPrimary,
                  colorUnSelect: theme.colorDefaultText.withAlpha(100), callback: _bottonBarChange, initialSelect: _currentPage,
                getItem: (){return _currentPage;},
                icons: ["assets/map.png", "assets/orders.png", "assets/home.png", "assets/account.png", "assets/favorites.png"]
            ),

      if (appSettings.bottomBarType == "type2")
          IBottomBar2(colorBackground: appSettings.bottomBarColor, colorSelect: theme.colorPrimary,
              colorUnSelect: theme.colorDefaultText.withAlpha(100), callback: _bottonBarChange, initialSelect: _currentPage,
              radius: appSettings.radius, shadow: appSettings.shadow,
              getItem: (){return _currentPage;},
              icons: ["assets/map.png", "assets/orders.png", "assets/home.png", "assets/account.png", "assets/favorites.png"]
          ),

          if (_currentState == "about" || _currentState == "delivery" || _currentState == "privacy"
              || _currentState == "terms" || _currentState == "refund")
            DocumentsScreen(doc: _currentState, onBack: onBack),
          if (_currentState == "faq")
            HelpScreen(onBack: onBack),
          //if (_currentState == "chat")
            //ChatScreen(onBack: onBack),
          if (_currentState == "language")
            LanguageScreen(onBack: onBack, redraw: (){setState(() {});},),
          if (_currentState == "notify")
            NotificationScreen(onBack: onBack),
          if (_currentState == "wallet")
            WalletScreen(onBack: onBack),
          if (_currentState == "order_details")
            OrderDetailsScreen(onBack: onBack),
          if (_currentState == "basket")
            BasketScreen(onBack: onBack),

          if (wait)
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
                )),

          IEasyDialog2(setPosition: (double value){mainDialogShow = value;}, getPosition: () {return mainDialogShow;}, color: theme.colorGrey,
              body: mainDialogBody, backgroundColor: theme.colorBackground),

          IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
            body: _dialogBody, backgroundColor: theme.colorBackground,),

        ],
      ),
    ));
  }

  onBack(String route){
    if (route == "open_menu")
      return _openMenu();
    _currentState = "";
    if (route == "account")
      _currentPage = 3;
    if (route == "chat")
      _currentState = "chat";
    if (route == "notify")
      _currentState = "notify";
    if (route == "basket") {
      while(Navigator.canPop(context))
        Navigator.pop(context);
      _currentState = "basket";
    }
    if (route == "home") {
      while(Navigator.canPop(context))
        Navigator.pop(context);
      _currentPage = 2;
    }
    if (route == "orders") {
      while(Navigator.canPop(context))
        Navigator.pop(context);
      _currentPage = 1;
    }
    if (route == "order_details")
      _currentState = "order_details";
    setState(() {});
  }

  routes(String route){
    if (route == "map")
      setState(() {
        _currentPage = 0;
      });
    if (route == "orders")
      setState(() {
        _currentPage = 1;
      });
    if (route == "home")
      setState(() {
        _currentPage = 2;
      });
    if (route == "account")
      setState(() {
        _currentPage = 3;
      });
    if (route == "favorites")
      setState(() {
        _currentPage = 4;
      });
    if (route == "redraw")
      print ("mainscreen redraw");
      setState(() {
      });
    if (route == "about" || route == "delivery" || route == "privacy"
        || route == "terms" || route == "refund" || route == "faq" || route == "language"
        || route == "chat" || route == "notify" || route == "wallet" || route == "order_details"){
      _currentState = route;
    }
  }

  _openDialogs(String name){
    if (name == "EditProfile")
      _openEditProfileDialog();
    if (name == "makePhoto")
      getImage();
    if (name == "changePassword")
      _pressChangePasswordButton();
  }

  double _show = 0;
  Widget _dialogBody = Container();

  _openEditProfileDialog(){

    editControllerName.text   = account.userName;
    editControllerEmail.text  = account.email;
    editControllerPhone.text  = account.phone;
    editControllerRfc.text    = account.rfc;
    editControllerBusinessName.text = account.businessName;
    

    _dialogBody = Container(
        width: double.maxFinite,
        height: (MediaQuery.of(context).size.height / 2) - 50,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: formKey, 
          child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              Container(
            alignment: Alignment.center,
            child: Text(strings.get(156), textAlign: TextAlign.center, style: theme.text18boldPrimary,) // "Edit profile",
              ), // "Reason to Reject",
              SizedBox(height: 20,),
              Text("${strings.get(157)}:", style: theme.text12bold,),  // "User Name",
              _edit(editControllerName, strings.get(158), false,'empty'),                //  "Enter your User Name",
              SizedBox(height: 20,),
              if (account.typeReg == "email")
              Text("${strings.get(159)}:", style: theme.text12bold,),  // "E-mail",
              if (account.typeReg == "email")
              _edit(editControllerEmail, strings.get(160), false,'email'),                //  "Enter your User E-mail",
              if (account.typeReg == "email")
              SizedBox(height: 20,),
              Text("${strings.get(59)}:", style: theme.text12bold,),  // Phone
              _edit(editControllerPhone, strings.get(161), false,'number'),  
              
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                child: Text(strings.get(288), textAlign: TextAlign.center, style: theme.text18boldPrimary,) // "Facturacion",
              ),

              SizedBox(height: 20,),
              Text("${strings.get(289)}:", style: theme.text12bold,),  // RFC
              _edit(editControllerRfc, strings.get(289), false,'rfc'),  

              SizedBox(height: 20,),
              Text("${strings.get(290)}:", style: theme.text12bold,),  // Razon Social
              _edit(editControllerBusinessName, strings.get(290), false,'empty'),  
                
              
              

              //  "Enter your User Phone",
              SizedBox(height: 30,),
    
    Container(
    width: windowWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Container(
              width: windowWidth/2-45,
            child: IButton3(
            color: theme.colorPrimary,
            text: strings.get(162),                  // Change
            textStyle: theme.text14boldWhite,
            pressButton: (){
              if ( !formKey.currentState.validate() ) return;
              formKey.currentState.save();
      
              setState(() {
    _show = 0;
              });
              
              _callbackSave();
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
      ),
          ),
        ),
      );

    setState(() {
      _show = 1;
    });
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

  

  _pressChangePasswordButton(){
    _dialogBody = Directionality(
        textDirection: strings.direction,
        child: Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Text(strings.get(147), textAlign: TextAlign.center, style: theme.text18boldPrimary,) // "Change password",
          ), // "Reason to Reject",
          SizedBox(height: 20,),
          Text("${strings.get(148)}:", style: theme.text12bold,),  // "Old password",
          _edit(editControllerOldPassword, strings.get(149), true,'empty'),                //  "Enter your old password",
          SizedBox(height: 20,),
          Text("${strings.get(150)}:", style: theme.text12bold,),  // "New password",
          _edit(editControllerNewPassword1, strings.get(152), true,'empty'),                //  "Enter your new password",
          SizedBox(height: 20,),
          Text("${strings.get(153)}:", style: theme.text12bold,),  // "Confirm New password",
          _edit(editControllerNewPassword2, strings.get(154), true,'empty'),                //  "Enter your new password",
          SizedBox(height: 30,),
          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Container(
              width: windowWidth/2-45,
                child: IButton3(
                      color: theme.colorPrimary,
                      text: strings.get(162),                  // Change
                      textStyle: theme.text14boldWhite,
                      pressButton: (){
                        setState(() {
                          _show = 0;
                        });
                        _callbackChange();
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
      ),
    ));

    setState(() {
      _show = 1;
    });
  }

  final picker = ImagePicker();

  getImage(){
    _dialogBody = Column(
      children: [
        InkWell(
            onTap: () {
              getImage2(ImageSource.gallery);
              setState(() {
                _show = 0;
              });
            }, // needed
            child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                height: 40,
                color: theme.colorBackgroundGray,
                child: Center(
                  child: Text(strings.get(163)), // "Open Gallery",
                )
            )),
        InkWell(
            onTap: () {
              getImage2(ImageSource.camera);
              setState(() {
                _show = 0;
              });
            }, // needed
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              margin: EdgeInsets.only(bottom: 10),
              height: 40,
              color: theme.colorBackgroundGray,
              child: Center(
                child: Text(strings.get(164)), //  "Open Camera",
              ),
            )),
        SizedBox(height: 20,),
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

  waits(bool value){
    wait = value;
    if (mounted)
      setState(() {
      });
  }

  Future getImage2(ImageSource source) async {
    waits(true);
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null && pickedFile.path != null) {
      print("Photo file: ${pickedFile.path}");
      waits(true);
      uploadAvatar(pickedFile.path, account.token, (String avatar) {
        account.setUserAvatar(avatar);
        waits(false);
        setState(() {
        });
      }, (String error) {
        waits(false);
        _openDialogError("${strings.get(128)} $error"); // "Something went wrong. ",
      });
    }else
      waits(false);
  }

  _openDialogError(String _text) {
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

