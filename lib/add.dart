import 'package:flutter/material.dart';
import 'rootpage.dart';
import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Add extends StatefulWidget {
  BaseAuth auth;
  Add({this.auth});
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

        body: Container(
          padding: EdgeInsets.all(8.0),
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
                    maxLines: null,
                    onSaved: (value) => content = value,
                  ),
                  RawMaterialButton(
                    child: Text("Submit",style: TextStyle(fontSize: 16.5, color: Colors.white)),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    fillColor: Colors.deepPurpleAccent,
                    elevation: 0.0,
                    padding: EdgeInsets.all(10.0),
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
    List articleList = new List();
    if(snapshot.documents[0].data['articles'] != null){
      articleList.addAll(snapshot.documents[0].data['articles']);
    }
    articleList.add(title);
    Firestore.instance.collection('articles').add({
      'approved' : false,
      'author' : name,
      'title' : title,
      'subtitle' : subtitle,
      'content' : content,
    });
    Firestore.instance.collection('users').document(snapshot.documents[0].documentID).setData({
      'approved' : snapshot.documents[0].data['approved'],
      'email' : snapshot.documents[0].data['email'],
      'name' : snapshot.documents[0].data['name'],
      'status' : snapshot.documents[0].data['status'],
      'uid':snapshot.documents[0].data['uid'],
      'articles' : articleList,
    });
    formKey.currentState.reset();
    Navigator.pop(context);
  }
}
