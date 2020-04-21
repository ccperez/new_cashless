
class Pay {
  int payId, payAmt;
  String qrCode, date;

  Pay(this.payId, this.payAmt, this.qrCode, this.date);
  Pay.withId(this.payId, this.payAmt, this.qrCode, this.date);

  Pay.fromJson(Map json)
    : payId   = json['payId'],
			payAmt  = json['payAmt'],
			qrCode  = json['qrCode'],
			date    = json['date'];
			  
  Map<String, dynamic> toMap() {
		var map = Map<String, dynamic>();
		if (payId != null) map['payId'] = payId;
		map['payId']    = payId;
		map['payAmt']   = payAmt;
		map['qrCode']   = qrCode;
		map['date']     = date;
		return map;
	}

  Pay.fromDb(Map map)
		: payId     = map['payId'],
			payAmt    = map['payAmt'],
			qrCode    = map['qrCode'],
			date      = map['date']; 
}