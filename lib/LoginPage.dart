import 'package:flutter/material.dart';
import 'auth.dart';
import 'ForgotPassword.dart';
import 'rootpage.dart';
class LoginPage extends StatefulWidget {
  LoginPage({this.auth,this.onSignedIn});
  final BaseAuth auth;
  VoidCallback onSignedIn;
  @override
  LoginPageState createState() => LoginPageState();
}
enum FormType {
  login, register
}
class LoginPageState extends State<LoginPage> {
  bool passCheck = false;
  String email;
  String name;
  bool isLoading = false;
  GlobalKey<ScaffoldState> scaffold = new GlobalKey<ScaffoldState>();
  String password;
  String secondPassword;
  bool error;
  final formKey = new GlobalKey<FormState>();
  FormType formType = FormType.login;
  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    setState(() {
      isLoading = false;
    });
    return false;
  }
  void validateAndSubmit()async{
    setState(() {
      isLoading = true;
    });
    if(validateAndSave()){
      try {
        if(formType == FormType.register){
          String uid = await widget.auth.createUserWithEmailAndPassword(email, password,name);
          //FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password,)).user;
          debugPrint('uid $uid');
          uid = await widget.auth.signInWithEmailAndPassword(email, password);

          setState(() {
            RootPageState.authStatus = AuthStatus.signedIn;
            debugPrint('authStatus ${RootPageState.authStatus}');
            isLoading = false;
          });

        }
        else {
          String uid = await widget.auth.signInWithEmailAndPassword(email, password);
          debugPrint('uid $uid');

          setState(() {
            isLoading = false;
          });

        }
        widget.onSignedIn();
      }catch(e){
        debugPrint('Error $e');
        await makeDialog(e.toString());
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  Future<void> makeDialog(String e){
    bool a;
    if(e == "PlatformException(exception, There is no user record corresponding to this identifier. The user may have been deleted., null)"){
      a = true;
    }
    else{
      a = false;
    }
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: a ? Text("This user is not recognized") : Text("An error occurred"),
        actions: <Widget>[
          Center(child: FlatButton(
            child: Text("OK",style: TextStyle(color: Colors.deepPurpleAccent)),
            onPressed: (){
              Navigator.pop(context);
            }
          )),
        ],
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return !isLoading ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Login (For Writers only)"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: buildStuff(),
          ),
        ),
      ) ,
    ): Scaffold(
        appBar: AppBar(
          title: Text("Loading"),
          leading: Container(),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Center(child: CircularProgressIndicator(),)
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
                  decoration: new InputDecoration(
                      labelText: 'Password',
                      suffixIcon: Container(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: FlatButton(
                          child: Text(
                            "Forgot Password ?",style: TextStyle(color: Colors.deepPurpleAccent),
                          ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPassword(auth: widget.auth)));
                          }
                        ),
                      ),
                  ),
                  obscureText: true,

                  validator: (value) {
                    if(value.isEmpty){
                      return "Password can\'t be empty";
                    }

                    return null;
                  },
                  onSaved: (value) => password = value,
                ),
//            Text("Forgot Password ?",style: TextStyle(fontSize: 10.0),),


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
        decoration: new InputDecoration(labelText: 'Name'),
        validator: (value) {
          if(value.isEmpty){
            return "Name can\'t be empty";
          }

          name = value;
          return null;
        },
        onSaved: (value) => email = value,
      ),
      TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) {
          if(value.isEmpty){
            return "Email can\'t be empty";
          }
          else if(!(value.contains("@") || value.contains("."))){
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
          passCheck = true;
          password = value;
          return null;
        },
        onSaved: (value) => password = value,
      ),
      TextFormField(
        decoration: new InputDecoration(labelText: 'Confirm Password'),
        obscureText: true,
        validator: (value) {
          if(value.isEmpty){
            return "Password can\'t be empty";
          }
          while(!passCheck){
            continue;
          }
          if(value != password){
            return "Passwords do not match";
          }
          return null;
        },
        onSaved: (value) => secondPassword = value,
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
