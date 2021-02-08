import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fooddelivery/main.dart';

double toDouble(String str){
  double ret = 0;
  try {
    ret = double.parse(str);
  }catch(_){}
  return ret;
}

int toInt(String str){
  int ret = 0;
  try {
    ret = int.parse(str);
  }catch(_){}
  return ret;
}

bool toBool(String str){
  return  (str == "true") ? true : false;
}

bool isNumeric( String s ) {

  if ( s.isEmpty ) return false;

  final n = num.tryParse(s);

  return ( n == null ) ? false : true;

}

bool isEmail( String email ) {

  if ( email.isEmpty ) return false;

  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp   = new RegExp(pattern);
   
  if ( regExp.hasMatch( email ) ) 
    return true;
  return false;

}

bool isRFC( String rfc ) {

  if ( rfc.isEmpty ) return false;

  //Pattern pattern = r'^[A-Z,�,&]{3,4}[0-9]{2}[0-1][0-9][0-3][0-9][A-Z,0-9]?[A-Z,0-9]?[0-9,A-Z]?$';
  //Pattern pattern = r'^[A-Z]{4}([0-9]{2})(1[0-2]|0[1-9])([0-3][0-9])([ -]?)([A-Z0-9]{4})$'; 
  //Pattern pattern = r'/^([A-Z�&]{3,4}) ?(?:- ?)?(\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])) ?(?:- ?)?([A-Z\d]{2})([A\d])$/';
  Pattern pattern = r'^([A-Z�\x26]{3,4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1]))([A-Z\d]{3})?$'; 
  
  RegExp regExp   = new RegExp(pattern);
  
  if ( regExp.hasMatch( rfc.toUpperCase().trim() ) ) 
    return true;
  return false;

}

validators(String _value, String _type)
  { 

    if(_type == 'empty')
    {
        return null;
    }

    if(_type == 'email')
    {
        if (isEmail(_value) ) {
          return null;
          } else {
          return strings.get(292); 
        }
    } 

    if(_type == 'number')
    {
      if(_value.isEmpty)
      return null;

        if (isNumeric(_value) ) {
          return null;
          } else {
          return strings.get(293); 
        }
    }
    
    if(_type == 'rfc')
    {
      if(_value.isEmpty)
      return null;

        if (isRFC(_value) ) {
          return null;
          } else {
          return strings.get(294); 
        }
    } 

    return null;
  }

  String sha1Ticketcode( {int limit = 10})
  {
      var now = new DateTime.now();
      var bytes = utf8.encode(now.toString()); // data being hashed
      
      var ticketCode = sha1.convert(bytes);
      String ticketCode1 = ticketCode.toString().substring(0,limit);
      return  ticketCode1;
  }