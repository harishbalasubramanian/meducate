import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
class ForgotPassword extends StatefulWidget {
  BaseAuth auth;
  ForgotPassword({this.auth});
  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  String email;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Forgot Password ? "),
      ),
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: new InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if(value.isEmpty){
                    return "Email can\'t be empty";
                  }
                  if(!(value.contains("@") || value.contains("."))){
                    return "Email isn\'t formatted correctly";
                  }
                  return null;
                },
                onSaved: (value) => email = value,
              ),
              RaisedButton(
                child: Text("Send Reset Email"),
                onPressed: validateAndSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
  bool validate(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }
  void validateAndSubmit() {
    if(validate()){
        widget.auth.resetPassword(email);
    }
    formKey.currentState.reset();
  }
}
