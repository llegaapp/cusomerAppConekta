class ConektaOrderItem
{
	String		name;
	int			unit_price;
	int			quantity;
	String		object;
	String		id;
	String		parent_id;
	
	ConektaOrderItem.fromMap(Map<dynamic, dynamic> data)
	{
		this.loadData(data);
	}
	void loadData(Map<dynamic, dynamic> data)
	{
		if( data == null )
			return;
		this.name 			= data['name'];
		this.unit_price		= data['unit_price'];
		this.quantity		= data['quantity'];
		this.object			= data['object'];
		this.id				= data['id'];
		this.parent_id		= data['parent_id'];
	}
}