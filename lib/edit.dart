import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'rootpage.dart';
class Edit extends StatefulWidget {
  String title;
  String subtitle;
  String content;
  Edit({this.title, this.subtitle, this.content});
  @override
  EditState createState() => EditState();
}

class EditState extends State<Edit> {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController titleEditor = new TextEditingController();
  TextEditingController subtitleEditor = new TextEditingController();
  TextEditingController contentEditor = new TextEditingController();
  String title;
  String subtitle;
  String content;
  @override
  Widget build(BuildContext context) {

    titleEditor.text = widget.title;
    subtitleEditor.text = widget.subtitle;
    contentEditor.text = widget.content;
      return Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            title: Text("Edit your article"),

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
                    controller: titleEditor,
                    onSaved: (value) => title = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Subtitle (Small Summary of Article)"),
                    maxLength: 50,
                    controller: subtitleEditor,
                    onSaved: (value) => subtitle = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Content"),
                    maxLines: null,
                    controller: contentEditor,
                    onSaved: (value) => content = value,
                  ),
                  RawMaterialButton(
                    child: Text("Submit",style: TextStyle(fontSize: 16.5, color: Colors.white)),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    fillColor: Colors.deepPurpleAccent,
                    elevation: 0.0,
                    padding: EdgeInsets.all(10.0),
                    onPressed: reSubmit,
                  ),
                ],
              ),
            ),
          )
      );
  }

  void reSubmit() async{
    debugPrint('starting now');
    final form = formKey.currentState;
    form.save();
    QuerySnapshot snapshot = await Firestore.instance.collection('users').where('uid', isEqualTo: RootPageState.uid).getDocuments();
    String name = snapshot.documents[0].data['name'];
    List articleList = new List();
//    if(snapshot.documents[0].data['articles'] != null){
//      articleList.addAll(snapshot.documents[0].data['articles']);
//    }
    int length = snapshot.documents[0].data['articles'] != null ? snapshot.documents[0].data['articles'].length : 0;
    int i = 0;
    int delIndex = snapshot.documents[0].data['articles'].indexOf(widget.title);
    //debugPrint('delIndex $delIndex');
    while(snapshot.documents[0].data['articles'] != null && i < length){
      if(i == delIndex){
        i++;
        continue;
      }
      articleList.add(snapshot.documents[0].data['articles'][i]);
      i++;
    }
    articleList.add(title);
    QuerySnapshot snap = await Firestore.instance.collection('articles').where('author',isEqualTo: name).where('title',isEqualTo: widget.title).getDocuments();

    Firestore.instance.collection('articles').document(snap.documents[0].documentID).setData({
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
