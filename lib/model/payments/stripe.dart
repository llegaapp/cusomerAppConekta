import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/ui/main/home.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class Stripe{

  init(){
    var stripeId = homeScreen.mainWindowData.payments.stripeKey;
    StripePayment.setOptions(
        StripeOptions(
            publishableKey: stripeId,
            merchantId: "Test", //YOUR_MERCHANT_ID
            androidPayMode: 'test'
        ));
  }

  // final CreditCard testCard = CreditCard(
  //   number: '4000002760003184',
  //   expMonth: 12,
  //   expYear: 21,
  // );

  // void openCheckout(int amount, String desc, String clientPhone, String companyName,
  //     Function(String) onSuccess, Function(String) onError){
  //     StripePayment.createSourceWithParams(SourceParams(
  //     type: 'ideal',
  //     amount: amount,
  //     currency: 'usd',
  //     returnURL: 'example://stripe-redirect',
  //   )).then((source) {
  //       dprint(source.sourceId);
  //       onSuccess("Stripe ${source.sourceId}");
  //   }).catchError(setError);
  // }


  createPaymentIntent(String amount, String currency, String ticketCode) async {
    var stripeSecret = homeScreen.mainWindowData.payments.stripeSecretKey;

    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Authorization' : "Bearer $stripeSecret",
      };

      Map<String, dynamic> body= {
      "amount": amount, 
      "currency" : currency, 
      "description": "Orden #$ticketCode llega delivery", 
      "metadata[order_id]":  ticketCode,
      "payment_method_types[]": "card"
      }; 
      
      var url = "https://api.stripe.com/v1/payment_intents";
      var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 10));

      dprint(url);
      dprint('Response status STRIPE: ${response.statusCode}');
      dprint('Response body: ${response.body}');
      var result = json.decode(response.body);
      //var sec = result['client_secret'];
      //dprint('Response body: $sec');
      return result;
    } catch (ex) {
      print (ex);
    }
    return null;
  }

  Function(String) _onError;

  Future<void> openCheckoutCard(int amount, String desc, String clientPhone, String companyName, String currency,
      Function(String,String) onSuccess, Function(String) onError) async {
    _onError = onError;
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).catchError(setError);
     
      var now = new DateTime.now();
      var bytes = utf8.encode(now.toString()); // data being hashed
      print(now.toString());
      var ticketCode = sha1.convert(bytes);
      String ticketCode1 = ticketCode.toString().substring(0,10);
      print(ticketCode1);
      print(paymentMethod);
      var paymentIntent = await createPaymentIntent(amount.toString(), currency,ticketCode1);
      dprint('Paso paymentIntent ok');
      /*if (paymentIntent == null)
        return onError("error1");
      dprint(paymentIntent);*/
      var sec = paymentIntent['client_secret'];
      var response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: sec,
          paymentMethodId: paymentMethod.id,
        ),
      ).catchError(setError);
      print(response);
      onSuccess("Payment $currency${amount/100} Stripe:${response.paymentIntentId}",ticketCode1);
      return true;
  }

  setError(dynamic error){
    if (_onError != null)
      _onError(error.code); // may be cancelled
    dprint(error);
  }

}