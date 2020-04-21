import 'package:password/password.dart';

class User {

  int id, confirm;
  String phone, studentId, name, email, password, pin, date;

  User(this.phone, this.studentId, this.name, this.email, this.password, this.pin, this.date, this.confirm);

  User.withId(this.id, this.phone, this.studentId, this.name, this.email, this.password, this.pin, this.date, this.confirm);

  User.fromJson(Map json)
    : id        = json['id'],
			phone     = json['phone'],
      studentId = json['studentId'],
      name      = json['name'],
      email     = json['email'],
      password  = json['password'],
			pin       = json['pin'],
      date      = json['date'],
			confirm   = json['confirm'];

  Map<String, dynamic> toMap() {
		var map = Map<String, dynamic>();
		if (id != null) map['id'] = id;
		map['phone']     = phone;
		map['studentId'] = studentId;
    map['name']      = name;
    map['email']     = email;
    map['password']  = Password.hash(password, PBKDF2());
		map['pin']       = Password.hash(pin, PBKDF2());
    map['date']      = date;
		map['confirm']   = confirm;
		return map;
	}

  User.fromDb(Map map)
		: id        = map['id'],
			phone     = map['phone'],
      studentId = map['studentId'],
      name      = map['name'],
      email     = map['email'],
      password  = map['password'],
			pin       = map['pin'],
      date      = map['date'],
			confirm   = map['confirm'];
}
