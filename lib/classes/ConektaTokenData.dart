class ConektaTokenData
{
	String	id;
	bool	livemode;
	bool	used;
	String	object;
	
	ConektaTokenData();
	ConektaTokenData.fromMap(Map<String, dynamic> data)
	{
		this.loadData(data);
	}
	void loadData(Map<String, dynamic> data)
	{
		if( data == null )
			return;
			
		this.id 		= data['id'];
		this.livemode	= data['livemode'] ?? false;
		this.used		= data['used'] ?? false;
		this.object		= data['object'] ?? 'card';
	}
}