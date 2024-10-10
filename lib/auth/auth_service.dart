import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_task/storage/shared_preferences.dart';

class AuthService{
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithPassword(String email,String password) async{

    try{
      final cred= await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return cred.user;
    }catch(e){
      return null;
    }

  }


  Future<User?> logincreateUserWithPassword(String email,String password,context) async{
    try{
      final cred= await _auth.signInWithEmailAndPassword(email: email, password: password).then((onValue){}).
      onError((error, stackTrace){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            duration:  const Duration(seconds: 2),
          ),
        );
      });
      return cred.user;
    }catch(e){
      return null;
    }

  }

  Future<UserCredential?> loginWithGoogle() async{
    try{
      final googleUser= await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = await GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken,
          accessToken: googleAuth?.accessToken);
      String? access = googleAuth?.accessToken;
      UserSharedPreferences.setUserAccessToken(access!);
      return await _auth.signInWithCredential(cred);
    }catch(e){
      return null;
    }

  }
}