import 'dart:async';

import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
//import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Auth change user stream
  Stream<CustomUser?> get user {
    return _auth.authStateChanges().map((User? user) {
      if (user != null) {
        return _customUserFromUser(user);
      } else {
        return null; // L'utilisateur est déconnecté, donc retournez null
      }
    });
  }

// Méthode pour convertir un User en CustomUser
  CustomUser? _customUserFromUser(User user) {
    return CustomUser(uid: user.uid);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _customUserFromUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _customUserFromUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register in with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).updateUserData('0','new crew member', 100);

      return _customUserFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
