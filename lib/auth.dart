import 'package:firebase_auth/firebase_auth.dart';
import 'rootpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password,String name);
  Future<String> currentUser();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}

class Auth implements BaseAuth{
  Future<String> signInWithEmailAndPassword(String email, String password)async{
    FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password));
    Firestore.instance.collection('users').where('uid',isEqualTo:user.uid).getDocuments().then((snapshot){
      if(snapshot.documents[0].data['approved']){
        RootPageState.approved = Approved.approved;
        switch(snapshot.documents[0].data['status']){
          case "writer":
            RootPageState.status = Status.writer;
            break;
          case "editor":
            RootPageState.status = Status.editor;
            break;
          case 'admin':
            RootPageState.status = Status.admin;
            break;
        }
      }
      else{
        RootPageState.approved = Approved.notApproved;
      }
    });
    RootPageState.authStatus = AuthStatus.signedIn;
    RootPageState.uid = user.uid;
    return user.uid;
  }
  Future<String> createUserWithEmailAndPassword(String email, String password, String name)async{
    FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password));
    user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password));
    Firestore.instance.collection('users').add({
      'name' : name,
      'status' : 'writer',
      'approved' : false,
      'email' : email,
      'uid' : user.uid,
    });
    RootPageState.status = Status.writer;
    RootPageState.approved = Approved.notApproved;
    RootPageState.authStatus = AuthStatus.signedIn;
    RootPageState.uid = user.uid;
    return user.uid;
  }
  Future<String> currentUser() async{
    FirebaseUser user = (await FirebaseAuth.instance.currentUser());
    Firestore.instance.collection('users').where('uid',isEqualTo:user.uid).getDocuments().then((snapshot){
      if(snapshot.documents[0].data['approved']){
        RootPageState.approved = Approved.approved;
        switch(snapshot.documents[0].data['status']){
          case "writer":
            RootPageState.status = Status.writer;
            break;
          case "editor":
            RootPageState.status = Status.editor;
            break;
          case 'admin':
            RootPageState.status = Status.admin;
            break;
        }
      }
      else{
        RootPageState.approved = Approved.notApproved;
      }
    });
    RootPageState.authStatus = AuthStatus.signedIn;
    RootPageState.uid = user.uid;
    return user.uid;
  }
  Future<void> signOut(){
    RootPageState.authStatus = AuthStatus.notSignedIn;
    RootPageState.uid = "";
    RootPageState.status = Status.none;
    RootPageState.approved = Approved.notApproved;
    return FirebaseAuth.instance.signOut();
  }
  Future<void> resetPassword(String email){
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}