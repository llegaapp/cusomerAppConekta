import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'dart:convert';

//##import account data
import '../../main.dart' as main;
//##import file to get basket instance
import '../../ui/main/mainscreen.dart';
import '../../model/utils.dart' as utils;
//##import file to get settings
import '../../ui/main/home.dart';
import '../../classes/ConektaTokenData.dart';
import '../../model/payments/Conekta.dart';
import '../../classes/ConektaOrder.dart';
import '../../classes/ConektaPaymentSource.dart';
import 'SelectCard.dart';

class CardForm extends StatefulWidget
{
	@override
	_CardFormState	createState() => _CardFormState();
}

class _CardFormState extends State<CardForm>
{
	final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	String cardNumber 		= '';
	String expiryDate 		= '';
	String cardHolderName 	= '';
	String cvvCode 			= '';
	bool isCvvFocused 		= false;
	final GlobalKey<FormState> formKey = GlobalKey<FormState>();
	bool	dataOk = false;
	bool	processing = false;
	
	@override
	void initState()
	{
		super.initState();
	}
	@override
	Widget build(BuildContext context)
	{
		return Scaffold(
			key: this._scaffoldKey,
			appBar: AppBar(title: Text('Datos de tu tarjeta'),
				actions: [
					IconButton(
						tooltip: 'Seleccionar tarjeta',
						icon: Icon(Icons.list_alt, color: Colors.white,),
						onPressed: () async
						{
							this._chooseCard();
						},
					)
				],
			),
			body: Container(
				child: ListView(
					children: [
						CreditCardWidget(
			                cardNumber: this.cardNumber,
			                expiryDate: this.expiryDate,
			                cardHolderName: this.cardHolderName,
			                cvvCode: this.cvvCode,
			                showBackView: this.isCvvFocused,
			                obscureCardNumber: !true,
			                obscureCardCvv: !true,
						),
						SizedBox(height: 15),
						CreditCardForm(
	                        formKey: formKey,
	                        obscureCvv: true,
	                        obscureNumber: true,
	                        cardNumber: cardNumber,
	                        cvvCode: cvvCode,
	                        cardHolderName: cardHolderName,
	                        expiryDate: expiryDate,
	                        themeColor: Colors.blue,
							onCreditCardModelChange: this.onCreditCardModelChange,
						),
						if( this.dataOk )
							SizedBox(
								height: 10,
								child: ClipRect(
									child: this._buildWebview(),
								),
							),
						SizedBox(height: 20),
						Container(
							padding: EdgeInsets.all(10),
							child: FlatButton(
								color: Colors.red,
								textColor: Colors.white,
								child: Container(
									padding: EdgeInsets.all(7),
									child: this.processing ? CircularProgressIndicator(backgroundColor: Colors.white,) : Text('Proceder con el pago'),
								),
								onPressed: ()
								{
									if( this.processing )
										return;
									if( this.cardNumber.isEmpty || this.expiryDate.isEmpty || this.cardHolderName.isEmpty || this.cvvCode.isEmpty )
										return;
										
									this.setState(() 
									{
										this.dataOk = true;
									});
								},
							)
						)
					]
				)
			)
		);
	}
	void onCreditCardModelChange(CreditCardModel creditCardModel) 
	{
		if( creditCardModel == null )
			return;
		this.setState(() {
			this.cardNumber 	= creditCardModel.cardNumber;
			this.expiryDate 	= creditCardModel.expiryDate;
			this.cardHolderName = creditCardModel.cardHolderName;
			this.cvvCode 		= creditCardModel.cvvCode;
			this.isCvvFocused 	= creditCardModel.isCvvFocused;
			
		});
	}
	Widget _buildWebview()
	{
		this.processing 				= true;
		List<String> parts 				= this.expiryDate.split('/');
		String		conektaPublicKey	= homeScreen.mainWindowData.payments.conektaKey;
		String html = '''
		<!doctype html>
		<html>
		<head>
		<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
		<script type="text/javascript" src="https://cdn.conekta.io/js/latest/conekta.js"></script>
		</head>
		<body>
		<h1>hhh</h1>
		<form id="form-conekta" method="post">
			<input type="text" data-conekta="card[number]" value="${this.cardNumber}" /><br/>
			<input type="text" data-conekta="card[name]" value="${this.cardHolderName}" />
			<input type="text" data-conekta="card[exp_month]" value="${parts[0]}" />
			<input type="text" data-conekta="card[exp_year]" value="${parts[1]}" />
			<input type="text" data-conekta="card[cvc]" value="${this.cvvCode}" />
		</form>
		<script>
		let form = document.querySelector('#form-conekta');
		console.log(form);
		var conektaErrorResponseHandler = function(response) {
			console.log('ERROR', JSON.stringify(response));
			app_error_handler.postMessage(JSON.stringify(response));	
		};
	
		var conektaSuccessResponseHandler = function(response) {
			console.log('SUCCESS', JSON.stringify(response));
			app_success_handler.postMessage(JSON.stringify(response));
		};
		Conekta.setPublishableKey('$conektaPublicKey');
		Conekta.token.create(form, conektaSuccessResponseHandler, conektaErrorResponseHandler);
		
		</script>
		</body>
		</html>
		''';
		return WebView(
			initialUrl: Uri.dataFromString(html, mimeType: 'text/html').toString(),
			javascriptMode: JavascriptMode.unrestricted,
			//userAgent: 'Delivery application V1.0.0',
			javascriptChannels: <JavascriptChannel>[
				JavascriptChannel(
					name: 'app_success_handler', 
					onMessageReceived: (JavascriptMessage msg)
					{
						print('CONEKTA SUCCESS HANDLER');
						var data = json.decode(msg.message);
						var tdata = ConektaTokenData.fromMap(data);
						this.setState(() {
							this.dataOk = false;
						});
						this._processPayment(tdata);
					}
				),
				JavascriptChannel(
					name: 'app_error_handler', 
					onMessageReceived: (JavascriptMessage msg)
					{
						print('CONEKTA ERROR HANDLER');
						print(msg.message);
						var error = json.decode(msg.message);
						this.setState(() {
							this.processing = false;
							this.dataOk = false;
						});
						this._scaffoldKey.currentState.showSnackBar(SnackBar(
							backgroundColor: Colors.red,
							content: Text(error['message'] ?? 'Ocurrio un error al procesar el pago'),
						));
					}
				),
			].toSet()
		);
	}
	Future<void> _processPayment(ConektaTokenData tdata) async
	{
		print('PROCESSING PAYMENT');
		double total		= basket.getTotal(true);// .toStringAsFixed(appSettings.symbolDigits);
    	String ticketcode 	= utils.sha1Ticketcode();
		var conekta 		= Conekta(apiKey: homeScreen.mainWindowData.payments.conektaKey, privateKey: homeScreen.mainWindowData.payments.conektaSecretKey);
		
		try
		{
			ConektaOrder order = await conekta.createOrder(tdata, basket, total, main.account);
			Navigator.pop(this.context, order);
			this._scaffoldKey.currentState.showSnackBar(SnackBar(
				backgroundColor: Colors.green,
				content: Text('Pago procesado correctamente'),
			));
			this.setState(() {
				this.processing = false; 
			});
		}
		catch(e)
		{
			this.setState(() {
				this.processing = false; 
			});
			
			print(e);
			this._scaffoldKey.currentState.showSnackBar(SnackBar(
				backgroundColor: Colors.red,
				content: Text('Ocurrio un error al procesar el pago'),
			));
		}
		
	}
	Future<void> _chooseCard() async
	{
		var payment_source = await Navigator.push(context, MaterialPageRoute(builder: (_) => SelectCard(customerId: 'cus_2pWaQmCmAfm5eTw4L',)));
		print('CARD SELECTED: ${payment_source.id}');
		this._scaffoldKey.currentState.showSnackBar(SnackBar(
			backgroundColor: Colors.red,
			content: Text('Tarjeta seleccionada: ${payment_source.name}:${payment_source.last4}:${payment_source.brand}'),
		));
		this.setState(() 
		{
			this.processing = true;
			this._processPayment(ConektaTokenData.fromMap({
				'id': payment_source.id,
			})); 
		});
	}
}