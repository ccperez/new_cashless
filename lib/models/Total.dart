
class Total {
  int totalId, totalDeposit, totalExpenses, totalBal;

  Total(this.totalId, this.totalDeposit, this.totalExpenses, this.totalBal);
  Total.withId(this.totalId, this.totalDeposit, this.totalExpenses, this.totalBal);

  Total.fromJson(Map json)
    : totalId          = json['totalId'],
			totalDeposit     = json['totalDeposit'],
			totalExpenses    = json['totalExpenses'],
			totalBal         = json['totalBal'];
			  
  Map<String, dynamic> toMap() {
		var map = Map<String, dynamic>();
		if (totalId != null) map['totalId'] = totalId;
		map['totalId']        = totalId;
		map['totalDeposit']   = totalDeposit;
		map['totalExpenses']  = totalExpenses;
		map['totalBal']       = totalBal;
		return map;
	}

  Total.fromDb(Map map)
		: totalId         = map['totalId'],
			totalDeposit    = map['totalDeposit'],
			totalExpenses   = map['totalExpenses'],
			totalBal        = map['total Bal']; 
}