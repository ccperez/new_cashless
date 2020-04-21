import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../controller/loadtype_api_controller.dart';
import './LoadWalletQR.dart';

class LoadWallet extends StatefulWidget {
  @override
  _LoadWalletState createState() => _LoadWalletState();
}

class _LoadWalletState extends State<LoadWallet> {

	LoadTypeAPIController loadTypeAPI = LoadTypeAPIController();

  var _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
	int _amount, _loadType = 0;

	// var _lstType = ['Allowance', 'Tuition'];
	var _lstType = [];

	getLoadType() async {
		var returnResult = await loadTypeAPI.loadType();
		returnResult = json.decode(returnResult);
		if (returnResult['statusCode'] == 200) {
			var load = returnResult['result'];
			for (var i = 0; i < load.length; i++) {
				setState(() => _lstType.add(load[i]['type']));
			}
		}
	}

	@override
  void initState() {
    super.initState();
		getLoadType();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { navigatePreviousPage(context); },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2c3e50),
          title: Text('Load Wallet'),
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () { navigatePreviousPage(context); } ),
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
                      margin: EdgeInsets.symmetric(vertical: 50),
                      child: Image.asset("assets/SmartPayIcons/Load.png", width: 400, height: 200)
                    ),
                    Container(
                      height: 420,
                      decoration: BoxDecoration(
                        color: Color(0xFF2c3e50),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                      ),
                      child: Column(
                        children: <Widget>[
                          amountFormField('Amount'),
                          loadTypeList(),
                          continueButton()
                        ],
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

  var redBorder = outlineInputBorder(Colors.redAccent);

  var greenBorder = outlineInputBorder(Colors.greenAccent);

	static outlineInputBorder(color) => OutlineInputBorder(
		borderRadius: BorderRadius.circular(15),
		borderSide: BorderSide(color: color, width: 2)
	);

  Widget amountFormField(lblText) => Padding(
    padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
    child: TextFormField(
      style: TextStyle(color: Colors.white),
			onSaved: (value) => setState(() => _amount = int.parse(value)),
      validator: (value) => value.isEmpty ? '$lblText should not be empty' : null,
      decoration: InputDecoration(
        labelText: lblText, hintText: 'Enter amount to load to your account',
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        hintStyle: TextStyle(color: Colors.grey [300], fontSize: 12),
        enabledBorder: greenBorder,
        focusedBorder: greenBorder,
        errorBorder: redBorder,
        focusedErrorBorder: redBorder
      ),
    ),
  );

  Widget loadTypeList() {
		return Padding(
			padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
			child: DropdownButtonFormField(
				decoration: InputDecoration(
					labelText: 'Load Wallet For',
					labelStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
					enabledBorder: greenBorder,
					focusedBorder: greenBorder
				),
				items: _lstType.map((type) => DropdownMenuItem<int>(
					value: _lstType.indexOf(type), child: Text(type, style: TextStyle(color: Colors.grey))
				)).toList(),
				value: _loadType,
				onChanged: (value) => setState(() => _loadType = value)
			)
  	);
	}

  Widget continueButton() => Padding(
    padding: const EdgeInsets.only(top: 60),
    child: ButtonTheme(
      minWidth: 300, height: 50,
      child: RaisedButton(
        color: Colors.green,
        child: Text('Continue', style: TextStyle(color: Colors.white, fontSize: 18),),
        onPressed: _submit,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      )
    )
  );

  void _submit() {
    final form = _formKey.currentState;
    if(form.validate()) {
			form.save();
			_generateQRCode();
    } else {
      setState(() => _autoValidate = true);
    }
  }

	_generateQRCode() async {
		SharedPreferences preferences = await SharedPreferences.getInstance();
		var userInfo = json.decode(preferences.getString("user"));
		var load = json.encode({
			"phone"  : userInfo["phone"],
			"amount" : _amount,
			"type"   : _loadType
		});
		Navigator.push(context, MaterialPageRoute(
			builder: (context) => LoadWalletQR(json.decode(load), _lstType)
		));
	}

  void navigatePage(navTo) => Navigator.pushReplacementNamed(context, navTo);

  void navigatePreviousPage(context) => Navigator.pushReplacementNamed(context, '/');
}
