import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../controller/users_controller.dart';
import '../../../../../../controller/user_api_controller.dart';
import '../../../../../../utilities/registration_utilities.dart';

class ChangeName extends StatefulWidget {
  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {

  UsersController users = UsersController();
	UserAPIController userAPI = UserAPIController();
  RegistrationUtilities register = RegistrationUtilities();

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autoValidate = false;
  bool _isLoading = false;

  var _phone, _currentname, _newname;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(preferences.getString("user"));
		setState(() {
      _phone       = userInfo["phone"];
      _currentname = preferences.getString("name");
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
          title: Text('Edit Name'),
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () {navigatePreviousPage(context);}),
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
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 30),
                    child: Image.asset("assets/SmartPayIcons/Name.png", width: 200, height: 200),
                  ),
                  Container(
                    height: 458.5,
                    child: Column(children: <Widget>[
                      text('Current Name: $_currentname'),
                      textFormField('New Name', 'Enter Full Name'),
                      saveBtn('Save Changes')
                    ],),
                    decoration: BoxDecoration(
                      color: Color(0xFF2c3e50),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                    ),
                  )
                ],
              )
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

  Widget text(listTxt) => Padding(
    padding: const EdgeInsets.only(top: 30),
    child: Text(listTxt, style: TextStyle(color: Colors.grey[300], fontSize: 13, fontWeight: FontWeight.w500))
  );

  Widget textFormField(lblText, hntText) => Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
    child: TextFormField(
      style: TextStyle(color: Colors.white),
      autofocus: true,
      onSaved: (value) => _newname = value,
      validator: (value) => textValidation(hntText, value),
      decoration: InputDecoration(
        labelText: lblText, labelStyle: TextStyle(color: Colors.grey[300], fontSize: 15, fontWeight: FontWeight.w500),
        hintText: hntText, hintStyle: TextStyle(color: Colors.grey[300], fontSize: 15),
				errorStyle: TextStyle(fontSize: 16.0),
        enabledBorder: greenBorder,
        focusedBorder: greenBorder,
        errorBorder: redBorder,
        focusedErrorBorder: redBorder
      ),
    ),
  );

  Widget saveBtn(btnText) {
		return _isLoading
      ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)
        )
    	: Padding(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          child: ButtonTheme(
            minWidth: 300,
            height: 50,
            child: RaisedButton(
              color: Colors.green,
              child: Text(btnText, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
              onPressed: _submit,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
        );
  }

  textValidation(hntText, value) {
    if (value.isEmpty) {
      return '$hntText should not be empty';
    } else {
      if(!value.contains(' ')) {
        return 'Invalid Full Name';
      }
    }
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() => _isLoading = true);
      _updateFullname();
    } else {
      setState(() => _autoValidate = true);
    }
  }

	void _updateFullname() async {
		var returnResult = await userAPI.updateFullname(_phone, _newname);
  	returnResult = json.decode(returnResult);
		Future.delayed(Duration(seconds: 1), () async {
			setState(() => _isLoading = false);
			if (returnResult['statusCode'] == 200) {
				int result = returnResult['result'];
				if (result == 1) {
					result = await users.updateFullname(_phone, _newname);
					if (result == 1) {
						SharedPreferences preferences = await SharedPreferences.getInstance();
						setState(() {
							preferences.setString("name", _newname); _currentname = _newname;
						});
						dialog();
					} else {
						register.snackBarShow(scaffoldKey, 'Problem updating fullname');
					}
				}
			} else {
				register.snackBarShow(scaffoldKey, returnResult['result']);
			}
		});
  }

  dialog() => showDialog(
    context: context, builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: IconButton(icon: Icon(Icons.check_circle_outline),
        disabledColor: Colors.green, iconSize: 60, onPressed: null
      ),
      content: Text('Name changed successfully!',style: TextStyle(fontSize: 16)),
      actions: <Widget>[
        FlatButton(
          child: Text('OKAY'), onPressed: () => navigatePage('/editProfile'),
        )
      ],
    )
  );

  void navigatePage(navTo) => Navigator.pushReplacementNamed(context, navTo);

  void navigatePreviousPage(context) => Navigator.pushReplacementNamed(context, '/editProfile');

}
