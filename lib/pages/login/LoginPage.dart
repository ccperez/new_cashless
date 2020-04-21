import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../../controller/user_api_controller.dart';
import '../../services/response/login_response.dart';
import '../../utilities/registration_utilities.dart';

import '../../pages/dashboard/dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }
class _LoginPageState extends State<LoginPage> implements LoginCallBack {

	User user = User('', '', '', '', '', '', '', 0);

	LoginStatus _loginStatus = LoginStatus.notSignIn;
	UserAPIController userAPI = UserAPIController();
	RegistrationUtilities register = RegistrationUtilities();

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

	String _phone, _password;

  bool passwordVisible = true;
	bool _autoValidate = false;

	var signIn;

	LoginResponse _response;

  _LoginPageState() { _response = LoginResponse(this); }

  @override
  void initState() {
    super.initState();
    getPref();
  }

	@override
  void onLoginError(String error) {
    setState(() => _isLoading = false);
		register.snackBarShow(scaffoldKey, error);
  }

  @override
  void onLoginSuccess(User user) async {

    if (user != null) {
			_loginStatus = LoginStatus.signIn;
			register.savePref(setState, 1, user.name, user);
    } else {
      setState(() => _isLoading = false);
			register.snackBarShow(scaffoldKey, "Invalid credentials");
    }
  }

	@override
  Widget build(BuildContext context) {
	  switch (_loginStatus) {
			case LoginStatus.signIn:
				return Dashboard(signOut);
				break;
    	default:
				return Scaffold(
					key: scaffoldKey,
					body: Form(
						key: _formKey,
						autovalidate: _autoValidate,
						  child: Stack(
						  	fit: StackFit.expand,
						  	children: <Widget>[
						  		ListView(
						  			children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 200, bottom: 20, left: 40, right: 40),
                        child: Image.asset('assets/SmartPayIcons/SmartPay.png'),
                      ),
						  				Container(
                          height: 490,
                          decoration: BoxDecoration(
                            color: Color(0xFF2c3e50),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                          ),
						  						child: Column(
						  							mainAxisAlignment: MainAxisAlignment.center,
						  							children: <Widget>[
						  								textFormField(Icons.person, 'Phone Number', TextInputType.number),
						  								textFormField(Icons.lock, 'Password', TextInputType.text),
						  								Row(
						  									mainAxisAlignment: MainAxisAlignment.spaceBetween,
						  									children: <Widget>[
						  										linkButton('Sign Up', () => navigatePage('/register')),
						  										linkButton('Forgot Password?', () => navigatePage('/forgetPassword')),
						  									],
						  								),
						  								loginButton('Sign In', TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
						  							],
						  						),
						  					),
						  			],
						  		),
						  	],
						  ),
						),
				);
		}
	}

  var redBorder = OutlineInputBorder(
				borderRadius: BorderRadius.circular(15),
				borderSide: BorderSide(color: Colors.redAccent, width: 2)
			);

  var greenBorder = OutlineInputBorder(
				borderRadius: BorderRadius.circular(15),
				borderSide: BorderSide(color: Colors.greenAccent, width: 2)
			);


  Widget linkButton(txtLink, onClick) => Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: FlatButton(
      onPressed: onClick,
      child: Text(txtLink, style: TextStyle(fontSize: 12, color: Colors.greenAccent [400])),
    )
  );


  Widget textFormField(icnText, hntText, keyType) => Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
    child: TextFormField(
      style: TextStyle(color: Colors.white),
      keyboardType: keyType,
			inputFormatters: keyType == TextInputType.number
				? <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly]
				: null,
      obscureText: hntText == 'Password' ? passwordVisible : false,
			onSaved: (value) => updateTextFormField(hntText, value),
      validator: (String value,) => textValidation(hntText, value),
      decoration: InputDecoration(
        hintText: hntText,
        hintStyle: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.w500),
        prefixIcon: Icon(icnText, color: Colors.grey[300]),
        suffixIcon: hntText == 'Password'
					? IconButton(
							icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility, color: Colors.grey[300]),
							onPressed: () => setState(() => passwordVisible = !passwordVisible)
						)
					: Icon(Icons.phone_android, color: Colors.grey[300]),
        errorBorder: redBorder,
        focusedErrorBorder: redBorder,
        enabledBorder: greenBorder,
        focusedBorder: greenBorder
      ),
    ),
  );

  // Login Button
  Widget loginButton(buttonText, styleText) {
		return _isLoading
      ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)
        )
      : Padding(
					padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
          child: ButtonTheme(
            minWidth: 300,
            height: 50,
            child: RaisedButton(
              elevation: 5,
              color: Colors.green,
              child: Text(buttonText, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),),
              onPressed: () => _submit(),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)
            ),
          ),
          )
        );
	}


	// Functions
  void _submit() {
    var form = _formKey.currentState;
    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _signIn();
    } else {
      setState(() => _autoValidate = true);
		}
  }

	void _signIn() async {
		var returnResult = await userAPI.signIn(_phone, _password);
		returnResult = json.decode(returnResult);

		Future.delayed(Duration(seconds: 1), () {
			if (returnResult['statusCode'] == 200) {
				int result = returnResult['result'];
				if (result == 1) {
					_response.doLogin(_phone, _password);
				} else if (result == 3) {
					setState(() => _isLoading = false);
					register.dialog(context, 'Account not yet confirmed', setState, _phone,  _password);
				}
			} else {
				setState(() => _isLoading = false);
				register.snackBarShow(scaffoldKey, returnResult['result']);
			}
		});
  }

  textValidation(hntText, value) {
		if (value.isEmpty) {
			return '$hntText should not be empty';
		} else {
			switch (hntText) {
				case 'Phone Number':
					return (value.length < 11) ? '$hntText should be 11 digits' : null;
				case 'Password':
					return (value.length < 6) ? '$hntText must be 6 characters or longer' : null;
			}
		}
  }

  void updateTextFormField(lblText, txtValue) {
		lblText == 'Password' ? _password     = txtValue : _phone     = txtValue;
		lblText == 'Password' ? user.password = txtValue : user.phone = txtValue;
	}

	void navigatePage(navTo) =>
		Navigator.pushReplacementNamed(context, navTo);

	getPref() async {
		SharedPreferences preferences = await SharedPreferences.getInstance();
		setState(() {
			signIn = preferences.getInt("signIn");
      _loginStatus = signIn == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
		});
	}

	signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
			_isLoading = false;
			preferences.setInt("signIn", null);
			preferences.setString("name", null);
			preferences.setString("user", null);
			_loginStatus = LoginStatus.notSignIn;
    });
  }

}
