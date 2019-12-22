import 'package:flutter/material.dart';
import 'rootpage.dart';
import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Add extends StatefulWidget {
  BaseAuth auth;
  String title;
  String content;
  Add({this.auth, this.title, this.content});
  @override
  AddState createState() => AddState();

}

class AddState extends State<Add> {
  void signOut()async{
    try{
      await widget.auth.signOut();
      setState(() {
        RootPageState.authStatus = AuthStatus.notSignedIn;
      });
    }catch(e){
      debugPrint(e.toString());
    }
  }
  final formKey = GlobalKey<FormState>();
  String content;
  String title;
  String subtitle;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text("Add an article"),

        ),

        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Title"),
                  maxLength: 15,

                  onSaved: (value) => title = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Subtitle (Small Summary of Article)"),
                  maxLength: 50,

                  onSaved: (value) => subtitle = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Content"),

                  onSaved: (value) => content = value,
                ),
                RaisedButton(
                  child: Text("Submit"),

                  onPressed: submit,
                ),
              ],
            ),
          ),
        )
    );
  }

  void submit() async{
    final form = formKey.currentState;
    form.save();
    QuerySnapshot snapshot = await Firestore.instance.collection('users').where('uid', isEqualTo: RootPageState.uid).getDocuments();
    String name = snapshot.documents[0].data['name'];
    Firestore.instance.collection('articles').add({
      'approved' : false,
      'author' : name,
      'title' : title,
      'subtitle' : subtitle,
      'content' : content,
    });
    formKey.currentState.reset();
    Navigator.pop(context);
  }
}
