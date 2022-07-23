import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/mainScreens/main/main_page.dart';

import '../widgets/userAuth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //final user = FirebaseAuth.instance.currentUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(27, 27, 27, 1),
      body: StreamBuilder<User?>(
          //streambuilder ensures that as long as user did not click log out button, they will always stay signed in
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //print('Successfully logged in!');
              return MainPage();
            } else {
              return AuthPage();
            }
          }),
    );
  }
}
