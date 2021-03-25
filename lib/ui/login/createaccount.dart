import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/server/register.dart';
import 'package:fooddelivery/model/social/facebook.dart';
import 'package:fooddelivery/model/social/google.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/iappBar.dart';
import 'package:fooddelivery/widget/ibackground4.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/ibutton4.dart';
import 'package:fooddelivery/widget/iinputField2PasswordA.dart';
import 'package:fooddelivery/widget/iinputField2a.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>
    with SingleTickerProviderStateMixin {

  FaceBookLogin facebookLogin = FaceBookLogin();
  GoogleLogin googleLogin = GoogleLogin();

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _pressCreateAccountButton(){
    print("User pressed \"CREATE ACCOUNT\" button");
    print("Login: ${editControllerName.text}, E-mail: ${editControllerEmail.text}, "
        "password1: ${editControllerPassword1.text}, password2: ${editControllerPassword2.text}");
    if (editControllerName.text.isEmpty)
      return openDialog(strings.get(175)); // "Enter your Login"
    if (editControllerEmail.text.isEmpty)
      return openDialog(strings.get(176)); // "Enter your E-mail"
    if (!_validateEmail(editControllerEmail.text))
      return openDialog(strings.get(178)); // "You E-mail is incorrect"
    if (editControllerPassword1.text.isEmpty || editControllerPassword2.text.isEmpty)
      return openDialog(strings.get(177)); // "Enter your password"
    if (editControllerPassword1.text != editControllerPassword2.text)
      return openDialog(strings.get(134)); // "Passwords are different.",
    _waits(true);
    register(editControllerEmail.text, editControllerPassword1.text,
        editControllerName.text, "email", "", _okUserEnter, _error);
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerName = TextEditingController();
  final editControllerEmail = TextEditingController();
  final editControllerPassword1 = TextEditingController();
  final editControllerPassword2 = TextEditingController();
  ScrollController _scrollController = ScrollController();

  _okUserEnter(String name, String password, String avatar, String email, String token, String typeReg){
    _waits(false);
    account.okUserEnter(name, password, avatar, email, token, "", "", "", 0, typeReg);
    route.pushToStart(context, "/main");
  }

  bool _wait = false;

  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  _error(String error){
    _waits(false);
    if (error == "login_canceled")
      return;
    if (error == "3")
      return openDialog(strings.get(272)); // This email is busy
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    route.disposeLast();
    editControllerName.dispose();
    editControllerEmail.dispose();
    editControllerPassword1.dispose();
    editControllerPassword2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent,);
    });
    return WillPopScope(
        onWillPop: () async {
      if (_show != 0){
        setState(() {
          _show = 0;
        });
        return false;
      }
      return true;
    },
    child: Scaffold(
      backgroundColor: theme.colorBackground,

      body: Directionality(
        textDirection: strings.direction,
        child: Stack(
        children: <Widget>[

          IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),

          Container(
            alignment: Alignment.bottomCenter,
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              width: windowWidth,
              child: _body(),
           ),

          if (_wait)(
              Container(
                color: Color(0x80000000),
                width: windowWidth,
                height: windowHeight,
                child: Center(
                  child: ColorLoader2(
                    color1: theme.colorPrimary,
                    color2: theme.colorCompanionYellow,
                    color3: theme.colorPrimary,
                  ),
                ),
              ))else(Container()),

          IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
            body: _dialogBody, backgroundColor: theme.colorBackground,),

          IAppBar(context: context, text: "", color: Colors.white),

        ],
      ),
    )));
  }

  _body(){
    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      children: <Widget>[

        Container(
          width: windowWidth*0.4,
          height: windowWidth*0.4,
          child: Image.asset("assets/logo.png", fit: BoxFit.contain),
        ),

        SizedBox(height: windowHeight*0.05,),

        Container(
          width: windowWidth,
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Text(strings.get(24),                        // "Create an Account!"
            style: theme.text20boldWhite, textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 15,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:
            IInputField2a(
              hint: strings.get(15),            // "Login"
              icon: Icons.account_circle,
              colorDefaultText: Colors.white,
              controller: editControllerName,
            )
        ),
        SizedBox(height: 5,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 5,),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:
            IInputField2a(
              hint: strings.get(21),            // "E-mail address",
              icon: Icons.alternate_email,
              type: TextInputType.emailAddress,
              colorDefaultText: Colors.white,
              controller: editControllerEmail,
            )
        ),
        SizedBox(height: 5,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 5,),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2PasswordA(
              hint: strings.get(16),            // "Password"
              icon: Icons.vpn_key,
              colorDefaultText: Colors.white,
              controller: editControllerPassword1,
            )),

        SizedBox(height: 5,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 5,),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2PasswordA(
              hint: strings.get(25),            // "Confirm Password"
              icon: Icons.vpn_key,
              colorDefaultText: Colors.white,
              controller: editControllerPassword2,
            )),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 20,),
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: IButton3(
                color: theme.colorCompanionYellow, text: strings.get(26), textStyle: theme.text14boldWhite,  // CREATE ACCOUNT
                pressButton: (){
                  _pressCreateAccountButton();
                })),

    if (appSettings.googleLogin == "true" || appSettings.facebookLogin == "true")
        Container(child: Row(children: [
          Expanded(child: Container(height: 0.3, color: theme.colorBackground,)),
          Text(strings.get(271), style: theme.text14boldWhite),  // " or "
          Expanded(child: Container(height: 0.3, color: theme.colorBackground,)),
        ],)),

      if (appSettings.googleLogin == "true")
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: IButton4(
                color: Color(0xffd9534f), text: strings.get(269), textStyle: theme.text14boldWhite,  // Sign In with Google
                icon: "assets/google.png",
                pressButton: (){
                  _waits(true);
                  googleLogin.login(_login, _error);
                })),

      if (appSettings.facebookLogin == "true")
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: IButton4(
                color: Color(0xff428bca), text: strings.get(270), textStyle: theme.text14boldWhite,  // Sign In with Facebook
                icon: "assets/facebook.png",
                pressButton: (){
                  _waits(true);
                  facebookLogin.login(_login, _error);
                })),

        SizedBox(height: 30,),
      ],
    );
  }

  _login(String type, String id, String name, String photo) {
    dprint("Reg: type=$type, id=$id, name=$name, photo=$photo");
    register("$id@$type.com", id, name, type, photo, _okUserEnter, _error);
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
    _waits(false);
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

  bool _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }
}