import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../controller/user_api_controller.dart';
import '../../../../../../utilities/registration_utilities.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

	UserAPIController userAPI = UserAPIController();
  RegistrationUtilities register = RegistrationUtilities();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  var _phone, _fullname, _email , _confirmationCode;

  bool _isLoading = false;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(preferences.getString("user"));
		setState(() {
      _fullname = preferences.getString("name");
      _phone    = userInfo["phone"];
      _email    = userInfo["email"];
		});
  }

  @override
	void initState() {
		super.initState();
		getPref();
	}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { navigatePreviousPage(context); },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2c3e50),
          title: Text('Profile'),
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () => navigatePreviousPage(context),
          ),
        ),
        key: scaffoldKey,
        body: Stack(
            fit:StackFit.expand,
            children: <Widget>[
              ListView(
                children: <Widget>[
                  title('Name'),
                  card(_fullname, Icon(Icons.edit, color: Colors.grey), () => navigatePage('/changeName')),
                  title('Phone Number'),
                  card(securePhone(_phone), Icon(Icons.phone_android, color: Colors.grey), null),
                  title('Email'),
                  card(_email, Icon(Icons.email, color: Colors.grey), null),
                  title('Password'),
                  card('********', Icon(Icons.edit, color: Colors.grey), () => _verifyForgetPassword('Password')),
                  title('Pin'),
                  card('********', Icon(Icons.edit, color: Colors.grey), () =>  _verifyForgetPassword('Pin')),
									circularProgressIndicator(),
                ],
              )
            ],
          ),
        ),
    );
  }

  Widget title(txt) => Padding(
    padding:const EdgeInsets.only(top: 20, left: 10),
    child: Text(txt, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
  );

  Widget card(listTxt, suffixIcon, goTo) => Card(
    elevation: 5,
    color: Colors.white,
    child: ListTile(
      trailing: suffixIcon,
      onTap: goTo,
      title: Text(listTxt, style: TextStyle(color: Colors.grey),),
    ),
  );

	Widget circularProgressIndicator() => _isLoading
		? Padding(
				padding: const EdgeInsets.all(20.0),
				child: Container(
					alignment: Alignment.center,
					child: CircularProgressIndicator(
						valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)
					)
				)
			)
		: Container();

	void navigatePage(navTo) => Navigator.pushReplacementNamed(context, navTo);

  void navigatePreviousPage(context) => Navigator.pushReplacementNamed(context, '/');

	securePhone(phone) {
		return phone == null ? "" : phone.replaceRange(4, 9, '*' * 5);
	}

  void _verifyForgetPassword(String txtLabel) async {
		setState(() => _isLoading = true);
  	var returnResult = await userAPI.verifyForgetPassword(_phone);
		returnResult = json.decode(returnResult);
		Future.delayed(Duration(seconds: 1), () {
			setState(() => _isLoading = false);
			if (returnResult['statusCode'] == 200) {
				int result = returnResult['result'];
				if (result == 1) cfmDialog(txtLabel);
			} else {
				register.snackBarShow(scaffoldKey, returnResult['result']);
			}
		});
  }

void _verifyConfirmationCode(String navFor) async {
		var returnResult = await userAPI.verifyConfirmationCode(_confirmationCode);
		returnResult = json.decode(returnResult);

    if (returnResult['statusCode'] == 200) {
			int result = returnResult['result']['result'];
			if (result == 2) {
				savePref(returnResult['result']['token']);
        navigatePage(navFor=='Password' ? '/changePass' : '/changePin');
			}
		} else {
			register.showAlertDialog(context, 'Error', returnResult['result']);
		}
  }

  savePref(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() => preferences.setString("token", token));
  }

  cfmDialog(String txtLabel) => showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
    ),
    title: Column(children: <Widget>[
      Text('Change $txtLabel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      Padding(padding: const EdgeInsets.only(top: 10)),
      Text('To proceed with your request, please enter your confirmation code sent to your email:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
    ],),
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
      FlatButton(
        child: Text('SUBMIT'),
        onPressed: () => _verifyConfirmationCode(txtLabel),
      )
    ],
  ));
}
