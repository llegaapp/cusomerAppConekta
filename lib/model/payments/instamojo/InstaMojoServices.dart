import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../../dprint.dart';


/*
Test card
  https://support.instamojo.com/hc/en-us/articles/208485675-Test-or-Sandbox-Account

*/

class InstaMojoServices {

  Future<String> getAccessToken(String userName, String amount, String apiKey, String token, String sandboxMode, String email, String phone) async {
    var url = "https://www.instamojo.com/api/1.1/payment-requests/"; // for release mode
    if (sandboxMode == "true")
      url = "https://test.instamojo.com/api/1.1/payment-requests/"; // for test mode
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        "Content-Type": "application/x-www-form-urlencoded",
        "X-Api-Key": apiKey,
        "X-Auth-Token": token
      };
      Map<String, String> body = {
        "amount": amount, //amount to be paid
        "purpose": "Advertising",
        "buyer_name": userName,
        "email": email,
        "phone": phone,
        "allow_repeated_payments": "true",
        "send_email": "false",
        "send_sms": "false",
        "redirect_url": "https://www.example.com/redirect/",
        // Where to redirect after a successful payment.
        "webhook": "http://www.example.com/webhook/",
      };
      dprint('Response body: $body');
      try {
        var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 10));
        dprint('Response status: ${response.statusCode}');
        dprint('Response body: ${response.body}');
        var jsonResult = json.decode(response.body);
        if (response.statusCode == 201) {
          if (jsonResult['success'] == true)
            return jsonResult["payment_request"]['longurl'];
        }
        errorText = jsonResult['message'].toString();
      } catch (ex) {
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  String errorText = "";

}