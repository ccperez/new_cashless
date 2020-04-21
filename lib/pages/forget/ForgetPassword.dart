import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/user_api_controller.dart';
import '../../utilities/registration_utilities.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

	UserAPIController userAPI = UserAPIController();
	RegistrationUtilities register = RegistrationUtilities();

  final _formKey = GlobalKey<FormState>();
	final scaffoldKey = GlobalKey<ScaffoldState>();

	String _phone;
	String _confirmationCode;

	bool _isLoading = false;
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { register.navigatePreviousPage(context); },
      child: Scaffold(
        backgroundColor: Color(0xFF2c3e50),
        appBar: AppBar(
          title: Text('Forgot Password'),
          backgroundColor: Color(0xFF2c3e50),
          leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: () { register.navigatePreviousPage(context); },)
        ),
				key: scaffoldKey,
        body: Form(
          key: _formKey,
          autovalidate: _autoValidate,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
									ListView(
									  children: <Widget>[
                      Column(
									  	  children: <Widget>[
									  		  Padding(padding: const EdgeInsets.only(top: 200)),
									  		  textFormField('Phone Number','Enter phone number you used to sign in', TextInputType.number),
									  		  continueButton('Continue', TextStyle(color: Colors. white, fontSize: 18, fontWeight: FontWeight.w400)),
									  	  ],
									    ),
                    ]
									),
                	]
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

  Widget textFormField(lblText, hntText, keyType) => Padding(
    padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
    child: TextFormField(
      style: TextStyle(color: Colors.white),
      keyboardType: keyType,
			autofocus: true,
			onSaved: (value) => _phone = value,
      validator: (String value) => textValidation(value),
      decoration: InputDecoration(
        labelText: lblText, labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        hintText: hntText, hintStyle: TextStyle(color: Colors.grey[300], fontSize: 12),
        focusedBorder: greenBorder,
        errorBorder: redBorder,
        focusedErrorBorder:redBorder
      ),
    ),
  );

  Widget continueButton(buttonText, styleText) {
		return Padding(
		  padding: const EdgeInsets.only(top: 20),
		  child: _isLoading
      ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)

        )
    	: Padding(
		  			padding: const EdgeInsets.only(top: 30),
		  			child: ButtonTheme(
            minWidth: 300,
            height: 50,
            child: RaisedButton(
              color: Colors.green,
              child: Text(buttonText, style: styleText),
              onPressed: () => _submit(),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
		  		),
		);
	}

  textValidation(value) {
    return (value.isEmpty)
			? 'Phone Number  should not be empty'
			: (value.length < 11) ? 'Phone Number must be 11 digits' : null;
	}

	void updateTextFormField(lblText, txtValue) {
		if (lblText == 'Phone')  _phone = txtValue;
	}

  void navigatePage(navTo){
    Navigator.pushReplacementNamed(context, navTo);
  }

  void _submit() {
		final form = _formKey.currentState;
		if (form.validate()) {
			setState(() => _isLoading = true);
			form.save();
			_verifyForgetPassword();
		} else {
			setState(() => _autoValidate = true);
		}
	}

	void _verifyForgetPassword() async {
		var returnResult = await userAPI.verifyForgetPassword(_phone);
		returnResult = json.decode(returnResult);

		Future.delayed(Duration(seconds: 1), () {
			setState(() => _isLoading = false);
			if (returnResult['statusCode'] == 200) {
				int result = returnResult['result'];
				if (result == 1) dialog();
			} else {
				register.snackBarShow(scaffoldKey, returnResult['reslt']);
			}
		});
  }

	void _verifyConfirmationCode() async {
		var returnResult = await userAPI.verifyConfirmationCode(_confirmationCode);
		returnResult = json.decode(returnResult);

    if (returnResult['statusCode'] == 200) {
			int result = returnResult['result']['result'];
			if (result == 2) {
				savePref(_phone, returnResult['result']['token']);
        Navigator.pushReplacementNamed(context, '/resetPassword');
			}
		} else {
			register.showAlertDialog(context, 'Error', returnResult['result']);
		}
  }

  savePref(String phone, String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
			preferences.setString("phone", phone);
      preferences.setString("token", token);
    });
  }

	dialog() => showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      title: Column(
        children: <Widget>[
          Text('RESET PASSWORD', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Padding(padding: const EdgeInsets.only(top: 10)),
          Text(
            'To proceed with your request, please enter your confirmation code sent to your email:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)
					),
        ],
      ),
			content: TextField(
				autofocus: true,
				onChanged: (value) { _confirmationCode = value; },
				decoration: InputDecoration(
					hintText: 'Enter Confirmation Code',
					hintStyle: TextStyle(fontSize: 12),
					prefixIcon: Icon(Icons.code),
					enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
				),
			),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              child: Text('Submit'),
              onPressed: () => _verifyConfirmationCode(),
            )
          ],
        ),
      ],
    )
  );
}
