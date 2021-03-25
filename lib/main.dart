import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fooddelivery/model/account.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/pref.dart';
import 'package:fooddelivery/route.dart';
import 'package:fooddelivery/config/theme.dart';
import 'package:fooddelivery/ui/login/login.dart';
import 'package:fooddelivery/ui/start/splash.dart';
import 'config/lang.dart';

//
// Theme
//
AppThemeData theme = AppThemeData();
//
// Language data
//
Lang strings = Lang();
//
// Routes
//
AppFoodRoute route = AppFoodRoute();
//
// Account
//
Account account = Account();
Pref pref = Pref();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

  pref.init().then((instance) {
    appSettings.bottomBarType = pref.get(Pref.bottomBarType);

    var dark = pref.get(Pref.uiDarkMode);
    if (dark == "true")
      theme.darkMode = true;
    var colorMain = pref.get(Pref.uiMainColor);
    if (colorMain.isNotEmpty)
      theme.colorPrimary = Color(int.parse(colorMain, radix: 16));
    theme.init();

    var id = pref.get(Pref.language);
    var lid = Lang.english;
    if (id.isNotEmpty)
      lid = int.parse(id);
    strings.setLang(lid);  // set default language - English

    runApp(Phoenix(child: AppFoodDelivery()));
  });

}

class AppFoodDelivery  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var _theme = ThemeData(
      fontFamily: 'Avenir',
      primarySwatch: theme.primarySwatch,
      accentColor: theme.colorPrimary,
      textTheme: TextTheme(
          button: TextStyle(color: Colors.black),
      ),
    );

    if (theme.darkMode){
      _theme = ThemeData(
        fontFamily: 'Avenir',
        brightness: Brightness.dark,
        unselectedWidgetColor:Colors.white,
        primarySwatch: theme.primarySwatch,
        textTheme: TextTheme(
        ).apply(
          bodyColor: Colors.white,
        ),
      );
    }

    return MaterialApp(
      title: strings.get(10),  // "Food Delivery Flutter App UI Kit",
      debugShowCheckedModeBanner: false,
      theme: _theme,
      initialRoute: '/splash',
//      initialRoute: '/paypal2',
      routes: {
        '/splash': (BuildContext context)  => SplashScreen(),
        '/login': (BuildContext context)   => LoginScreen(),
//      '/paypal2': (BuildContext context) => PayStackPage(),

      },
    );
  }
}


