import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fooddelivery/ui/main/home.dart';

class PayStackModel{

  handleCheckout(double amount, String email, BuildContext context) async {

    await PaystackPlugin.initialize(
        publicKey: homeScreen.mainWindowData.payments.payStackKey);

    Charge charge = Charge()
      ..amount = (amount * 100).toInt()
      ..email = email;
    //..card = _getCardFromUI();

//    if (!_isLocal()) {
//      var accessCode = await _fetchAccessCodeFrmServer(_getReference());
//      charge.accessCode = accessCode;
//    } else {
//      charge.reference = _getReference();
//    }
    charge.reference = 'PayStack_${DateTime.now().millisecondsSinceEpoch}';

    CheckoutResponse response = await PaystackPlugin.checkout(context,
        method: CheckoutMethod.card, charge: charge, fullscreen: true, hideEmail: true);
    if (response.message == 'Success') {
      return response.reference;
    }
    return null;
  }

}

