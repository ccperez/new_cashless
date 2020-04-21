import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:password/password.dart';

import '../global.dart';

class UserAPIController {

	Future<dynamic> registerUser(var user) async {
		user = json.decode(user);

		var data = {
				"phone"			: user['phone'],
				"studentId"	: user['studentId'],
				"name"			: user['name'],
				"email"			: user['email'],
				"password"	: Password.hash(user['password'], PBKDF2()),
				"pin"				: Password.hash(user['pin'], PBKDF2())
		};

		final response = await http.post(USER_SIGNUP, body: data);
		final responseData = json.decode(response.body);
		final statusCode = response.statusCode;

		return returnResult(statusCode, responseData['result'], responseData['error']);
	}

	Future<dynamic> confirmAccount(String phone) async {
		final response = await http.post(SIGNUP_CONFIRMED, body: {"phone" : phone});
		final responseData = json.decode(response.body);
		final statusCode = response.statusCode;

		return returnResult(statusCode, responseData['result'], responseData['error']);
	}

	Future<dynamic> signIn(String phone, String password) async {
		var data = {
			"phone"    : phone,
			"password" : Password.hash(password, PBKDF2())
		};

		final response = await http.post(USER_SIGNIN, body: data);
		final responseData = json.decode(response.body);
		final statusCode = response.statusCode;

		return returnResult(statusCode, responseData['result'], responseData['error']);
	}

	Future<dynamic> verifyForgetPassword(String phone) async {
		final response = await http.post(REQUEST_RESET_SECURE, body: {"phone" : phone});
		final responseData = json.decode(response.body);
		final statusCode = response.statusCode;

		return returnResult(statusCode, responseData['result'], responseData['error']);
	}

	Future<dynamic> verifyConfirmationCode(String confirmationCode) async {
		final response = await http.post(
			CONFIRMED_REQUEST_RESET_SECURE, body: {"confirmationCode" : confirmationCode}
		);
		final responseData = json.decode(response.body);
		final statusCode = response.statusCode;

		return returnResult(statusCode, responseData, responseData['error']);
	}

	Future<dynamic> updateFullname(String phone, String newname) async {
		final response = await http.post(
			UPDATE_FULLNAME, body: {"phone" : phone, "name" : newname}
		);
		final responseData = json.decode(response.body);
		final statusCode = response.statusCode;

		return returnResult(statusCode, responseData['result'], responseData['error']);
	}

	Future<dynamic> resetSecure(String type, String token, String newSecure, String cfmSecure) async {
		var data = {
			"type"      : type,
			"token"     : token,
			"newSecure" : Password.hash(newSecure, PBKDF2()),
			"cfmSecure" : Password.hash(cfmSecure, PBKDF2())
		};
		final response = await http.post(RESET_SECURE, body: data);
		final responseData = json.decode(response.body);
		final statusCode = response.statusCode;

		return returnResult(statusCode, responseData['result'], responseData['error']);
	}

	returnResult(status, success, error) {
		var response = (status == 200)
			? {"statusCode" : status, "result" : success}
			: {"statusCode" : status, "result" : error};

		return json.encode(response);
	}

}
