import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class TransferMoney extends StatefulWidget {
  @override
  _TransferMoneyState createState() => _TransferMoneyState();
}

class _TransferMoneyState extends State<TransferMoney> {

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool pinVisible;

  @override
  void initState() {
    super.initState();
    pinVisible = true;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () { navigatePreviousPage(context); },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Transfer Money'),
          backgroundColor: Color(0xFF2c3e50),
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () => navigatePreviousPage(context),
          ),
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
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: Image.asset("assets/SmartPayIcons/Transfer.png", width: 400, height: 200)
                  ),
                  Container(
                    height: 460,
                    decoration: BoxDecoration(
                      color: Color(0xFF2c3e50),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: textFormField('Phone Number', 'Enter Phone Number', TextInputType.number),
                        ),
                        textFormField('Amount', 'Enter desired amount', TextInputType.number),
                        continueButton('Continue')
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

  var redBorder = outlineInputBorder(Colors.redAccent);

  var greenBorder = outlineInputBorder(Colors.greenAccent);

	static outlineInputBorder(color) => OutlineInputBorder(
		borderRadius: BorderRadius.circular(15),
		borderSide: BorderSide(color: color, width: 2)
	);

  Widget textFormField(lblText, hntText, keyType) => Padding(
    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
    child: TextFormField(
      autofocus: true,
      style: TextStyle(color: Colors.white),
      keyboardType: keyType,
			inputFormatters: keyType == TextInputType.number
				? <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly] : null,
      validator: (value) => textValidation(lblText, value),
      decoration: InputDecoration(
        labelText: lblText, labelStyle: TextStyle(color: Colors.grey [300]),
        hintText: hntText, hintStyle: TextStyle(color: Colors.grey [300], fontSize: 14),
        suffixIcon: _suffixIcon(lblText),
        enabledBorder: greenBorder,
        focusedBorder: greenBorder,
        errorBorder: redBorder,
        focusedErrorBorder: redBorder
      ),
    ),
  );

  Widget continueButton(buttonText) => Padding(
    padding: const EdgeInsets.only(top: 20),
    child: ButtonTheme(
      minWidth: 300, height: 50,
      child: RaisedButton(
        color: Colors.green,
        child: Text(buttonText, style: TextStyle(color: Colors.white, fontSize: 18),),
        onPressed: _submit,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    ),
  );

  void navigatePage(navTo) => Navigator.pushReplacementNamed(context, navTo);

	navigatePreviousPage(context) => Navigator.pushReplacementNamed(context, '/');

  _suffixIcon(lblText) => lblText.contains('Phone')
		? Icon(Icons.phone_android, color: Colors.grey[300]) : null;

  textValidation(lblText, value) {
		if (value.isEmpty) {
			return '$lblText should not be empty';
		} else {
			return ((lblText=='Phone Number') && (value.length < 11))
				? '$lblText must be 11 digits' : null;
		}
	}

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      navigatePage('/pinInput');
    } else {
      setState(() => _autoValidate = true);
    }
  }
  
  
  /*dialog() => showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      title: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text('TRANSFER MONEY', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text('CONFIRMATION', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(padding: const EdgeInsets.only(top: 20)),
          Text(
            'To proceed with your request, please enter your pin:',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)
					),
        ],
      ),
			content: TextFormField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Enter pin for payment',
          hintStyle: TextStyle(fontSize: 14),
          suffixIcon: IconButton(
            tooltip: 'Forgot Pin?',
              icon: Text('?', style: TextStyle(color: Colors.blue)),
              onPressed: () {},
            ),
          )
        ),
      actions: <Widget>[
            FlatButton(
            onPressed: () {},
            child: Text('Submit')
          )
      ]
      ),
  ); */

}
