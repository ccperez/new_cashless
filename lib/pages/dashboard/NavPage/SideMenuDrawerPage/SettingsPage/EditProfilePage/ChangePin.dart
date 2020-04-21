import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../controller/users_controller.dart';
import '../../../../../../controller/user_api_controller.dart';
import '../../../../../../utilities/registration_utilities.dart';

class ChangePin extends StatefulWidget {
  @override
  _ChangePinState createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {

  UsersController users = UsersController();
	UserAPIController userAPI = UserAPIController();
	RegistrationUtilities register = RegistrationUtilities();

  final _formKey = GlobalKey<FormState>();
	final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _autoValidate = false;

  bool newPinVisible, cfmPinVisible;

  final _newPin = TextEditingController();
	final _cfmPin = TextEditingController();

  @override
  void initState() {
    super.initState();
		newPinVisible = true;
		cfmPinVisible = true;
  }

	void dispose() {
    super.dispose();
		_newPin.dispose();
		_cfmPin.dispose();
	}

  String _phone, _token;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { navigatePreviousPage(context); },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2c3e50),
          title: Text('Change Pin'),
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () => navigatePreviousPage(context),
          ),
        ),
        key: scaffoldKey,
        body: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              ListView(children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Column(children: <Widget>[
                      Padding(padding: const EdgeInsets.only(top: 180)),
                      text('Create a Strong Pin', TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                    ],)
                  ),
                Container(
                  height: 480,
                  child: Column(children: <Widget>[
                    Padding(padding: const EdgeInsets.only(top: 20)),
                    textFormField(_newPin, 'New Pin', 'Enter New Pin', newPinVisible),
                    textFormField(_cfmPin, 'Confirm Pin', 'Re-type Pin', cfmPinVisible),
                    saveBtn('Save Changes', TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400))
                  ],),
                  decoration: BoxDecoration(
                      color: Color(0xFF2c3e50),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                    ),
                )
              ],)
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

  Widget text(txt, styleText) => Padding(
    padding: const EdgeInsets.only(top: 5, bottom: 20),
    child: Text(txt, style: styleText,),
  );

  Widget textFormField(txtController, lblText, hntText, blnObscure) => Padding(
    padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
    child: TextFormField(
      style: TextStyle(color: Colors.white),
			controller: txtController,
      validator: (value) => textValidation(lblText, value),
      obscureText: blnObscure,
      decoration: InputDecoration(
        labelText: lblText,
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        hintText: hntText,
        hintStyle: TextStyle(color: Colors.grey[300], fontSize: 15),
        suffixIcon: _suffixIcon(lblText, blnObscure),
        focusedBorder: greenBorder,
        enabledBorder: greenBorder,
        errorBorder: redBorder,
        focusedErrorBorder: redBorder
      ),
    ),
  );

  Widget saveBtn(btnText, styleText) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: _isLoading
				? CircularProgressIndicator(
					valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
				)
				: Padding(
					padding: const EdgeInsets.only(top: 30),
					child: ButtonTheme(
						minWidth: 300,
						height: 50,
						child: RaisedButton(
							elevation: 5,
							color: Colors.green,
							child: Text(btnText, style: styleText),
							onPressed: () => _submit(),
							shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
						),
					),
				)
			);
  }

  _suffixIcon(lblText, blnObscure) {
    if (lblText == 'New Pin' || lblText == 'Confirm Pin') {
      return IconButton(
        icon: Icon(blnObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey[300],),
        onPressed: () {
          lblText == 'New Pin'
            ? setState(() => newPinVisible = !newPinVisible)
            : setState(() => cfmPinVisible = !cfmPinVisible);
        },
      );
    }
  }

  textValidation(lblText, value) {
    if (value.isEmpty) {
      return '$lblText should not be empty';
    } else {
      switch (lblText) {
        case 'New Pin':
          return value.length < 6 ? 'Pin must be 6 digits or longer' : null;
				case 'Confirm Pin':
					return _newPin.text != value ? 'Pin does not match' : null;
      }
    }
  }

  pinSccsful() => showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
    ),
    title: Column(
      children: <Widget>[
      Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
      Padding(padding: const EdgeInsets.only(top: 15)),
      Text('Pin changed succesfully!', style: TextStyle(fontSize: 16),)
    ],),
    actions: <Widget>[
      FlatButton(
        child: Text('OKAY'),
        onPressed: () => navigatePreviousPage(context),
      )
    ],
    ),
  );

  void _submit() {
		final form = _formKey.currentState;
		if (form.validate()) {
			setState(() => _isLoading = true);
      _chngePin();
		} else {
			setState(() => _autoValidate = true);
		}
	}

  void _chngePin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(preferences.getString("user"));

    setState(() {
      _phone = userInfo["phone"];
      _token = preferences.getString("token");
    });

		var returnResult = await userAPI.resetSecure('PN', _token, _newPin.text, _cfmPin.text);
		returnResult = json.decode(returnResult);

		Future.delayed(Duration(seconds: 1), () async {
			setState(() => _isLoading = false);
			if(returnResult['statusCode'] == 200) {
				int result = returnResult['result'];
				if (result == 3) {
					result = await users.resetSecure('PN', _phone, _newPin.text);
					if (result == 1) {
						_formKey.currentState.reset();
						pinSccsful();
					} else {
						register.snackBarShow(scaffoldKey, 'Problem changing pin');
					}
				}
			} else {
				register.snackBarShow(scaffoldKey, returnResult['result']);
			}
		});
  }

  void navigatePreviousPage(context) => Navigator.pushReplacementNamed(context, '/editProfile');
}
