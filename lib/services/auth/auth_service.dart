import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  //instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // sign user in
  Future<UserCredential> signInWithEmailPassword(
      String email, String password, name) async {
    try {
      // sign in
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      //add a new document for the user in users collection uf it doesn't already exists
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));

      return userCredential;
    } // catch any error
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// create a new user
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password, );

      //after creating the user, create a new document for the user in the user collection
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name' : name,
      }, SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign up/in with google
  Future<bool> signInWithGoogle() async {
    bool result = false;
    try{
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      //  return await FirebaseAuth.instance.signInWithCredential(credential);

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;

      if(user != null){
        if(userCredential.additionalUserInfo!.isNewUser){
          //add the data to fire base
          await _fireStore.collection('users').doc(user.uid).set(
            {
              'name' : user.displayName,
              'uid' : user.uid,
              'profilePhoto' : user.photoURL,
            }
          );
        }
      }
      result = true;
    } catch (e){
      print(e);
    }
    return result;
  }

// sign user out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
