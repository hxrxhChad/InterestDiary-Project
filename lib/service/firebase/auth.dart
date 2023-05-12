import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khatadiary/common/style.dart';
import 'package:khatadiary/page/auth-page.dart';
import 'package:khatadiary/page/control-page.dart';
import 'package:khatadiary/widget/function/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/auth-model.dart';

String authId = FirebaseAuth.instance.currentUser!.uid;

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> create(context, String email, String password) async {
  try {
    final user = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .whenComplete(() => addAuth(context, email, password));
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("email", email);
    replace(context, const ControlPage());
  } on FirebaseAuthException catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> login(context, String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("email", email);
    replace(context, const ControlPage());
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Hello, New User',
              style: style(context).copyWith(
                  fontSize: kPad(context) * 0.05, fontWeight: FontWeight.bold)),
          content: Text(
            'Click the Sign up button given below to Register or Sign Up your new Account.',
            style: style(context).copyWith(color: darkC.withOpacity(0.5)),
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: style(context).copyWith(
                    color: Colors.blueAccent,
                    fontSize: kPad(context) * 0.05,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }
}

Future<bool> userExists() async {
  return (await FirebaseFirestore.instance.collection('user').doc(authId).get())
      .exists;
}

Future<void> signOut(context) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Sign out',
          style: style(context).copyWith(
              fontSize: kPad(context) * 0.05, fontWeight: FontWeight.bold)),
      content: Text(
        'Do you really want to Sign Out?',
        style: style(context).copyWith(color: darkC.withOpacity(0.5)),
      ),
      actions: [
        TextButton(
          child: Text(
            'No',
            style: style(context).copyWith(
                color: Colors.redAccent,
                fontSize: kPad(context) * 0.05,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(
            'Yes',
            style: style(context).copyWith(
                color: Colors.blueAccent,
                fontSize: kPad(context) * 0.05,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.remove("email");
            replace(context, const AuthPage());
          },
        ),
      ],
    ),
  );
}

addAuth(context, email, password) {
  Auth auth = Auth(email: email, password: password);

  final authRef = FirebaseFirestore.instance
      .collection('user')
      .doc(authId); // when about -> doc('about')

  auth.id = authRef.id;
  final data = auth.toMap();
  try {
    authRef.set(data).whenComplete(() => debugPrint('Completed'));
  } catch (e) {
    debugPrint(e.toString());
  }
}
