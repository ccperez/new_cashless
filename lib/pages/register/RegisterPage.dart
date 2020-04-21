import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../models/user.dart';
import '../../controller/users_controller.dart';
import '../../controller/user_api_controller.dart';
import '../../utilities/registration_utilities.dart';

class Register extends StatefulWidget {
	@override
	_RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
	var _formKey = GlobalKey<FormState>();

	ProgressDialog prgrsDlg;

	User user = User('', '', '', '', '', '', '', 0);

	UsersController users = UsersController();
	UserAPIController userAPI = UserAPIController();
	RegistrationUtilities register = RegistrationUtilities();

	final _phone = TextEditingController();
	final _studentId = TextEditingController();
	final _name = TextEditingController();
	final _email = TextEditingController();
	final _password = TextEditingController();
	final _pin =  TextEditingController();

	bool passwordVisible, pinVisible, _isSubmitting;
	bool _autoValidate = false;

	@override
	void initState() {
		super.initState();
		passwordVisible = true;
		pinVisible = true;
		_isSubmitting = false;
	}

	void dispose() {
		super.dispose();
		_phone.dispose();
		_studentId.dispose();
		_name.dispose();
		_email.dispose();
		_password.dispose();
		_pin.dispose();
	}

	@override
	Widget build(BuildContext context) {

		prgrsDlg = ProgressDialog(context);
		prgrsDlg.style(
			message: 'Please Wait...',
			borderRadius: 10.0,
			backgroundColor: Colors.white,
			progressWidget: CircularProgressIndicator(),
			elevation: 10.0,
			insetAnimCurve: Curves.easeInOut,
			progress: 0.0,
			maxProgress: 100.0,
			progressTextStyle: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
			messageTextStyle: TextStyle(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
		);

		return WillPopScope(
			onWillPop: () { register.navigatePreviousPage(context); },
			child: Scaffold(
				backgroundColor: Color(0xFF2c3e50),
				appBar: AppBar(
					title: Text('Registration'),
					backgroundColor: Color(0xFF2c3e50),
					leading: IconButton(icon: Icon(Icons.arrow_back),
						onPressed: () { register.navigatePreviousPage(context); }
					)
				),
				body: Form(
					key: _formKey,
					autovalidate: _autoValidate,
						child: Stack(
							fit: StackFit.expand,
							children: <Widget>[
								ListView(
									children: <Widget>[
										 Container(
											 margin: EdgeInsets.only(top: 20),
											 child: Column(
													mainAxisAlignment: MainAxisAlignment.center,
													children: <Widget>[
														textFormField(_phone, Icons. phone_android, 'Phone Number', 'Enter Phone Number', TextInputType.phone, false),
														textFormField(_studentId, Icons.perm_identity, 'School ID', 'Enter School ID Number', TextInputType.number, false),
														textFormField(_name, Icons.person, 'Name', 'Enter Full Name', TextInputType.text, false),
														textFormField(_email, Icons.email, 'Email', 'Enter Email Address', TextInputType.emailAddress, false),
														textFormField(_password, Icons.lock, 'Password', 'Enter a Password', TextInputType.text, passwordVisible),
														textFormField(_pin, Icons.vpn_key, 'Pin', 'Enter a Pin for payment', TextInputType.number, pinVisible),
														signupButton('Sign Up', TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400)),
													],
												),
										 ),
									],
								),
							],
						),
					),
				),
		);
	}

	var redBorder = OutlineInputBorder(
					borderRadius: BorderRadius.circular(15),
					borderSide: BorderSide(color: Colors.redAccent, width: 2)
				);

	var greenBorder = OutlineInputBorder(
					borderRadius: BorderRadius.circular(15),
					borderSide: BorderSide(color: Colors.greenAccent, width: 2)
				);

	Widget textFormField(txtController, icnText, lblText, hntText, keyType, blnObscure) => Padding(
		padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 8),
		child: TextFormField(
			style: TextStyle(color: Colors.white),
			autofocus: lblText == 'Phone Number' ? true : false,
			controller: txtController,
			keyboardType: keyType,
			inputFormatters: keyType == TextInputType.number
				? <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly]
				: null,
			obscureText: blnObscure,
			validator: (value) => textValidation(lblText, value),
			decoration: InputDecoration(
				labelText: lblText,
				labelStyle: TextStyle(color: Colors.grey [300], fontWeight: FontWeight.w500),
				hintText: hntText,
				hintStyle: TextStyle(color: Colors.grey [300], fontSize: 13, fontWeight: FontWeight.w400),
				prefixIcon: Icon(icnText, color: Colors.grey [300]),
				suffixIcon: _suffixIcon(lblText, blnObscure),
				fillColor: Colors.white,
				enabledBorder: greenBorder,
				focusedBorder: greenBorder,
				errorBorder: redBorder,
				focusedErrorBorder: redBorder
			),
		),
	);

	Widget signupButton(buttonText, styleText) {
		return _isSubmitting
		? Container()
		: Padding(
			padding: const EdgeInsets.only(top: 50),
			child: ButtonTheme(
				minWidth: 300,
				height: 50,
				child: RaisedButton(
					elevation: 5,
					color: Colors.green,
					child: Text(buttonText, style: styleText,),
					onPressed: () => _submit(),
					shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
				),
			),
		);
	}

	// Functions
	void _submit() {
		final form = _formKey.currentState;
		if (form.validate()) {
			_registerUser();
		} else {
			setState(() => _autoValidate = true);
		}
	}

	_suffixIcon(lblText, blnObscure) {
		if (lblText == 'Password' || lblText == 'Pin') {
			return IconButton(
				icon: Icon(blnObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey [300]),
				onPressed: () {
					lblText == 'Password'
						? setState(() => passwordVisible = !passwordVisible)
						: setState(() => pinVisible = !pinVisible);
				}
			);
		}
		return null;
	}

	textValidation(lblText, value) {
		if (value.isEmpty) {
			return '$lblText should not be empty';
		} else {
			switch (lblText) {
				case 'Phone Number':
					return value.length < 11 ? '$lblText must be 11 digits' : null;
				case 'School ID':
					return value.length < 6 ? '$lblText must be 6 digits' : null;
				case 'Name':
					return !value.contains(' ') ? 'Invalid Full $lblText' : null;
				case 'Email':
					Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
					RegExp regex = RegExp(pattern);
					return !regex.hasMatch(value) ? 'Invalid $lblText' : null;
				case 'Password':
					return value.length < 6 ? '$lblText must be 6 characters or longer' : null;
				case 'Pin':
					return value.length < 6 ? '$lblText must be 6 digits or longer' : null;
			}
		}
	}

	void _registerUser() async {
		setState(() => _isSubmitting = true);
		prgrsDlg.show();

		var data = json.encode({
				"phone"			: _phone.text,
				"studentId"	: _studentId.text,
				"name"			: _name.text,
				"email"			: _email.text,
				"password"	: _password.text,
				"pin"				: _pin.text
		});

		var returnResult = await userAPI.registerUser(data);
		returnResult = json.decode(returnResult);

		if (returnResult['statusCode'] == 200) {
			var result = returnResult['result'];
			if (result == 1) {
				progressIndicatorComplete(result, 'Account already exist');
			} else {
				_saveLocalDB();
			}
		} else {
			progressIndicatorComplete(0, returnResult['result']);
		}
	}

	void _saveLocalDB() async {
		user.date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
		user.phone     = _phone.text;
		user.studentId = _studentId.text;
		user.name      = _name.text;
		user.email     = _email.text;
		user.password  = _password.text;
		user.pin       = _pin.text;
		int result = await users.saveAccout(user);
		if (result == 1) {
			progressIndicatorComplete(result, 'Account already exist');
		} else {
			progressIndicatorComplete(result, 'Problem saving user');
		}
	}

	void progressIndicatorComplete(result, message) {
		Future.delayed(Duration(seconds: 2)).then((value) {
			prgrsDlg.hide().whenComplete(() {
				setState(() => _isSubmitting = false);
				(result > 1)
				? register.dialog(context, 'Thank you for signing up', setState, _phone.text,  _password.text)
				: register.showAlertDialog(context, (result > 0) ? 'Warning' : 'Error',  message);
			});
		});
	}

}
