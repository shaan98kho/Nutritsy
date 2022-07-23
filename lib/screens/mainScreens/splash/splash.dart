import 'package:flutter/material.dart';
import 'dart:async';

import '../access/access.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 4),
      () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Access()),
        (_) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
      body: /*StreamBuilder<User?>(
            //streambuilder ensures that as long as user did not click log out button, they will always stay signed in
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //print('Successfully logged in!');
                return MainPage();
              } else {
                //return AuthPage();
                return*/
          Container(
        constraints: const BoxConstraints.expand(
          height: double.infinity,
        ),
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(0, 230, 0, 0),
        child: Column(
          children: [
            //alignment: Alignment.center,
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 300,
                maxHeight: 200,
              ),
              child: Image.asset(
                'assets/images/welcome/logo.jpg',
                //width: MediaQuery.of(context).size.width - 54,
                //either use ^, or use constrainedbox()
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            const SizedBox(
              child: TextButton(
                onPressed: null,
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    color: Color.fromRGBO(215, 255, 217, 1),
                    fontFamily: 'Gaegu-Regular',
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      /*}
            })*/
    );
  }
}
