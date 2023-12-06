import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit/screens/dashboard.dart';
import 'package:habit/services/db.dart';

class AuthService {
  var db = Db();
  createUser(data1, context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data1['email'],
        password: data1['password'],
      );
      await db.addUser(data1, context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sign up Failed'),
            content: Text(
              e.toString(),
            ),
          );
        },
      );
    }
  }

  login(data, context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Login Error'),
            content: Text(
              e.toString(),
            ),
          );
        },
      );
    }
  }
}
