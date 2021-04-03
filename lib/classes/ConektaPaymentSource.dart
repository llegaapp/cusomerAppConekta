class ConektaPaymentSource
{
	String		id;
	String		name;
	int			exp_month;
	int			exp_year;
	String		object;
	String		type;
	int			created_at;
	String		last4;
	String		brand;
	String		parent_id;
	String		token_id;
	String		bin;
	ConektaPaymentSource()
	{
		
	}
	ConektaPaymentSource.fromMap(Map<dynamic, dynamic> data)
	{
		this.loadData(data);
	}
	void loadData(Map<dynamic, dynamic> data)
	{
		if( data == null )
			return;
		this.id			= data['id'];
		this.name		= data['name'];
		this.exp_month	= int.parse(data['exp_month']);
		this.exp_year	= int.parse(data['exp_year']);
		this.object		= data['object'];
		this.type		= data['type'];
		this.created_at	= data['created_at'];
		this.last4		= data['last4'];
		this.brand		= data['brand'];
		this.parent_id	= data['parent_id'];
		this.bin		= data['bin'] ?? '';
		if( data['token_id'] != null )
			this.token_id = data['token_id'];
	}
	Map<String, dynamic> toMap()
	{
		return {
			'token_id': this.token_id,
			'type': this.type
		};
	}
}