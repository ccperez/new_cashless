import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../controller/users_controller.dart';
import '../../../../../../controller/user_api_controller.dart';
import '../../../../../../utilities/registration_utilities.dart';

class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {

  UsersController users = UsersController();
	UserAPIController userAPI = UserAPIController();
	RegistrationUtilities register = RegistrationUtilities();

  final _formKey = GlobalKey<FormState>();
	final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _autoValidate = false;

  bool newPasswordVisible, cfmPasswordVisible;

  final _newPassword = TextEditingController();
	final _cfmPassword = TextEditingController();

  String _phone, _token;

  @override
  void initState() {
    super.initState();
		newPasswordVisible = true;
		cfmPasswordVisible = true;
  }

	void dispose() {
    super.dispose();
		_newPassword.dispose();
		_cfmPassword.dispose();
	}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { navigatePreviousPage(context); },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2c3e50),
          title: Text('Change Password'),
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () => navigatePreviousPage(context),),
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
                      text('Create a Strong Password', TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                    ],)
                  ),
                Container(
                  height: 480,
                  child: Column(children: <Widget>[
                    Padding(padding: const EdgeInsets.only(top: 20),),
                    textFormField(_newPassword, 'New Password', 'Enter New Password', newPasswordVisible),
                    textFormField(_cfmPassword, 'Confirm Password', 'Re-type Password', cfmPasswordVisible),
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
    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
    child: Text(txt, style: styleText),
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
    if (lblText == 'New Password' || lblText == 'Confirm Password') {
      return IconButton(
        icon: Icon(blnObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey[300],),
        onPressed: () {
          lblText == 'New Password'
            ? setState(() => newPasswordVisible = !newPasswordVisible)
            : setState(() => cfmPasswordVisible = !cfmPasswordVisible);
        },
      );
    }
  }

  textValidation(lblText, value) {
    if (value.isEmpty) {
      return '$lblText should not be empty';
    } else {
      switch (lblText) {
        case 'New Password':
          return value.length < 6 ? 'Password must be 6 characters or longer' : null;
				case 'Confirm Password':
					return _newPassword.text != value ? 'Password does not match' : null;
      }
    }
  }

  pswdSccsful() => showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
    ),
    title: Column(
      children: <Widget>[
      Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
      Padding(padding: const EdgeInsets.only(top: 8)),
      Text('Password changed succesfully!', style: TextStyle(fontSize: 16),)
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
      _chngePass();
		} else {
			setState(() => _autoValidate = true);
		}
	}

  void _chngePass() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(preferences.getString("user"));

    setState(() {
      _phone = userInfo["phone"];
      _token = preferences.getString("token");
    });

		var returnResult = await userAPI.resetSecure('PW', _token, _newPassword.text, _cfmPassword.text);
		returnResult = json.decode(returnResult);

		Future.delayed(Duration(seconds: 1), () async {
			setState(() => _isLoading = false);
			if (returnResult['statusCode'] == 200) {
				int result = returnResult['result'];
				if (result == 3) {
					result = await users.resetSecure('PW', _phone, _newPassword.text);
					if (result == 1) {
						_formKey.currentState.reset();
						pswdSccsful();
					} else {
						register.snackBarShow(scaffoldKey, 'Problem changing password');
					}
				}
			} else {
				register.snackBarShow(scaffoldKey, returnResult['error']);
			}
		});
  }

  void navigatePreviousPage(context) => Navigator.pushReplacementNamed(context, '/editProfile');

}
