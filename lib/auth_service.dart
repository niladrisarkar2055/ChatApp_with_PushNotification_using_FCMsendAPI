import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:listview_in_blocpattern/database_manager.dart';


//This is authetication class
class AuthService {
  final FirebaseAuth _firebaseAuth;
  AuthService(this._firebaseAuth);//Constructor 

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges(); //for seeing if the user is logged in or not 

  //Function for signing out 
  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return "Signed Out!";
    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }
  
  //Function for signing in 
  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return "Signed In";
    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }
  
  //Fucntion for signing up 
  Future<String> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Registered new User!";
    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }

  
}
