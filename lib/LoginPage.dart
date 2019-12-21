import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoginPage extends StatefulWidget {
  LoginPage({this.auth});
  final BaseAuth auth;
  @override
  LoginPageState createState() => LoginPageState();
}
enum FormType {
  login, register
}
class LoginPageState extends State<LoginPage> {

  String email;
  String password;
  final formKey = new GlobalKey<FormState>();
  FormType formType = FormType.login;
  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }
  void validateAndSubmit()async{
    if(validateAndSave()){
      try {
        if(formType == FormType.register){
          String uid = await widget.auth.createUserWithEmailAndPassword(email, password);
          //FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password,)).user;
          debugPrint('uid $uid');
          uid = await widget.auth.signInWithEmailAndPassword(email, password);
          debugPrint('uid2 $uid');
        }
        else {
          String uid = await widget.auth.signInWithEmailAndPassword(email, password);
          debugPrint('uid $uid');
        }
      }catch(e){
        debugPrint('Error $e');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Login (For Writers or Editors only)"),
      ),
      body: new SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: buildStuff(),
          ),
        ),
      ),
    );
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      formType = FormType.register;
    });
  }
  List<Widget> buildStuff(){
    if(formType == FormType.login){
      return [
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
        TextFormField(
          decoration: new InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (value) {
            if(value.isEmpty){
              return "Password can\'t be empty";
            }

            return null;
          },
          onSaved: (value) => password = value,
        ),
        RaisedButton(
          child: Text('Login', style: TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        RaisedButton(
          child: Text('Create an account',style: TextStyle(fontSize: 20.0),),
          onPressed: moveToRegister,
        ),
      ];
    }
    return [
      TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) {
          if(value.isEmpty){
            return "Email can\'t be empty";
          }
          else if(!(value.contains("@") || value.contains("."))){
            return "Email isn\'t formatted correctly";
          }
          email = value;
          return null;
        },
        onSaved: (value) => email = value,
      ),
      TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          if(value.isEmpty){
            return "Password can\'t be empty";
          }
          password = value;
          return null;
        },
        onSaved: (value) => password = value,
      ),
      RaisedButton(
        child: Text('Create Account', style: TextStyle(fontSize: 20.0)),
        onPressed: validateAndSubmit,
      ),
      RaisedButton(
        child: Text('Login to Account',style: TextStyle(fontSize: 20.0),),
        onPressed: moveToLogin,
      ),
    ];
  }
  void moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      formType = FormType.login;
    });
  }
}
