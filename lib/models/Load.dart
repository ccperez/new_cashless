
class Load {
  int loadId, loadAmt;
  String qrCode, date;

  Load(this.loadId, this.loadAmt, this.qrCode, this.date);
  Load.withId(this.loadId, this.loadAmt, this.qrCode, this.date);

  Load.fromJson(Map json)
    : loadId  = json['loadId'],
			loadAmt = json['loadAmt'],
			qrCode  = json['qrCode'],
			date    = json['date'];
			  
  Map<String, dynamic> toMap() {
		var map = Map<String, dynamic>();
		if (loadId != null) map['loadId'] = loadId;
		map['loadId']   = loadId;
		map['loadAmt']  = loadAmt;
		map['qrCode']   = qrCode;
		map['date']     = date;
		return map;
	}

  Load.fromDb(Map map)
		: loadId    = map['loadId'],
			loadAmt   = map['loadAmt'],
			qrCode    = map['qrCode'],
			date      = map['date']; 
}