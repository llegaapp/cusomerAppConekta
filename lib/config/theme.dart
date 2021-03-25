import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/pref.dart';
import 'dart:io' show Platform;

class AppThemeData{
  //
  //
  //
  bool multiple = true;
  //
  // Dark mode flag
  //
  bool darkMode = false;
  //
  // colors
  //
  Color colorGrey = Color.fromARGB(255, 209, 210, 205);
  Color colorPrimary = Color(0xffce0e2d); // foods 0xff668798 // restaurants 0xff668798
  Color colorCompanion = Color(0xff7dc244); // foods 0xff009688 // restaurants 0xff009688
  Color colorCompanionYellow = Color(0xfffab702); // foods 0xff009688 // restaurants 0xff009688
  Color colorHeaderPedidos = Color(0xFF616161); // foods 0xff009688 // restaurants 0xff009688
  Color colorHeaderRestaurante = Color(0xFF010101); // foods 0xff009688 // restaurants 0xff009688
  Color colorHeaderTipServ = Color(0xFFc70f33); // foods 0xff009688 // restaurants 0xff009688
  Color colorHeaderStatusEntregado = Color(0xFF00d438); // foods 0xff009688 // restaurants 0xff009688
  Color colorHeaderStatusCancelado = Color(0xFFce0e2d); // foods 0xff009688 // restaurants 0xff009688
  Color colorHeaderStatus = Color(0xFFffb600); // foods 0xff009688 // restaurants 0xff009688
  Color colorHeadertotal = Color(0xFFeb0826); // foods 0xff009688 // restaurants 0xff009688

  Color colorBackground;
  Color colorBackgroundGray;
  Color colorDefaultText;
  Color colorBackgroundDialog;
  MaterialColor primarySwatch;
  List<Color> colorsGradient = [];
  Color colorDarkModeLight = Color.fromARGB(255, 40, 40, 40); // for dialog background in dark mode
  //

   Color colorOfRestaurant = Color(0xff505050);
  // Para el ticket, fecha y hora : Avenir Light
  // El #ID: Avenir Medium Oblique
  // Nombre del restaurante: Avenir Medium
  // Servicio a domicilio o pick up: Avenir Black
  // Estados entregado, cancelado, en camino, etc.: Avenir medium
  TextStyle text10UYellow;
  TextStyle text12grey;
  TextStyle text12bold;
  TextStyle text12Ubold;
  TextStyle text12YellowUbold;
  TextStyle text10white;
  TextStyle text13avenir;
  TextStyle text13avenirItalic;
  TextStyle text14;
  TextStyle text14R;
  TextStyle text14l;
  TextStyle text14primary;
  TextStyle text14purple;
  TextStyle text14grey;
  TextStyle text14bold;
  TextStyle text14boldPimary;
  TextStyle text14Companyon;
  TextStyle text14boldWhite2;
  TextStyle text14White2;
  TextStyle text14boldWhite;
  TextStyle text14boldWhiteShadow;
  TextStyle text14Restaurante;
  TextStyle text14TipServ;
  TextStyle text14StatusEntregado;
  TextStyle text14StatusCancelado;
  TextStyle text14Status;
  TextStyle text14link = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.underline,
      fontSize: 14,
  );
  TextStyle text15link;
  TextStyle text16;
  TextStyle text162;
  TextStyle text142;
  TextStyle text16Red;
  TextStyle text16UI;
  TextStyle text16Ubold;
  TextStyle text16UIWhite;
  TextStyle text16Companyon;
  TextStyle text16yellow;
  TextStyle text16blue;
  TextStyle text16CompanyonNoBold;
  TextStyle text16bold;
  TextStyle text16Yellow;
  TextStyle text16White;

  TextStyle text16boldYellow;
  TextStyle text16boldWhite;
  TextStyle text18boldPrimary;
  TextStyle text18total;
  TextStyle text18boldPrimaryUI;
  TextStyle text18boldPrimaryUIWhite;
  TextStyle text18bold;
  TextStyle text20;
  TextStyle text20bold;
  TextStyle text20boldPrimary;
  TextStyle text20boldWhite;
  TextStyle text20negative;
  TextStyle text40boldWhiteShadow;


  TextStyle text22primaryShadow;

  changeDarkMode(){
    darkMode = !darkMode;
    init();
  }

  init(){
    if (darkMode) {
      colorBackground = _backgroundDarkColor;
      colorDefaultText = _backgroundColor;
      primarySwatch = black;
      colorBackgroundGray = Colors.white.withOpacity(0.1);
      colorBackgroundDialog = colorDarkModeLight;
      Color _color2 = Color.fromARGB(80, 80, 80, 80);
      colorsGradient = [_color2, Colors.black];
    }else {
      Color _color2 = Color.fromARGB(80, colorPrimary.red, colorPrimary.green, colorPrimary.blue);
      colorsGradient = [_color2, colorPrimary];
      colorBackgroundGray = Colors.black.withOpacity(0.01);
      colorBackgroundDialog = _backgroundColor;
      colorBackground = _backgroundColor;
      colorDefaultText = _backgroundDarkColor;
      primarySwatch = black;//white;
    }

    text10white = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 10,
    );

    text12grey = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );

    text12bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 12,
    );

    text12Ubold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      decoration: TextDecoration.lineThrough,
      fontSize: 12,
    );
    text10UYellow = TextStyle(
      color: colorCompanionYellow,
      decoration: TextDecoration.lineThrough,
      fontFamily: 'Avenir Medium',
      fontSize: 10,
    );
    text12YellowUbold = TextStyle(
      color: colorCompanionYellow,
      fontWeight: FontWeight.w800,
      decoration: TextDecoration.lineThrough,
      fontSize: 12,
    );

    text14 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14l = TextStyle(
      decoration: TextDecoration.lineThrough,
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14R = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14primary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14purple = TextStyle(
      color: Colors.purple,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
    text14bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );

    text14boldPimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );

    text14grey = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
    text15link = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.underline,
    );

    text14boldWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );
    if (Platform.isAndroid) {
      text14boldWhite2 = TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          fontFamily: 'Avenir Medium Oblique',
          fontStyle: FontStyle.italic
      );
      text14White2 = TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontFamily: 'Avenir Medium',
      );
    } else if (Platform.isIOS) {
      text14boldWhite2 = TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          fontFamily: 'Avenir Medium Oblique',
          fontStyle: FontStyle.italic
      );
      text14White2 = TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontFamily: 'Avenir Medium',
      );
    }



    text14boldWhiteShadow = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 14,
        shadows: [
          Shadow(
              offset: Offset(1, 1),
              color: Colors.black,
              blurRadius: 1
          ),
        ]
    );
    text40boldWhiteShadow = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 40,
        fontFamily: 'Avenir Medium',
        fontStyle: FontStyle.italic,
        shadows: [
          Shadow(
              offset: Offset(1, 1),
              color: colorPrimary,
              blurRadius: 2
          ),
        ]
    );

    text16bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );
    text162 = TextStyle(
      color: white,
      // fontWeight: FontWeight.w200,
      fontFamily: 'Avenir Medium',
      fontSize: 16,
        fontStyle: FontStyle.normal
    );
    text142 = TextStyle(
      color: white,
      // fontWeight: FontWeight.w200,
      fontFamily: 'Avenir Light',
      fontSize: 14,
        fontStyle: FontStyle.normal
    );
    text13avenir = TextStyle(
      color: colorHeaderPedidos,
      fontSize: 13,
      fontFamily: 'Avenir Light',
      fontStyle: FontStyle.normal
    );
    text13avenirItalic = TextStyle(
      color: colorHeaderPedidos,
      fontSize: 13,
      fontFamily: 'Avenir Medium Oblique',
      fontStyle: FontStyle.italic
    );
    text14Restaurante = TextStyle(
      color: colorHeaderRestaurante,
      fontSize: 15,
      fontFamily: 'Avenir Medium',
      // fontStyle: FontStyle.italic
    );
    text14TipServ = TextStyle(
      color: colorHeaderTipServ,
      fontSize: 14,
      fontFamily: 'Avenir Black',
      fontWeight: FontWeight.w700,
      // fontStyle: FontStyle.italic
    );
    text14StatusEntregado = TextStyle(
      color: colorHeaderStatusEntregado,
      fontSize: 14,
      fontFamily: 'Avenir Medium',
    );
    text18total = TextStyle(
      color: colorHeaderTipServ,
      fontSize: 18,
      fontFamily: 'Avenir Black',
      fontWeight: FontWeight.w700,
    );
    text14StatusCancelado = TextStyle(
      color: colorHeaderStatusCancelado,
      fontSize: 14,
      fontFamily: 'Avenir Medium',
    );
    text14Status = TextStyle(
      color: colorHeaderStatus,
      fontSize: 14,
      fontFamily: 'Avenir Medium',
    );

    text16Ubold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      decoration: TextDecoration.lineThrough,
      fontSize: 16,
    );

    text16boldWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );
    text16boldYellow = TextStyle(
      color: theme.colorCompanionYellow,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );
    text16Yellow = TextStyle(
      color: theme.colorCompanionYellow,
      fontSize: 16,
    );
    text16White = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );

    text16 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );

    text16Red = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );

    text16UI = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );
    text16UIWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );

    text16Companyon = TextStyle(
      color: colorCompanion,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );
    text14Companyon = TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );
    text16yellow = TextStyle(
      color: Colors.yellow,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );
    text16blue = TextStyle(
      color: Colors.lightBlueAccent,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );
    text16CompanyonNoBold = TextStyle(
      color: colorCompanion,
      fontSize: 16,
    );

    text18boldPrimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );

    text18boldPrimaryUI = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 18,
    );
    
    text18boldPrimaryUIWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 18,
    );

    text18bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 18,
    );

    text20bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20boldPrimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );

    text20boldWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20negative = TextStyle(      // text negative color
      color: colorBackground,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );

    text22primaryShadow = TextStyle(      // text negative color
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 22,
        shadows: [
          Shadow(
              offset: Offset(1, 1),
              color: Colors.black,
              blurRadius: 1
          ),
        ]
    );
  }

  setAppSettings(){

    if (appSettings.mainColor != null){
      colorPrimary = appSettings.mainColor;
      pref.set(Pref.uiMainColor, appSettings.mainColor.value.toRadixString(16));
    }
    text16UI = TextStyle(
      color: theme.colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: appSettings.restaurantCardTextSize-3,
    );
    text16UIWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: appSettings.restaurantCardTextSize-3,
    );
    theme.text18boldPrimaryUI = TextStyle(
      color: appSettings.restaurantCardTextColor,
      fontWeight: FontWeight.w800,
      fontSize: appSettings.restaurantCardTextSize,
    );
    theme.text18boldPrimaryUIWhite = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: appSettings.restaurantCardTextSize,
    );

    var lid = int.parse(appSettings.appLanguage);
    var user = pref.get(Pref.userSelectLanguage);
    if (user != "true")
      strings.setLang(lid);  // set default language
  }
}

//
// Colors
//
var _backgroundColor = Colors.white;
var _backgroundDarkColor = Color(0xFF262626);


const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

const MaterialColor black = const MaterialColor(
  0xFF000000,
  const <int, Color>{
    50: const Color(0xFF000000),
    100: const Color(0xFF000000),
    200: const Color(0xFF000000),
    300: const Color(0xFF000000),
    400: const Color(0xFF000000),
    500: const Color(0xFF000000),
    600: const Color(0xFF000000),
    700: const Color(0xFF000000),
    800: const Color(0xFF000000),
    900: const Color(0xFF000000),
  },
);


