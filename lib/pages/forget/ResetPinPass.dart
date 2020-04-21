import 'package:flutter/material.dart';

class ResetPinPass extends StatefulWidget {
  @override
  _ResetPinPassState createState() => _ResetPinPassState();
}

class _ResetPinPassState extends State<ResetPinPass> {
  
  var _formKey = GlobalKey<FormState>();

  bool pinPassVisible, _pinPassVisible;
  bool _autoValidate = false;

  final TextEditingController _pinPass = TextEditingController();
  final TextEditingController _confirmPinPass = TextEditingController();

  @override
  void initState() {
    super.initState();
		pinPassVisible = true;
		_pinPassVisible = true;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SmartPay'),
        centerTitle: true,
        backgroundColor: Colors.green[900],
      ),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                      ),
                      text('Reset Pin or Password', TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      text('Kindly create a new pin or password to sign in.', TextStyle(fontSize: 16, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                      textFormField('New Pin/Password', 'Enter New Pin/Password', pinPassVisible, _pinPass),
                      textFormField('Confirm Pin/Password', 'Re-type Pin Password', _pinPassVisible, _confirmPinPass),
                      continueButton('Continue', TextStyle(fontSize: 25, fontWeight: FontWeight.w300))
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

  Widget text(txt, styleText) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Text(txt, style: styleText),
  );

  Widget textFormField(lblText, hntText, blnObscure, txtController) => Padding(
    padding: const EdgeInsets.only(top: 30),
    child: TextFormField(
      controller: txtController,
      validator: (String value) => textValidation(lblText, value),
      obscureText: blnObscure,
      decoration: InputDecoration(
        labelText: lblText,
        hintText: hntText,
        suffixIcon: _suffixIcon(lblText, blnObscure),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    ),
  );

  Widget continueButton(buttonText, styleText) => Padding(
    padding: const EdgeInsets.only(top: 40),
    child: Material(
      color: Colors.green,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => _submit(),
        child: Center(
          child: Text(buttonText, style: styleText),
        ),
      ),
    ),
  );

  _suffixIcon(lblText, blnObscure) {
    if (lblText == 'New Pin/Password' || lblText == 'Confirm Pin/Password') {
      return IconButton(
        icon: Icon(blnObscure ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          lblText == 'New Pin/Password'
            ? setState(() => pinPassVisible = !pinPassVisible)
            : setState(() => _pinPassVisible = !_pinPassVisible);
        },
      );
    }
  }

  textValidation(lblText, value) {
    if(value.isEmpty) {
      return '$lblText should not be empty';
    } else {
      switch (lblText) {
        case 'New Pin/Password':
          return value.length < 6 ? 'Pin/Password must be 6 characters or longer' : null;
          break;

        case 'Confirm Pin/Password':
          return value != _pinPass.text ? 'Pin/Password does not match' : null;
          break;
      }
    }
  }

  void _submit() {
		final form = _formKey.currentState;
		if (form.validate()) {
			form.save();
			_save();
		} else {
			setState(() => _autoValidate = true);
		}
	}

  void _save() async {
    setState(() => navigatePage('/login'));
  }

  void navigatePage(navTo) => Navigator.pushReplacementNamed(context, navTo);

}