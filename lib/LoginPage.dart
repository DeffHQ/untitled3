import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/HomePage.dart';

import 'fire_store_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  String? userUid;

  late final userEmail;
  Future<String> signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      print(userCredential.user!.uid);
      userUid = userCredential.user!.uid;
      userEmail = userCredential.user!.email;
      return 'Ok';
    } on FirebaseAuthException catch (e) {
      var errorMessage = 'Authentication failed';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        errorMessage = 'Wrong password provided for that user.';
      }
      return errorMessage;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('                    Login Page'),
          foregroundColor: Colors.black,
          backgroundColor: Colors.blue,
          titleSpacing: 0,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
          )),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: 'Email'),
              controller: emailController,
              validator: (value) {
                if (value!.contains('@') && value.contains('.com')) {
                  return null;
                }
                return 'invalid email';
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'password'),
              controller: passwordController,
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  return 'invalid password';
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  signIn();
                }
                ,
                child: Text('Login'))
          ],
        ),
      ),
    );
  }


}
