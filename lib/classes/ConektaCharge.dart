class ConektaCharge
{
	String		id;
	bool		livemode;
	int			created_at;
	String		currency;
	String		device_fingerprint;
	Map<String, dynamic>		payment_method = {};
	String						object;
	String						description;
	String						status;
	int							amount;
	int							paid_at;
	int							fee;
	String						customer_id;
	String						order_id;
	
	ConektaCharge.fromMap(Map<dynamic, dynamic> data)
	{
		this.loadData(data);
	}
	void loadData(Map<dynamic, dynamic> data)
	{
		if( data == null )
			return;
		this.id					= data['id'];
		this.livemode			= data['livemode'];
		this.created_at			= data['created_at'];
		this.currency			= data['currency'];
		this.device_fingerprint	= data['device_fingerprint'];
		this.payment_method		= data['payment_method'];
		this.object				= data['object'];
		this.description		= data['description'];
		this.status				= data['status'];
		this.amount				= data['amount'];
		this.paid_at			= data['paid_at'];
		this.fee				= data['fee'];
		this.customer_id		= data['customer_id'];
		this.order_id			= data['order_id'];
	}
}