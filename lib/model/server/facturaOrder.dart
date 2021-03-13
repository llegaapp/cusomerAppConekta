import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
facturaOrder(String orderid,String uid,String rfc,String businessName, String UsoCFDI, String email, Function( String ) callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"id" : ${json.encode(orderid)},'
        ' "RFC": ${json.encode(rfc)}, '
        ' "RazonSocial": ${json.encode(businessName)}, '
        '"UsoCFDI": ${json.encode(UsoCFDI)}, "emailFactura": ${json.encode(email)} }';
    //print( "send: "+body);
    var url = "${serverPath}facturaOrder";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      //print( 'restponse 200' );

      var jsonResult = json.decode(response.body);
      var curbsidePickup = jsonResult["curbsidePickup"];

      var UUIDRestaurant = jsonResult["restaurante"]['original']['UUID'];
      var timbrarRestaurant = jsonResult["restaurante"]['original']['timbrar'];

      //var UUIDrestauranteServ = jsonResult["restauranteServ"]['original']['UUID'];
      //var timbrarrestauranteServ= jsonResult["restauranteServ"]['original']['timbrar'];

      var UUIDdriver = jsonResult["driver"]['original']['UUID'];
      var timbrardriver= jsonResult["driver"]['original']['timbrar'];

      //var UUIDdriverServ = jsonResult["driverServ"]['original']['UUID'];
      //var timbrardriverServ = jsonResult["driverServ"]['original']['timbrar'];

      print( 'curbsidePickup:' );
      print( curbsidePickup );
      print( 'UUIDRestaurant:' );
      print( UUIDRestaurant );
      print( 'timbrarRestaurant:' );
      //print( timbrarRestaurant );
      //print( 'UUIDrestauranteServ:' );
      //print( UUIDrestauranteServ );
      print( 'UUIDdriver:' );
      print( UUIDdriver );
     // print( 'UUIDdriverServ:' );
      //print( UUIDdriverServ );
      if( curbsidePickup=='true' ){
        if ( UUIDRestaurant != null) {
           callback( strings.get(309) + 'UUID: '+UUIDRestaurant ) ;
        }else {
          var errorTimbrado='';
          errorTimbrado = timbrarRestaurant['Incidencias']['Incidencia']['MensajeIncidencia'];
          print( 'errorTimbrado ' );
          print( errorTimbrado );
          callbackError(  strings.get(309) +errorTimbrado );
        }
      }else{
        if ( UUIDRestaurant != null &&  UUIDdriver != null) {
          callback( UUIDRestaurant ) ;
          callback(  strings.get(309) + 'UUID: '+UUIDRestaurant+'\n\n'+strings.get(309) + 'UUID: '+ UUIDdriver);
        }else {
          var errorTimbrado='';
          if ( UUIDRestaurant == null ) {
            errorTimbrado = errorTimbrado+ strings.get(309) + timbrarRestaurant['Incidencias']['Incidencia']['MensajeIncidencia']+'\n';
            print( 'errorTimbrado ' );
            print( errorTimbrado );
          }if ( UUIDdriver == null ) {
            errorTimbrado = errorTimbrado+ strings.get(310) +timbrardriver['Incidencias']['Incidencia']['MensajeIncidencia']+'\n';
            print( 'errorTimbrado ' );
            print( errorTimbrado );
          }

          callbackError( errorTimbrado );
        }

      }
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}
