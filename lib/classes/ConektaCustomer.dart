import 'ConektaPaymentSource.dart';

class ConektaCustomer
{
	String		id;
	String		object;
	String		name;
	String		phone;
	String		email;
	bool		corporate = false;
	List<ConektaPaymentSource>		payment_sources = [];
	
	ConektaCustomer()
	{
		
	}
	ConektaCustomer.fromMap(Map<dynamic, dynamic> data)
	{
		this.loadData(data);
	}
	void loadData(Map<dynamic, dynamic> data)
	{
		if( data == null )
			return;
		this.id			= data['id'];
		this.object		= data['object'];
		this.name		= data['name'];
		this.phone		= data['phone'];
		this.email		= data['email'];
		if( data['payment_sources'] != null )
		{
			this.payment_sources.clear();
			if( data['payment_sources']['data'] is List)
				(data['payment_sources']['data'] as List).forEach((s)
				{
					this.payment_sources.add( ConektaPaymentSource.fromMap(s) );
				});
			else if( data['payment_sources']['data'] is Map )
				this.payment_sources.add( ConektaPaymentSource.fromMap( data['payment_sources']['data'] ) );
		}
	}
	Map<String, dynamic> toMap()
	{
		return {
			'name': this.name,
			'phone': this.phone,
			'email': this.email
		};
	}
}