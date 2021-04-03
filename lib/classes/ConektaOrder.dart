import 'ConektaOrderItem.dart';
import 'ConektaCharge.dart';

class ConektaOrder
{
	bool					livemode;
	int						amount;
	String					currency;
	String					payment_status;
	int						amount_refunded;
	Map<String, dynamic>	customer_info = {};
	String					object;
	String					id;
	Map<String, dynamic>	metadata = {};
	int						created_at;
	int						updated_at;
	List<ConektaOrderItem>	line_items = [];
	List<ConektaCharge>		charges = [];
	
	ConektaOrder.fromMap(Map<dynamic, dynamic> data)
	{
		this.loadData(data);
	}
	void loadData(Map<dynamic, dynamic> data)
	{
		if( data == null )
			return;
			
		this.livemode			= data['livemode'];
		this.amount				= data['amount'];
		this.currency			= data['currency'];
		this.payment_status		= data['payment_status'];
		this.amount_refunded	= data['amount_refunded'];
		this.customer_info		= data['customer_info'];
		this.object				= data['object'];
		this.id					= data['id'];
		this.metadata			= data['metadata'];
		this.created_at			= data['created_at'];
		this.updated_at			= data['updated_at'];
		if( data['line_items'] != null && data['line_items']['data'] != null )
		{
			this.line_items.clear();
			(data['line_items']['data'] as List).forEach((oi)
			{
				this.line_items.add( ConektaOrderItem.fromMap(oi) );
			});
		}
		if( data['charges'] != null && data['charges']['data'] != null )
		{
			this.charges.clear();
			(data['charges']['data'] as List).forEach( (c) 
			{
				this.charges.add( ConektaCharge.fromMap(c) );
			});
		}	
	}
}