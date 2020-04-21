import 'dart:convert';
import 'package:http/http.dart' as http;

import '../global.dart';

class LoadTypeAPIController {

	Future<dynamic> loadType() async {
		final response = await http.get(LOAD_TYPE);
		final responseData = json.decode(response.body);
		final statusCode = response.statusCode;

		return returnResult(statusCode, responseData['load'], responseData['error']);
	}

	returnResult(status, success, error) {
		var response = (status == 200)
			? {"statusCode" : status, "result" : success}
			: {"statusCode" : status, "result" : error};

		return json.encode(response);
	}

}
