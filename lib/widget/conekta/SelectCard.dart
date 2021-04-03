import 'package:flutter/material.dart';
//##import file to get settings
import '../../ui/main/home.dart';
import '../../model/payments/Conekta.dart';
import '../../classes/ConektaCustomer.dart';
import '../../classes/ConektaPaymentSource.dart';

class SelectCard extends StatelessWidget
{
	String customerId;
	
	SelectCard({this.customerId);
	
	@override
	Widget build(BuildContext context)
	{
		return Scaffold(
			appBar: AppBar(title: Text('Seleccione una tarjeta')),
			body: Container(
				padding: EdgeInsets.all(10),
				child: this._buildList(context)
			)
		);
	}
	Widget _buildList(BuildContext context)
	{
		print('PAYMENTS: ${homeScreen.mainWindowData.payments.conektaSecretKey}');
		var conekta = Conekta(apiKey: homeScreen.mainWindowData.payments.conektaKey, privateKey: homeScreen.mainWindowData.payments.conektaSecretKey);
		return FutureBuilder<ConektaCustomer>(
			future: conekta.readCustomer(this.customerId),
			builder: (ctx, snapshot)
			{
				if( snapshot.hasData )
				{
					var customer = (snapshot.data as ConektaCustomer);
					return ListView.builder(
						itemCount: customer.payment_sources.length,
						itemBuilder: (ctx, index)
						{
							var psource = customer.payment_sources[index] as ConektaPaymentSource;
							return Card(
								child: ListTile(
									leading: Icon(Icons.credit_card),
									title: Text(psource.name + ' (' + psource.brand + ')'),
									subtitle: Text('xxxx xxxx xxxx '.toUpperCase() + psource.last4),
									onTap: ()
									{
										Navigator.pop(context, psource);
									},
								),
							);
						},
					);
				}
				return Center(
					child: CircularProgressIndicator()
				);
			},
		);
	}
}