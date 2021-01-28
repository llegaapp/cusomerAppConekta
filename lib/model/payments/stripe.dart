import 'dart:convert';
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


  createPaymentIntent(String amount, String currency) async {
    var stripeSecret = homeScreen.mainWindowData.payments.stripeSecretKey;

    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Authorization' : "Bearer $stripeSecret",
      };

      Map<String, dynamic> body= {"amount": amount, "currency" : currency, "payment_method_types[]": "card"};
      var url = "https://api.stripe.com/v1/payment_intents";
      var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 10));

      dprint(url);
      dprint('Response status: ${response.statusCode}');
      dprint('Response body: ${response.body}');

      return json.decode(response.body);
    } catch (ex) {
      print (ex);
    }
    return null;
  }

  Function(String) _onError;

  Future<void> openCheckoutCard(int amount, String desc, String clientPhone, String companyName, String currency,
      Function(String) onSuccess, Function(String) onError) async {
    _onError = onError;
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).catchError(setError);
      print(paymentMethod);
      var paymentIntent = await createPaymentIntent(amount.toString(), currency);
      if (paymentIntent == null)
        return onError("error1");
      dprint(paymentIntent);
      var sec = paymentIntent['client_secret'];
      var response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: sec,
          paymentMethodId: paymentMethod.id,
        ),
      ).catchError(setError);
      print(response);
      onSuccess("Payment $currency${amount/100} Stripe:${response.paymentIntentId}");
      return true;
  }

  setError(dynamic error){
    if (_onError != null)
      _onError(error.code); // may be cancelled
    dprint(error);
  }

}