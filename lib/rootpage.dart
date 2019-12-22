import 'LoginPage.dart';
import 'auth.dart';
import 'package:flutter/material.dart';
import 'writer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Nope.dart';
import 'editor.dart';
import 'admin.dart';
class RootPage extends StatefulWidget {
  BaseAuth auth;
  RootPage({this.auth});
  @override
  RootPageState createState() => RootPageState();
}
enum AuthStatus{
  notSignedIn,
  signedIn
}
enum Status{
  writer,
  editor,
  admin,
  none
}
enum Approved{
  approved,
  notApproved
}
class RootPageState extends State<RootPage> {

  static AuthStatus authStatus = AuthStatus.notSignedIn;
  static Status status = Status.none;
  static Approved approved = Approved.notApproved;
  static String uid = "";
  @override
  void initState(){
    super.initState();
    widget.auth.currentUser().then((userId){
      setState(() {
        authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }
  void signedIn(){
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("users").where('uid', isEqualTo: RootPageState.uid).snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){

        switch(authStatus) {
          case AuthStatus.notSignedIn:
            return LoginPage(auth: widget.auth, onSignedIn: signedIn,);
            break;
          case AuthStatus.signedIn:
            if (!snapshot.hasData) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text("Loading"),
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                  body: Center(child: CircularProgressIndicator(),)
              );
            }
            else {
              Map<String, dynamic> map = snapshot.data.documents.length > 0 ? snapshot.data.documents[0].data : null;
              if(map == null){
                return Scaffold(
                    appBar: AppBar(
                      title: Text("Loading"),
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    body: Center(child: CircularProgressIndicator(),)
                );
              }
              else {
                switch (map['approved']) {
                  case true:
                    if (status == Status.writer || map['status'] == 'writer') {
                      status = Status.writer;
                      return Writer(auth: widget.auth, onSignedOut: signedOut,);
                    }
                    else
                    if (status == Status.editor || map['status'] == 'editor') {
                      status = Status.editor;
                      return Editor(auth: widget.auth, onSignedOut: signedOut,);
                    }
                    else
                    if (status == Status.admin || map['status'] == 'admin') {
                      status = Status.admin;
                      return Admin(auth: widget.auth, onSignedOut: signedOut);
                    }
                    break;
                  case false:
                    return Nope(auth: widget.auth, onSignedOut: signedOut,);
                    break;
                }
              }

              break;
            }
        }
        return Text("Nothin");
      }
    );
  }

  void signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }
}
