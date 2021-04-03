import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../server/getOrders.dart';
import '../../classes/ConektaTokenData.dart';
import '../../classes/ConektaOrder.dart';
import '../../classes/ConektaCustomer.dart';
import 'package:fooddelivery/model/account.dart';
import 'package:fooddelivery/model/basket.dart';

class Conekta
{
	String	apiKey;
	String	privateKey;
	
	String	version = '2.0.0';
	
	Conekta({this.apiKey, this.privateKey})
	{
		
	}
	Map<dynamic, dynamic> buildOrder(String token, Basket basket, Account account)
	{
		var order = {
			'currency': 'MXN',
			'customer_info': {
				'name': account.businessName,
				'phone': account.phone,
				'email': account.email
			},
			'line_items': [],
			'charges': [
				{
					'payment_method': {
						'type': 'card',
						'token_id': token
					}
				}
			],
			'metadata': {
				'order_id': basket.orderid
			},
			
		};
		
		return order;
	}
	Map<String, String> _getHeaders()
	{
		String auth = base64.encode(utf8.encode(this.privateKey + ':'));
		return <String, String>{
			'Accept': 'application/vnd.conekta-v2.0.0+json',
			'Content-type': 'application/json',
			HttpHeaders.authorizationHeader: 'Basic $auth'
		};
	}
	Future<ConektaOrder> createOrder(ConektaTokenData tdata, Basket basket, double total, Account account) async
	{
		print('CREATING ORDER for: ${account.email}');
		var order 			= this.buildOrder(tdata.id, basket, account);
		//##crear cliente
		var customer = await this.createCustomerFromMap({
			'name': order['customer_info']['name'],
			'phone': order['customer_info']['phone'],
			'email': order['customer_info']['email'],
			'payment_sources': [
				{
					'token_id': tdata.id,
					'type': 'card'
				}
			]
		});
		print('CONEKTA CUSTOMER CREATED: ${customer.id}');
		order['customer_info'] = {
			'customer_id': customer.id, 
			//'customer_id': 'cus_2pWaQmCmAfm5eTw4L',
		};
		(order['line_items'] as List).add({
			'name': 'Compras en Delivery Llega',
			'unit_price': total.toStringAsFixed(2).replaceAll('.', ''),
			'quantity': 1
		});
		
		String raw_json = json.encode(order);
		print('ORDER DATA: $raw_json');
		var headers = this._getHeaders();
		http.Response res = await http.post('https://api.conekta.io/orders', headers: headers, body: raw_json);
		print('CONEKTA ORDER RESPONSE: ${res.body}');
		if( res.statusCode != 200 )
			throw new Exception('Error al crear el pedido en conekta');
		var rdata = json.decode(res.body);
		
		return ConektaOrder.fromMap(rdata);
	}
	Future<void> captureOrder(String orderId) async
	{
		String endpoint = 'https://api.conekta.io/orders/$orderId/capture';
		http.Response res = await http.post(endpoint, headers: this._getHeaders());
		if( res.statusCode != 200 )
			throw new Exception('Error al capturar el pedido conekta');
		
	}
	Future<void> readOrder(String orderId)
	{
		String endpoint = 'https://api.conekta.io/orders/$orderId';
	}
	Future<ConektaCustomer> createCustomer(ConektaCustomer customer) async
	{
		String endpoint = 'https://api.conekta.io/customers';
		
		return this.createCustomerFromMap(customer.toMap());
		
	}
	Future<ConektaCustomer> createCustomerFromMap(Map<String, dynamic> customer) async
	{
		String endpoint = 'https://api.conekta.io/customers';
		if( customer.containsKey('id') )
			customer.remove('id');
		
		http.Response res = await http.post(endpoint, headers: this._getHeaders(), body: json.encode(customer));
		
		if( res.statusCode != 200 )
		{
			print(customer);
			print(res.body);
			throw new Exception('Error al crear cliente conekta');
		}	
			
		var cdata = json.decode(res.body);
		var ncustomer = ConektaCustomer.fromMap(cdata);
		
		return ncustomer;
	}
	Future<ConektaCustomer> updateCustomer(ConektaCustomer customer) async
	{
		String endpoint = 'https://api.conekta.io/customers/${customer.id}';
		var cdata = customer.toMap();
		http.Response res = await http.put(endpoint, headers: this._getHeaders(), body: json.encode(cdata));
		if( res.statusCode != 200 )
			throw new Exception('Error al actualizar el cliente conekta');
		
		cdata = json.decode(res.body);
		
		customer.loadData(cdata);
		
		return customer;
	}
	Future<bool> deleteCustomer(ConektaCustomer customer) async
	{
		String endpoint = 'https://api.conekta.io/customers/${customer.id}';
		http.Response res = await http.delete(endpoint);
		if( res.statusCode != 200 )
			throw new Exception('Error al actualizar el cliente conekta');
		return true;
	}
	Future<ConektaCustomer> readCustomer(String id) async
	{
		String endpoint = 'https://api.conekta.io/customers/$id';
		http.Response res = await http.get(endpoint, headers: this._getHeaders());
		print(res.body);
		if( res.statusCode != 200 )
			throw new Exception('Error al obtener el cliente conekta');
		var customer = new ConektaCustomer.fromMap(json.decode(res.body));
		
		return customer;
	}
}